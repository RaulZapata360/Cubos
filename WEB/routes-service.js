// ============================================
// ROUTES SERVICE - Google Maps Integration
// ============================================
// Handles route calculations, distance, time, and fuel consumption
// Uses Google Maps Distance Matrix API with intelligent caching

import { supabaseClient } from './supabase-client.js';

class RoutesService {
    constructor() {
        this.apiKey = null; // Will be set from config
        this.cacheDurationMinutes = 30;
        this.defaultFuelEfficiency = 3.5; // km/L
        this.currentObraId = null;
    }

    /**
     * Initialize service with API key and obra ID
     */
    init(apiKey, obraId) {
        this.apiKey = apiKey;
        this.currentObraId = obraId;
    }

    /**
     * Get route data between origin and destination
     * Uses cache if available and fresh, otherwise queries Google Maps API
     * @param {string} origenId - UUID of origen
     * @param {string} destinoId - UUID of destino
     * @returns {Promise<Object>} Route data with distance, time, and traffic time
     */
    async obtenerDatosRuta(origenId, destinoId) {
        try {
            // Check cache first
            const cachedData = await this.getCachedRouteData(origenId, destinoId);

            if (cachedData && this.isCacheFresh(cachedData.consultado_at)) {
                console.log('✅ Using cached route data');
                return {
                    distancia_km: parseFloat(cachedData.distancia_km),
                    tiempo_minutos: cachedData.tiempo_estimado_minutos,
                    tiempo_con_trafico_minutos: cachedData.tiempo_con_trafico_minutos,
                    fromCache: true
                };
            }

            // Cache miss or expired - fetch from Google Maps
            console.log('🌐 Fetching fresh route data from Google Maps API');
            const freshData = await this.fetchFromGoogleMaps(origenId, destinoId);

            // Save to cache
            await this.saveToCache(origenId, destinoId, freshData);

            return {
                ...freshData,
                fromCache: false
            };

        } catch (error) {
            console.error('Error getting route data:', error);

            // If API fails but we have cached data (even if expired), use it
            const cachedData = await this.getCachedRouteData(origenId, destinoId);
            if (cachedData) {
                console.warn('⚠️ Using expired cache due to API error');
                return {
                    distancia_km: parseFloat(cachedData.distancia_km),
                    tiempo_minutos: cachedData.tiempo_estimado_minutos,
                    tiempo_con_trafico_minutos: cachedData.tiempo_con_trafico_minutos,
                    fromCache: true,
                    expired: true
                };
            }

            throw error;
        }
    }

    /**
     * Fetch route data from Google Maps Distance Matrix API
     */
    async fetchFromGoogleMaps(origenId, destinoId) {
        if (!this.apiKey) {
            throw new Error('Google Maps API key not configured');
        }

        // Get origin and destination addresses
        const { origen, destino } = await this.getAddresses(origenId, destinoId);

        if (!origen.direccion || !destino.direccion) {
            throw new Error('Origin or destination address not configured');
        }

        // Build API URL
        const url = new URL('https://maps.googleapis.com/maps/api/distancematrix/json');
        url.searchParams.append('origins', origen.direccion);
        url.searchParams.append('destinations', destino.direccion);
        url.searchParams.append('mode', 'driving');
        url.searchParams.append('departure_time', 'now');
        url.searchParams.append('traffic_model', 'best_guess');
        url.searchParams.append('key', this.apiKey);

        // Make request through a proxy to avoid CORS (or use backend endpoint)
        // For now, we'll use the Google Maps JavaScript API instead
        const service = new google.maps.DistanceMatrixService();

        return new Promise((resolve, reject) => {
            service.getDistanceMatrix({
                origins: [origen.direccion],
                destinations: [destino.direccion],
                travelMode: google.maps.TravelMode.DRIVING,
                drivingOptions: {
                    departureTime: new Date(),
                    trafficModel: google.maps.TrafficModel.BEST_GUESS
                }
            }, (response, status) => {
                if (status !== 'OK') {
                    reject(new Error(`Google Maps API error: ${status}`));
                    return;
                }

                const element = response.rows[0].elements[0];

                if (element.status !== 'OK') {
                    reject(new Error(`Route not found: ${element.status}`));
                    return;
                }

                resolve({
                    distancia_km: element.distance.value / 1000, // Convert meters to km
                    tiempo_minutos: Math.round(element.duration.value / 60), // Convert seconds to minutes
                    tiempo_con_trafico_minutos: element.duration_in_traffic
                        ? Math.round(element.duration_in_traffic.value / 60)
                        : Math.round(element.duration.value / 60)
                });
            });
        });
    }

    /**
     * Get addresses for origin and destination from database
     * Supports origenes, destinos, and obras tables
     */
    async getAddresses(origenId, destinoId) {
        // Helper function to get location from any table
        const getLocation = async (id) => {
            // Try origenes first
            let result = await supabaseClient
                .from('origenes')
                .select('nombre, direccion, latitud, longitud')
                .eq('id', id)
                .single();

            if (!result.error) return result.data;

            // Try destinos
            result = await supabaseClient
                .from('destinos')
                .select('nombre, direccion, latitud, longitud')
                .eq('id', id)
                .single();

            if (!result.error) return result.data;

            // Try obras
            result = await supabaseClient
                .from('obras')
                .select('nombre, direccion, latitud, longitud')
                .eq('id', id)
                .single();

            if (!result.error) return result.data;

            throw new Error(`Location not found: ${id}`);
        };

        const [origen, destino] = await Promise.all([
            getLocation(origenId),
            getLocation(destinoId)
        ]);

        return { origen, destino };
    }

    /**
     * Get cached route data from database
     * Supports routes with obras by checking type fields
     */
    async getCachedRouteData(origenId, destinoId, origenTipo = null, destinoTipo = null) {
        let query = supabaseClient
            .from('datos_rutas')
            .select('*')
            .eq('origen_id', origenId)
            .eq('destino_id', destinoId);

        // Add type filters if provided
        if (origenTipo) query = query.eq('origen_tipo', origenTipo);
        if (destinoTipo) query = query.eq('destino_tipo', destinoTipo);

        const { data, error } = await query.single();

        if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
            console.error('Error fetching cached route:', error);
            return null;
        }

        return data;
    }

    /**
     * Check if cached data is still fresh
     */
    isCacheFresh(consultadoAt) {
        const cacheAge = Date.now() - new Date(consultadoAt).getTime();
        const maxAge = this.cacheDurationMinutes * 60 * 1000;
        return cacheAge < maxAge;
    }

    /**
     * Save route data to cache
     * Automatically detects if locations are obras or origenes/destinos
     */
    async saveToCache(origenId, destinoId, routeData) {
        try {
            // Detect location types by checking which table they belong to
            const origenTipo = await this.detectLocationType(origenId);
            const destinoTipo = await this.detectLocationType(destinoId);

            const { error } = await supabaseClient
                .from('datos_rutas')
                .upsert({
                    obra_id: this.currentObraId,
                    origen_id: origenId,
                    destino_id: destinoId,
                    origen_tipo: origenTipo,
                    destino_tipo: destinoTipo,
                    distancia_km: routeData.distancia_km,
                    tiempo_estimado_minutos: routeData.tiempo_minutos,
                    tiempo_con_trafico_minutos: routeData.tiempo_con_trafico_minutos,
                    consultado_at: new Date().toISOString()
                }, {
                    onConflict: 'origen_id,destino_id,origen_tipo,destino_tipo'
                });

            if (error) {
                // Ignore schema errors (migración pendiente) to avoid spamming console
                if (error.code === 'PGRST204' || error.code === '42703' || error.code === '406') {
                    // console.warn('Cache schema update pending (skipping save):', error.message);
                    return;
                }
                console.warn('Error saving to cache:', error.message);
            }
        } catch (e) {
            console.warn('Silent cache save error:', e.message);
        }
    }

    /**
     * Detect if a location ID belongs to obra, origen, or destino
     */
    async detectLocationType(locationId) {
        // Try obra first (most common for predefined routes)
        const obraCheck = await supabaseClient
            .from('obras')
            .select('id')
            .eq('id', locationId)
            .single();

        if (!obraCheck.error) return 'obra';

        // Try origenes
        const origenCheck = await supabaseClient
            .from('origenes')
            .select('id')
            .eq('id', locationId)
            .single();

        if (!origenCheck.error) return 'origen';

        // Must be destino
        return 'destino';
    }

    /**
     * Calculate fuel consumption
     * @param {number} distanciaKm - Distance in kilometers
     * @param {number} rendimientoKmPorLitro - Fuel efficiency in km/L
     * @returns {number} Fuel consumption in liters
     */
    calcularCombustible(distanciaKm, rendimientoKmPorLitro = this.defaultFuelEfficiency) {
        if (!distanciaKm || distanciaKm <= 0) return 0;
        if (!rendimientoKmPorLitro || rendimientoKmPorLitro <= 0) {
            rendimientoKmPorLitro = this.defaultFuelEfficiency;
        }
        return parseFloat((distanciaKm / rendimientoKmPorLitro).toFixed(2));
    }

    /**
     * Get predefined routes based on configured locations
     * Returns all possible routes: origenes->obra and obra->destinos
     */
    async obtenerRutasPredeterminadas() {
        try {
            // Get obra location
            const { data: obra, error: obraError } = await supabaseClient
                .from('obras')
                .select('id, nombre, direccion, latitud, longitud')
                .eq('id', this.currentObraId)
                .single();

            if (obraError) throw obraError;

            // Verify obra has location configured
            if (!obra.direccion || !obra.latitud || !obra.longitud) {
                console.warn('Obra location not configured');
                return [];
            }

            // Get all origenes (canteras/áridos)
            const { data: origenes, error: origenesError } = await supabaseClient
                .from('origenes')
                .select('id, nombre, direccion, latitud, longitud')
                .eq('obra_id', this.currentObraId)
                .is('deleted_at', null);

            if (origenesError) throw origenesError;

            // Get all destinos (botaderos)
            const { data: destinos, error: destinosError } = await supabaseClient
                .from('destinos')
                .select('id, nombre, direccion, latitud, longitud')
                .eq('obra_id', this.currentObraId)
                .is('deleted_at', null);

            if (destinosError) throw destinosError;

            const routes = [];

            // Create routes: Origenes -> Obra (for incoming trips)
            for (const origen of origenes) {
                if (!origen.direccion || !origen.latitud || !origen.longitud) {
                    console.warn(`Origin ${origen.nombre} has no location configured`);
                    continue;
                }

                try {
                    // Leg 1: Origen -> Obra (Ida/Carga)
                    const routeDataIda = await this.obtenerDatosRuta(origen.id, obra.id);

                    // Leg 2: Obra -> Origen (Vuelta/Regreso)
                    const routeDataVuelta = await this.obtenerDatosRuta(obra.id, origen.id);

                    routes.push({
                        origen: origen.nombre,
                        destino: obra.nombre,
                        tipo: 'incoming',
                        // One Way Data (Ida)
                        distancia_km: routeDataIda.distancia_km,
                        tiempo_estimado_minutos: routeDataIda.tiempo_minutos,
                        tiempo_con_trafico_minutos: routeDataIda.tiempo_con_trafico_minutos,

                        // Return Leg Data (Vuelta)
                        distancia_regreso_km: routeDataVuelta.distancia_km,
                        tiempo_regreso_minutos: routeDataVuelta.tiempo_minutos,
                        tiempo_regreso_con_trafico_minutos: routeDataVuelta.tiempo_con_trafico_minutos,

                        // Round Trip Totals (Total)
                        distancia_total_km: (parseFloat(routeDataIda.distancia_km) + parseFloat(routeDataVuelta.distancia_km)).toFixed(1),
                        tiempo_total_minutos: routeDataIda.tiempo_minutos + routeDataVuelta.tiempo_minutos,
                        tiempo_total_con_trafico_minutos: routeDataIda.tiempo_con_trafico_minutos + routeDataVuelta.tiempo_con_trafico_minutos,

                        count: 0, // No trips yet
                        num_camiones: 0,
                        isPredefined: true
                    });
                } catch (error) {
                    console.error(`Error getting route ${origen.nombre} -> ${obra.nombre}:`, error);
                }
            }

            // Create routes: Obra -> Destinos (for outgoing trips)
            for (const destino of destinos) {
                if (!destino.direccion || !destino.latitud || !destino.longitud) {
                    console.warn(`Destination ${destino.nombre} has no location configured`);
                    continue;
                }

                try {
                    // Leg 1: Obra -> Destino (Ida/Descarga)
                    const routeDataIda = await this.obtenerDatosRuta(obra.id, destino.id);

                    // Leg 2: Destino -> Obra (Vuelta/Regreso)
                    const routeDataVuelta = await this.obtenerDatosRuta(destino.id, obra.id);

                    routes.push({
                        origen: obra.nombre,
                        destino: destino.nombre,
                        tipo: 'outgoing',
                        // One Way Data (Ida)
                        distancia_km: routeDataIda.distancia_km,
                        tiempo_estimado_minutos: routeDataIda.tiempo_minutos,
                        tiempo_con_trafico_minutos: routeDataIda.tiempo_con_trafico_minutos,

                        // Return Leg Data (Vuelta)
                        distancia_regreso_km: routeDataVuelta.distancia_km,
                        tiempo_regreso_minutos: routeDataVuelta.tiempo_minutos,
                        tiempo_regreso_con_trafico_minutos: routeDataVuelta.tiempo_con_trafico_minutos,

                        // Round Trip Totals (Total)
                        distancia_total_km: (parseFloat(routeDataIda.distancia_km) + parseFloat(routeDataVuelta.distancia_km)).toFixed(1),
                        tiempo_total_minutos: routeDataIda.tiempo_minutos + routeDataVuelta.tiempo_minutos,
                        tiempo_total_con_trafico_minutos: routeDataIda.tiempo_con_trafico_minutos + routeDataVuelta.tiempo_con_trafico_minutos,

                        count: 0, // No trips yet
                        num_camiones: 0,
                        isPredefined: true
                    });
                } catch (error) {
                    console.error(`Error getting route ${obra.nombre} -> ${destino.nombre}:`, error);
                }
            }

            return routes;

        } catch (error) {
            console.error('Error getting predefined routes:', error);
            return [];
        }
    }

    /**
     * Get active routes for today
     * Returns routes that have been used today with trip counts
     */
    async obtenerRutasActivas(fecha = null) {
        if (!fecha) {
            fecha = new Date().toISOString().split('T')[0];
        }

        try {
            // Get all movements for the date
            const { data: movements, error } = await supabaseClient
                .from('movimientos')
                .select(`
                    id,
                    origen,
                    destino,
                    tipo,
                    distancia_km,
                    tiempo_estimado_minutos,
                    camion_id
                `)
                .eq('obra_id', this.currentObraId)
                .eq('fecha', fecha)
                .not('destino', 'eq', 'Interno')
                .not('origen', 'eq', 'Interno');

            if (error) throw error;

            // Group by route (origen-destino combination)
            const routesMap = new Map();

            for (const mov of movements) {
                // Only process movements with both origen and destino
                if (!mov.origen || !mov.destino) continue;

                const routeKey = `${mov.origen}|${mov.destino}`;

                if (!routesMap.has(routeKey)) {
                    routesMap.set(routeKey, {
                        origen: mov.origen,
                        destino: mov.destino,
                        tipo: mov.tipo,
                        count: 0,
                        distancia_km: mov.distancia_km,
                        tiempo_estimado_minutos: mov.tiempo_estimado_minutos,
                        camiones: new Set()
                    });
                }

                const route = routesMap.get(routeKey);
                route.count++;
                route.camiones.add(mov.camion_id);
            }

            // Convert to array and add truck count
            const routes = Array.from(routesMap.values()).map(route => ({
                ...route,
                num_camiones: route.camiones.size,
                camiones: undefined // Remove Set object
            }));

            // Sort by trip count (most used first)
            routes.sort((a, b) => b.count - a.count);

            return routes;

        } catch (error) {
            console.error('Error getting active routes:', error);
            return [];
        }
    }

    /**
     * Get traffic status indicator based on time difference
     * @param {number} tiempoNormal - Normal time in minutes
     * @param {number} tiempoConTrafico - Time with traffic in minutes
     * @returns {Object} Status with color and label
     */
    getTrafficStatus(tiempoNormal, tiempoConTrafico) {
        if (!tiempoConTrafico || !tiempoNormal) {
            return { color: 'gray', label: 'Desconocido', emoji: '⚪' };
        }

        const delay = tiempoConTrafico - tiempoNormal;
        const delayPercent = (delay / tiempoNormal) * 100;

        if (delayPercent < 15) {
            return { color: 'green', label: 'Fluido', emoji: '🟢' };
        } else if (delayPercent < 40) {
            return { color: 'yellow', label: 'Moderado', emoji: '🟡' };
        } else {
            return { color: 'red', label: 'Pesado', emoji: '🔴' };
        }
    }

    /**
     * Calculate total fuel consumption for a date
     */
    async calcularCombustibleTotal(fecha = null) {
        if (!fecha) {
            fecha = new Date().toISOString().split('T')[0];
        }

        const { data, error } = await supabaseClient
            .from('movimientos')
            .select('combustible_estimado_litros')
            .eq('obra_id', this.currentObraId)
            .eq('fecha', fecha)
            .not('combustible_estimado_litros', 'is', null);

        if (error) {
            console.error('Error calculating total fuel:', error);
            return 0;
        }

        return data.reduce((sum, mov) => sum + parseFloat(mov.combustible_estimado_litros || 0), 0);
    }
}

// Export singleton instance
export const rutasService = new RoutesService();

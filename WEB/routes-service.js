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
     */
    async getAddresses(origenId, destinoId) {
        const [origenResult, destinoResult] = await Promise.all([
            supabaseClient.from('origenes').select('nombre, direccion, latitud, longitud').eq('id', origenId).single(),
            supabaseClient.from('destinos').select('nombre, direccion, latitud, longitud').eq('id', destinoId).single()
        ]);

        if (origenResult.error) throw origenResult.error;
        if (destinoResult.error) throw destinoResult.error;

        return {
            origen: origenResult.data,
            destino: destinoResult.data
        };
    }

    /**
     * Get cached route data from database
     */
    async getCachedRouteData(origenId, destinoId) {
        const { data, error } = await supabaseClient
            .from('datos_rutas')
            .select('*')
            .eq('origen_id', origenId)
            .eq('destino_id', destinoId)
            .single();

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
     */
    async saveToCache(origenId, destinoId, routeData) {
        const { error } = await supabaseClient
            .from('datos_rutas')
            .upsert({
                obra_id: this.currentObraId,
                origen_id: origenId,
                destino_id: destinoId,
                distancia_km: routeData.distancia_km,
                tiempo_estimado_minutos: routeData.tiempo_minutos,
                tiempo_con_trafico_minutos: routeData.tiempo_con_trafico_minutos,
                consultado_at: new Date().toISOString()
            }, {
                onConflict: 'origen_id,destino_id'
            });

        if (error) {
            console.error('Error saving to cache:', error);
        }
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

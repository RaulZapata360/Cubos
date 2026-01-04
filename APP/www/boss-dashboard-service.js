// ============================================
// BOSS DASHBOARD SERVICE
// Obtiene datos consolidados de todas las obras
// ============================================

import { supabaseClient } from './supabase-client.js';

class BossDashboardService {
    constructor() {
        this.cachedData = null;
        this.lastFetch = null;
        this.CACHE_DURATION = 30000; // 30 segundos
    }

    // Obtener todas las obras (solo para jefes)
    async getAllObras() {
        try {
            const { data, error } = await supabaseClient
                .from('obras')
                .select('*')
                .order('nombre');

            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error getting obras:', error);
            return [];
        }
    }

    // Obtener todos los camiones de todas las obras de un día específico
    async getAllCamiones(dateStr = null) {
        try {
            let query = supabaseClient
                .from('camiones')
                .select(`
                    *,
                    obras (nombre)
                `);

            if (dateStr) {
                query = query.eq('nomina_fecha', dateStr);
            }

            const { data, error } = await query.order('obra_id');

            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error getting camiones:', error);
            return [];
        }
    }

    getYMD(date) {
        const y = date.getFullYear();
        const m = (date.getMonth() + 1).toString().padStart(2, '0');
        const d = date.getDate().toString().padStart(2, '0');
        return `${y}-${m}-${d}`;
    }

    // Obtener movimientos de un día específico
    async getTodayMovements(dayOffset = 0) {
        try {
            const today = new Date();
            const targetDate = new Date(today);
            targetDate.setDate(today.getDate() + dayOffset);
            const dateStr = this.getYMD(targetDate);

            const { data, error } = await supabaseClient
                .from('movimientos')
                .select(`
                    *,
                    obras (nombre),
                    camiones (nombre, patente, capacidad)
                `)
                .eq('fecha', dateStr)
                .order('timestamp', { ascending: false });

            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error getting movements:', error);
            return [];
        }
    }

    // Obtener datos consolidados (con caché)
    async getConsolidatedData(forceRefresh = false, dayOffset = 0) {
        const now = Date.now();

        // Usar caché si está disponible y no ha expirado (solo para día actual)
        if (!forceRefresh && dayOffset === 0 && this.cachedData && this.lastFetch && (now - this.lastFetch < this.CACHE_DURATION)) {
            return this.cachedData;
        }

        try {
            const today = new Date();
            const targetDate = new Date(today);
            targetDate.setDate(today.getDate() + dayOffset);
            const dateStr = this.getYMD(targetDate);

            // Obtener todos los datos en paralelo
            const [obras, camiones, movements] = await Promise.all([
                this.getAllObras(),
                this.getAllCamiones(dateStr),
                this.getTodayMovements(dayOffset)
            ]);

            const result = {
                obras,
                camiones,
                movements,
                timestamp: now
            };

            // Solo cachear si es el día actual
            if (dayOffset === 0) {
                this.cachedData = result;
                this.lastFetch = now;
            }

            return result;
        } catch (error) {
            console.error('Error getting consolidated data:', error);
            return {
                obras: [],
                camiones: [],
                movements: [],
                timestamp: now
            };
        }
    }

    // Calcular eficiencia (vueltas/hora)
    calculateEfficiency(movements) {
        if (movements.length === 0) return 0;

        const timestamps = movements.map(m => new Date(m.timestamp).getTime());
        const min = Math.min(...timestamps);
        const max = Math.max(...timestamps);
        const hours = Math.max(1, (max - min) / (1000 * 60 * 60));

        return (movements.length / hours).toFixed(1);
    }

    // Calcular comparación con la media (últimos 7 días)
    async calculateComparison(currentVolume, obraId = null) {
        try {
            const sevenDaysAgo = new Date();
            sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
            const dateStr = this.getYMD(sevenDaysAgo);
            const todayStr = this.getYMD(new Date());

            let query = supabaseClient
                .from('movimientos')
                .select('capacidad')
                .gte('fecha', dateStr)
                .lt('fecha', todayStr); // Exclude today

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            const totalPrevVolume = data.reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
            const avgDailyVolume = totalPrevVolume / 7;

            if (avgDailyVolume === 0) return 0;
            return (((currentVolume - avgDailyVolume) / avgDailyVolume) * 100).toFixed(0);
        } catch (error) {
            console.error('Error calculating comparison:', error);
            return 0;
        }
    }

    // Calcular KPI's básicos
    calculateKPIs(movements) {
        const totalTrips = movements.length;

        if (movements.length === 0) {
            return {
                totalTrips: 0,
                operatingTime: '0h 0m',
                avgPerHour: 0
            };
        }

        // Calcular tiempo de operación
        const sorted = [...movements].sort((a, b) =>
            new Date(a.timestamp) - new Date(b.timestamp)
        );

        const first = new Date(sorted[0].timestamp);
        const last = new Date(sorted[sorted.length - 1].timestamp);
        const diffMs = last - first;
        const hours = Math.floor(diffMs / (1000 * 60 * 60));
        const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));

        const totalHours = diffMs / (1000 * 60 * 60);
        const avgTrips = totalHours > 0 ? (movements.length / totalHours).toFixed(1) : 0;

        return {
            totalTrips,
            operatingTime: `${hours}h ${minutes}m`,
            avgPerHour: avgTrips
        };
    }

    // Calcular volumen por tipo
    calculateVolume(movements, type) {
        return movements
            .filter(m => m.tipo === type)
            .reduce((sum, m) => sum + (m.capacidad || 0), 0);
    }

    // Calcular desglose de materiales
    calculateMaterialBreakdown(movements, type) {
        const breakdown = {};

        movements
            .filter(m => m.tipo === type && m.material)
            .forEach(movement => {
                const material = movement.material;
                if (!breakdown[material]) {
                    breakdown[material] = 0;
                }
                breakdown[material] += movement.capacidad || 0;
            });

        return breakdown;
    }

    // Calcular desglose por ubicación/destino
    calculateLocationBreakdown(movements, type) {
        const breakdown = {};
        const key = type === 'incoming' ? 'ubicacion' : 'destino';

        movements
            .filter(m => m.tipo === type)
            .forEach(movement => {
                // Determine which field to use for the breakdown
                let loc = null;
                if (type === 'incoming') {
                    // For incoming, priority is 'origen', then fallback to 'ubicacion'
                    loc = movement.origen || movement.ubicacion;
                } else {
                    // For outgoing, priority is 'destino', then fallback to 'ubicacion'
                    loc = movement.destino || movement.ubicacion;
                }

                if (!loc) return; // Skip if no location/origin/destination

                if (!breakdown[loc]) {
                    breakdown[loc] = 0;
                }
                breakdown[loc] += movement.capacidad || 0;
            });

        return breakdown;
    }

    // Agrupar movimientos por hora
    groupMovementsByHour(movements) {
        const hourlyData = {};

        movements.forEach(movement => {
            const hour = new Date(movement.timestamp).getHours();
            hourlyData[hour] = (hourlyData[hour] || 0) + 1;
        });

        return hourlyData;
    }

    // Obtener rendimiento de camiones
    getTruckPerformance(camiones, movements) {
        return camiones.map(truck => {
            const truckMovements = movements.filter(m => m.camion_id === truck.id);
            const incomingCount = truckMovements.filter(m => m.tipo === 'incoming').length;
            const outgoingCount = truckMovements.filter(m => m.tipo === 'outgoing').length;
            const totalTrips = incomingCount + outgoingCount;
            const totalVolume = truckMovements.reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);

            return {
                id: truck.id,
                nombre: truck.nombre,
                patente: truck.patente,
                capacidad: parseFloat(truck.capacidad),
                tipo_registrado: truck.tipo_registrado,
                incomingCount,
                outgoingCount,
                totalTrips,
                totalVolume,
                obraName: truck.obras?.nombre || 'Sin obra'
            };
        }).sort((a, b) => b.totalTrips - a.totalTrips);
    }

    // Suscribirse a cambios en tiempo real
    subscribeToChanges(callback) {
        const channel = supabaseClient
            .channel('boss-dashboard-changes')
            .on('postgres_changes',
                { event: '*', schema: 'public', table: 'movimientos' },
                (payload) => {
                    console.log('Movement change detected:', payload);
                    this.cachedData = null; // Invalidar caché
                    callback();
                }
            )
            .on('postgres_changes',
                { event: '*', schema: 'public', table: 'camiones' },
                (payload) => {
                    console.log('Truck change detected:', payload);
                    this.cachedData = null; // Invalidar caché
                    callback();
                }
            )
            .subscribe();

        return channel;
    }

    // Desuscribirse
    unsubscribe(channel) {
        if (channel) {
            supabaseClient.removeChannel(channel);
        }
    }

    // Gestión de materiales
    async getMaterialsByObra(obraId) {
        try {
            const { data, error } = await supabaseClient
                .from('materiales')
                .select('*')
                .eq('obra_id', obraId)
                .order('nombre');
            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error getting materials:', error);
            return [];
        }
    }

    async addMaterial(obraId, nombre, tipo) {
        try {
            const { data, error } = await supabaseClient
                .from('materiales')
                .insert([{ obra_id: obraId, nombre, tipo }])
                .select();
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error adding material:', error);
            throw error;
        }
    }

    async deleteMaterial(materialId) {
        try {
            const { error } = await supabaseClient
                .from('materiales')
                .delete()
                .eq('id', materialId);
            if (error) throw error;
            return true;
        } catch (error) {
            console.error('Error deleting material:', error);
            throw error;
        }
    }

    // --- REPORTE METHODS ---

    // Helper for reporting date ranges
    getWeekRange(weekOffset = 0) {
        const today = new Date();
        const dayOfWeek = today.getDay(); // 0 = Sunday, 1 = Monday, etc.
        const daysToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;

        // Calculate Monday of current week
        const currentMonday = new Date(today);
        currentMonday.setDate(today.getDate() - daysToMonday);

        // Apply week offset
        const targetMonday = new Date(currentMonday);
        targetMonday.setDate(currentMonday.getDate() + (weekOffset * 7));

        // Calculate Sunday (end of week)
        const targetSunday = new Date(targetMonday);
        targetSunday.setDate(targetMonday.getDate() + 6);

        // Format as YYYY-MM-DD
        const getYMD = (date) => {
            const y = date.getFullYear();
            const m = (date.getMonth() + 1).toString().padStart(2, '0');
            const d = date.getDate().toString().padStart(2, '0');
            return `${y}-${m}-${d}`;
        };

        return {
            start: getYMD(targetMonday),
            end: getYMD(targetSunday),
            monday: targetMonday
        };
    }

    async getWeeklyVolumeData(obraId = null, weekOffset = 0) {
        try {
            const range = this.getWeekRange(weekOffset);

            let query = supabaseClient
                .from('movimientos')
                .select('fecha, tipo, capacidad')
                .gte('fecha', range.start)
                .lte('fecha', range.end);

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            // Generate 7 days (Mon-Sun) for the target week
            const weekDays = [];
            for (let i = 0; i < 7; i++) {
                const d = new Date(range.monday);
                d.setDate(range.monday.getDate() + i);
                const y = d.getFullYear();
                const m = (d.getMonth() + 1).toString().padStart(2, '0');
                const day = d.getDate().toString().padStart(2, '0');
                weekDays.push(`${y}-${m}-${day}`);
            }

            const result = {
                labels: weekDays.map(date => {
                    const d = new Date(date + 'T12:00:00');
                    return d.toLocaleDateString('es-ES', { weekday: 'short' });
                }),
                incoming: weekDays.map(date =>
                    data.filter(m => m.fecha === date && m.tipo === 'incoming')
                        .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0)
                ),
                outgoing: weekDays.map(date =>
                    data.filter(m => m.fecha === date && m.tipo === 'outgoing')
                        .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0)
                )
            };

            return result;
        } catch (error) {
            console.error('Error getting weekly volume data:', error);
            return { labels: [], incoming: [], outgoing: [] };
        }
    }

    async getMaterialMixData(obraId = null, weekOffset = 0) {
        try {
            const range = this.getWeekRange(weekOffset);

            let query = supabaseClient
                .from('movimientos')
                .select('material, capacidad')
                .gte('fecha', range.start)
                .lte('fecha', range.end);

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            const breakdown = {};
            data.forEach(m => {
                if (!m.material) return;
                breakdown[m.material] = (breakdown[m.material] || 0) + (parseFloat(m.capacidad) || 0);
            });

            // Pivot for Chart.js
            const sorted = Object.entries(breakdown).sort((a, b) => b[1] - a[1]).slice(0, 5);
            return {
                labels: sorted.map(s => s[0]),
                data: sorted.map(s => s[1])
            };
        } catch (error) {
            console.error('Error getting material mix data:', error);
            return { labels: [], data: [] };
        }
    }

    async getDestinationsVolumeData(obraId = null, weekOffset = 0) {
        try {
            const range = this.getWeekRange(weekOffset);

            let query = supabaseClient
                .from('movimientos')
                .select('destino, capacidad, material')
                .eq('tipo', 'outgoing')
                .gte('fecha', range.start)
                .lte('fecha', range.end);

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            const destinations = [...new Set(data.map(m => m.destino).filter(d => d))];
            const materials = [...new Set(data.map(m => m.material).filter(m => m))];

            const datasets = materials.map(material => {
                return {
                    label: material,
                    data: destinations.map(dest => {
                        return data
                            .filter(m => m.destino === dest && m.material === material)
                            .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
                    })
                };
            });

            // Sort destinations by total volume
            const destinationTotals = destinations.map((dest, i) => {
                const total = datasets.reduce((sum, dataset) => sum + dataset.data[i], 0);
                return { dest, total };
            }).sort((a, b) => b.total - a.total);

            const sortedLabels = destinationTotals.map(dt => dt.dest);
            const sortedDatasets = materials.map(material => {
                return {
                    label: material,
                    data: sortedLabels.map(dest => {
                        return data
                            .filter(m => m.destino === dest && m.material === material)
                            .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
                    })
                };
            });

            return {
                labels: sortedLabels,
                datasets: sortedDatasets
            };
        } catch (error) {
            console.error('Error getting destinations volume data:', error);
            return { labels: [], datasets: [] };
        }
    }

    async getObrasVolumeData(weekOffset = 0, tipo = null) {
        try {
            const range = this.getWeekRange(weekOffset);

            // Fetch works and movements to get names
            let query = supabaseClient.from('movimientos')
                .select('obra_id, capacidad, material, tipo')
                .gte('fecha', range.start)
                .lte('fecha', range.end);

            if (tipo) query = query.eq('tipo', tipo);

            const [obrasResult, movsResult] = await Promise.all([
                supabaseClient.from('obras').select('id, nombre'),
                query
            ]);

            if (obrasResult.error) throw obrasResult.error;
            if (movsResult.error) throw movsResult.error;

            const obrasMap = {};
            obrasResult.data.forEach(o => obrasMap[o.id] = o.nombre);

            const obraNames = [...new Set(movsResult.data.map(m => obrasMap[m.obra_id] || 'Desconocida'))];
            const materials = [...new Set(movsResult.data.map(m => m.material).filter(m => m))];

            const datasets = materials.map(material => {
                return {
                    label: material,
                    data: obraNames.map(name => {
                        return movsResult.data
                            .filter(m => (obrasMap[m.obra_id] || 'Desconocida') === name && m.material === material)
                            .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
                    })
                };
            });

            // Sort obras by total volume
            const obraTotals = obraNames.map((name, i) => {
                const total = datasets.reduce((sum, dataset) => sum + dataset.data[i], 0);
                return { name, total };
            }).sort((a, b) => b.total - a.total);

            const sortedLabels = obraTotals.map(ot => ot.name);
            const sortedDatasets = materials.map(material => {
                return {
                    label: material,
                    data: sortedLabels.map(name => {
                        return movsResult.data
                            .filter(m => (obrasMap[m.obra_id] || 'Desconocida') === name && m.material === material)
                            .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
                    })
                };
            });

            return {
                labels: sortedLabels,
                datasets: sortedDatasets
            };
        } catch (error) {
            console.error('Error getting obras volume data:', error);
            return { labels: [], datasets: [] };
        }
    }

    async getOriginsVolumeData(obraId = null, weekOffset = 0) {
        try {
            const range = this.getWeekRange(weekOffset);

            let query = supabaseClient
                .from('movimientos')
                .select('origen, ubicacion, capacidad, material')
                .eq('tipo', 'incoming')
                .gte('fecha', range.start)
                .lte('fecha', range.end);

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            // Use 'origen' primarily, fallback to 'ubicacion'
            const origins = [...new Set(data.map(m => m.origen || m.ubicacion).filter(o => o))];
            const materials = [...new Set(data.map(m => m.material).filter(m => m))];

            const datasets = materials.map(material => {
                return {
                    label: material,
                    data: origins.map(orig => {
                        return data
                            .filter(m => (m.origen === orig || (!m.origen && m.ubicacion === orig)) && m.material === material)
                            .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
                    })
                };
            });

            // Sort origins by total volume
            const originTotals = origins.map((orig, i) => {
                const total = datasets.reduce((sum, dataset) => sum + dataset.data[i], 0);
                return { orig, total };
            }).sort((a, b) => b.total - a.total);

            const sortedLabels = originTotals.map(ot => ot.orig);
            const sortedDatasets = materials.map(material => {
                return {
                    label: material,
                    data: sortedLabels.map(orig => {
                        return data
                            .filter(m => (m.origen === orig || (!m.origen && m.ubicacion === orig)) && m.material === material)
                            .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);
                    })
                };
            });

            return {
                labels: sortedLabels,
                datasets: sortedDatasets
            };
        } catch (error) {
            console.error('Error getting origins volume data:', error);
            return { labels: [], datasets: [] };
        }
    }
}

// Exportar instancia única
export const bossDashboardService = new BossDashboardService();

// Hacer disponible globalmente para debugging
window.bossDashboardService = bossDashboardService;

console.log('✅ Boss Dashboard service initialized');

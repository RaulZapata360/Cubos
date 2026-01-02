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

    // Obtener todos los camiones de todas las obras
    async getAllCamiones() {
        try {
            const { data, error } = await supabaseClient
                .from('camiones')
                .select(`
                    *,
                    obras (nombre)
                `)
                .order('obra_id');

            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error getting camiones:', error);
            return [];
        }
    }

    // Obtener todos los movimientos del día actual
    async getTodayMovements() {
        try {
            const today = new Date().toISOString().split('T')[0];

            const { data, error } = await supabaseClient
                .from('movimientos')
                .select(`
                    *,
                    obras (nombre),
                    camiones (nombre, patente, capacidad)
                `)
                .eq('fecha', today)
                .order('timestamp', { ascending: false });

            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error getting movements:', error);
            return [];
        }
    }

    // Obtener datos consolidados (con caché)
    async getConsolidatedData(forceRefresh = false) {
        const now = Date.now();

        // Usar caché si está disponible y no ha expirado
        if (!forceRefresh && this.cachedData && this.lastFetch && (now - this.lastFetch < this.CACHE_DURATION)) {
            return this.cachedData;
        }

        try {
            // Obtener todos los datos en paralelo
            const [obras, camiones, movements] = await Promise.all([
                this.getAllObras(),
                this.getAllCamiones(),
                this.getTodayMovements()
            ]);

            this.cachedData = {
                obras,
                camiones,
                movements,
                timestamp: now
            };
            this.lastFetch = now;

            return this.cachedData;
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
            const dateStr = sevenDaysAgo.toISOString().split('T')[0];

            let query = supabaseClient
                .from('movimientos')
                .select('capacidad')
                .gte('fecha', dateStr)
                .lt('fecha', new Date().toISOString().split('T')[0]); // Exclude today

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
            .filter(m => m.tipo === type && m[key])
            .forEach(movement => {
                const loc = movement[key];
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

    async getWeeklyVolumeData(obraId = null) {
        try {
            const sevenDaysAgo = new Date();
            sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
            const dateStr = sevenDaysAgo.toISOString().split('T')[0];

            let query = supabaseClient
                .from('movimientos')
                .select('fecha, tipo, capacidad')
                .gte('fecha', dateStr);

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            // Group by date and type
            const last7Days = [];
            for (let i = 6; i >= 0; i--) {
                const d = new Date();
                d.setDate(d.getDate() - i);
                last7Days.push(d.toISOString().split('T')[0]);
            }

            const result = {
                labels: last7Days.map(date => {
                    const d = new Date(date + 'T12:00:00');
                    return d.toLocaleDateString('es-ES', { weekday: 'short' });
                }),
                incoming: last7Days.map(date =>
                    data.filter(m => m.fecha === date && m.tipo === 'incoming')
                        .reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0)
                ),
                outgoing: last7Days.map(date =>
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

    async getMaterialMixData(obraId = null) {
        try {
            let query = supabaseClient
                .from('movimientos')
                .select('material, capacidad');

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

    async getDestinationsVolumeData(obraId = null) {
        try {
            let query = supabaseClient
                .from('movimientos')
                .select('destino, capacidad')
                .eq('tipo', 'outgoing');

            if (obraId) query = query.eq('obra_id', obraId);

            const { data, error } = await query;
            if (error) throw error;

            const breakdown = {};
            data.forEach(m => {
                if (!m.destino) return;
                breakdown[m.destino] = (breakdown[m.destino] || 0) + (parseFloat(m.capacidad) || 0);
            });

            const sorted = Object.entries(breakdown).sort((a, b) => b[1] - a[1]);
            return {
                labels: sorted.map(s => s[0]),
                data: sorted.map(s => s[1])
            };
        } catch (error) {
            console.error('Error getting destinations volume data:', error);
            return { labels: [], data: [] };
        }
    }

    async getObrasVolumeData() {
        try {
            // Fetch works and movements to get names
            const [obrasResult, movsResult] = await Promise.all([
                supabaseClient.from('obras').select('id, nombre'),
                supabaseClient.from('movimientos').select('obra_id, capacidad')
            ]);

            if (obrasResult.error) throw obrasResult.error;
            if (movsResult.error) throw movsResult.error;

            const obrasMap = {};
            obrasResult.data.forEach(o => obrasMap[o.id] = o.nombre);

            const breakdown = {};
            movsResult.data.forEach(m => {
                const name = obrasMap[m.obra_id] || 'Desconocida';
                breakdown[name] = (breakdown[name] || 0) + (parseFloat(m.capacidad) || 0);
            });

            const sorted = Object.entries(breakdown).sort((a, b) => b[1] - a[1]);
            return {
                labels: sorted.map(s => s[0]),
                data: sorted.map(s => s[1])
            };
        } catch (error) {
            console.error('Error getting obras volume data:', error);
            return { labels: [], data: [] };
        }
    }
}

// Exportar instancia única
export const bossDashboardService = new BossDashboardService();

// Hacer disponible globalmente para debugging
window.bossDashboardService = bossDashboardService;

console.log('✅ Boss Dashboard service initialized');

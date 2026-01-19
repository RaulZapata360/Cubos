// Counter service with Supabase integration
import { supabaseClient } from './supabase-client.js';
import { obrasService } from './obras-service.js';

class CounterService {
    constructor() {
        this.currentObraId = null;
        this.init();
    }

    async init() {
        this.currentObraId = obrasService.getSelectedObraId();
        if (!this.currentObraId) {
            console.error('No obra selected');
            return;
        }
        console.log('Counter initialized for obra:', this.currentObraId);
    }

    // Register a new movement
    async registerMovement(camionId, tipo, capacidad, material = null, materialId = null) {
        try {
            const session = await supabaseClient.auth.getSession();
            const userId = session.data.session?.user?.id;

            if (!userId) {
                throw new Error('User not authenticated');
            }

            const now = new Date();
            const timestamp = now.toISOString();
            const fecha = now.toISOString().split('T')[0];

            const movementData = {
                obra_id: this.currentObraId,
                camion_id: camionId,
                usuario_id: userId,
                tipo: tipo,
                capacidad: parseFloat(capacidad),
                material: material,
                timestamp: timestamp,
                fecha: fecha
            };

            // Add material_id if provided (for goal tracking)
            if (materialId) {
                movementData.material_id = materialId;
            }

            const { data, error } = await supabaseClient
                .from('movimientos')
                .insert([movementData])
                .select()
                .single();

            if (error) throw error;

            console.log('✅ Movement registered:', data);
            return { success: true, data };
        } catch (error) {
            console.error('❌ Error registering movement:', error);
            return { success: false, error: error.message };
        }
    }

    // Get trucks for current obra
    async getTrucks() {
        try {
            const { data, error } = await supabaseClient
                .from('camiones')
                .select('*')
                .eq('obra_id', this.currentObraId)
                .order('nombre');

            if (error) throw error;

            return data || [];
        } catch (error) {
            console.error('Error fetching trucks:', error);
            return [];
        }
    }

    // Get materials for current obra
    async getMaterials() {
        try {
            const { data, error } = await supabaseClient
                .from('materiales')
                .select('*')
                .eq('obra_id', this.currentObraId)
                .order('nombre');

            if (error) throw error;

            return data || [];
        } catch (error) {
            console.error('Error fetching materials:', error);
            return [];
        }
    }

    // Get today's movements
    async getTodayMovements() {
        try {
            const today = new Date().toISOString().split('T')[0];

            const { data, error } = await supabaseClient
                .from('movimientos')
                .select(`
                    *,
                    camiones (nombre, patente)
                `)
                .eq('obra_id', this.currentObraId)
                .eq('fecha', today)
                .order('timestamp', { ascending: false });

            if (error) throw error;

            return data || [];
        } catch (error) {
            console.error('Error fetching movements:', error);
            return [];
        }
    }

    // Get daily summary
    async getDailySummary() {
        try {
            const today = new Date().toISOString().split('T')[0];

            const { data, error } = await supabaseClient
                .from('movimientos')
                .select('tipo, capacidad')
                .eq('obra_id', this.currentObraId)
                .eq('fecha', today);

            if (error) throw error;

            const summary = {
                incoming: 0,
                outgoing: 0,
                totalTrips: data.length,
                incomingVolume: 0,
                outgoingVolume: 0
            };

            data.forEach(mov => {
                if (mov.tipo === 'incoming') {
                    summary.incoming++;
                    summary.incomingVolume += mov.capacidad;
                } else {
                    summary.outgoing++;
                    summary.outgoingVolume += mov.capacidad;
                }
            });

            return summary;
        } catch (error) {
            console.error('Error fetching summary:', error);
            return {
                incoming: 0,
                outgoing: 0,
                totalTrips: 0,
                incomingVolume: 0,
                outgoingVolume: 0
            };
        }
    }

    // Create a new truck
    async createTruck(truckData) {
        try {
            const { data, error } = await supabaseClient
                .from('camiones')
                .insert([{
                    obra_id: this.currentObraId,
                    nombre: truckData.nombre,
                    patente: truckData.patente,
                    capacidad: parseFloat(truckData.capacidad),
                    tipo: truckData.tipo || 'excavacion'
                }])
                .select()
                .single();

            if (error) throw error;

            console.log('✅ Truck created:', data);
            return { success: true, data };
        } catch (error) {
            console.error('❌ Error creating truck:', error);
            return { success: false, error: error.message };
        }
    }
}

export const counterService = new CounterService();

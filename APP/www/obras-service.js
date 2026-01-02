// ============================================
// OBRAS SERVICE
// Maneja operaciones CRUD de obras
// ============================================

import { supabaseClient } from './supabase-client.js';
import { authService } from './auth-service.js';

class ObrasService {

    // Obtener todas las obras (según rol del usuario)
    async getObras() {
        try {
            const { data, error } = await supabaseClient
                .from('obras')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) {
                console.error('Error getting obras:', error);
                return { success: false, error: error.message, data: [] };
            }

            return { success: true, data: data || [] };

        } catch (error) {
            console.error('Get obras exception:', error);
            return { success: false, error: 'Error al obtener obras', data: [] };
        }
    }

    // Obtener obras asignadas a un usuario específico
    async getObrasAsignadas(userId) {
        try {
            const { data, error } = await supabaseClient
                .from('usuario_obra')
                .select(`
          obra_id,
          obras (*)
        `)
                .eq('usuario_id', userId);

            if (error) {
                console.error('Error getting assigned obras:', error);
                return { success: false, error: error.message, data: [] };
            }

            // Extraer solo las obras
            const obras = data.map(item => item.obras).filter(Boolean);

            return { success: true, data: obras };

        } catch (error) {
            console.error('Get assigned obras exception:', error);
            return { success: false, error: 'Error al obtener obras asignadas', data: [] };
        }
    }

    // Obtener obra por ID
    async getObraById(obraId) {
        try {
            const { data, error } = await supabaseClient
                .from('obras')
                .select('*')
                .eq('id', obraId)
                .single();

            if (error) {
                console.error('Error getting obra:', error);
                return { success: false, error: error.message, data: null };
            }

            return { success: true, data: data };

        } catch (error) {
            console.error('Get obra exception:', error);
            return { success: false, error: 'Error al obtener obra', data: null };
        }
    }

    // Crear nueva obra (solo jefes)
    async createObra(obraData) {
        try {
            const { data, error } = await supabaseClient
                .from('obras')
                .insert([{
                    nombre: obraData.nombre,
                    ubicacion: obraData.ubicacion || null,
                    descripcion: obraData.descripcion || null,
                    fecha_inicio: obraData.fecha_inicio || new Date().toISOString().split('T')[0],
                    estado: obraData.estado || 'activa'
                }])
                .select()
                .single();

            if (error) {
                console.error('Error creating obra:', error);
                return { success: false, error: error.message, data: null };
            }

            // Crear materiales por defecto para la obra
            await this.createDefaultMaterials(data.id);

            return { success: true, data: data };

        } catch (error) {
            console.error('Create obra exception:', error);
            return { success: false, error: 'Error al crear obra', data: null };
        }
    }

    // Crear materiales por defecto para una obra
    async createDefaultMaterials(obraId) {
        const defaultMaterials = {
            incoming: ['Base estabilizada', 'Grava', 'Bolones', 'Arena', 'Maicillo'],
            outgoing: ['Arcilla', 'Basura', 'Arena', 'Tierra']
        };

        const materialsToInsert = [];

        for (const [tipo, materiales] of Object.entries(defaultMaterials)) {
            for (const nombre of materiales) {
                materialsToInsert.push({
                    obra_id: obraId,
                    nombre: nombre,
                    tipo: tipo
                });
            }
        }

        try {
            await supabaseClient
                .from('materiales')
                .insert(materialsToInsert);
        } catch (error) {
            console.error('Error creating default materials:', error);
        }
    }

    // Actualizar obra
    async updateObra(obraId, obraData) {
        try {
            const { data, error } = await supabaseClient
                .from('obras')
                .update({
                    nombre: obraData.nombre,
                    ubicacion: obraData.ubicacion,
                    descripcion: obraData.descripcion,
                    fecha_inicio: obraData.fecha_inicio,
                    estado: obraData.estado
                })
                .eq('id', obraId)
                .select()
                .single();

            if (error) {
                console.error('Error updating obra:', error);
                return { success: false, error: error.message, data: null };
            }

            return { success: true, data: data };

        } catch (error) {
            console.error('Update obra exception:', error);
            return { success: false, error: 'Error al actualizar obra', data: null };
        }
    }

    // Eliminar obra
    async deleteObra(obraId) {
        try {
            const { error } = await supabaseClient
                .from('obras')
                .delete()
                .eq('id', obraId);

            if (error) {
                console.error('Error deleting obra:', error);
                return { success: false, error: error.message };
            }

            return { success: true };

        } catch (error) {
            console.error('Delete obra exception:', error);
            return { success: false, error: 'Error al eliminar obra' };
        }
    }

    // Asignar usuario a obra
    async assignUserToObra(userId, obraId) {
        try {
            const { data, error } = await supabaseClient
                .from('usuario_obra')
                .insert([{
                    usuario_id: userId,
                    obra_id: obraId
                }])
                .select()
                .single();

            if (error) {
                console.error('Error assigning user to obra:', error);
                return { success: false, error: error.message };
            }

            return { success: true, data: data };

        } catch (error) {
            console.error('Assign user exception:', error);
            return { success: false, error: 'Error al asignar usuario' };
        }
    }

    // Desasignar usuario de obra
    async unassignUserFromObra(userId, obraId) {
        try {
            const { error } = await supabaseClient
                .from('usuario_obra')
                .delete()
                .eq('usuario_id', userId)
                .eq('obra_id', obraId);

            if (error) {
                console.error('Error unassigning user from obra:', error);
                return { success: false, error: error.message };
            }

            return { success: true };

        } catch (error) {
            console.error('Unassign user exception:', error);
            return { success: false, error: 'Error al desasignar usuario' };
        }
    }

    // Obtener usuarios asignados a una obra
    async getObraUsers(obraId) {
        try {
            const { data, error } = await supabaseClient
                .from('usuario_obra')
                .select(`
          usuario_id,
          usuarios (*)
        `)
                .eq('obra_id', obraId);

            if (error) {
                console.error('Error getting obra users:', error);
                return { success: false, error: error.message, data: [] };
            }

            const usuarios = data.map(item => item.usuarios).filter(Boolean);

            return { success: true, data: usuarios };

        } catch (error) {
            console.error('Get obra users exception:', error);
            return { success: false, error: 'Error al obtener usuarios', data: [] };
        }
    }

    // Obtener todos los usuarios (para asignación)
    async getAllUsers() {
        try {
            const { data, error } = await supabaseClient
                .from('usuarios')
                .select('*')
                .order('nombre_completo');

            if (error) {
                console.error('Error getting users:', error);
                return { success: false, error: error.message, data: [] };
            }

            return { success: true, data: data || [] };

        } catch (error) {
            console.error('Get users exception:', error);
            return { success: false, error: 'Error al obtener usuarios', data: [] };
        }
    }

    // Guardar obra seleccionada en localStorage
    selectObra(obraId, obraNombre) {
        localStorage.setItem('selectedObraId', obraId);
        localStorage.setItem('selectedObraNombre', obraNombre);
    }

    // Obtener obra seleccionada
    getSelectedObra() {
        return {
            id: localStorage.getItem('selectedObraId'),
            nombre: localStorage.getItem('selectedObraNombre')
        };
    }

    // Limpiar obra seleccionada
    clearSelectedObra() {
        localStorage.removeItem('selectedObraId');
        localStorage.removeItem('selectedObraNombre');
    }

    // Verificar si hay obra seleccionada
    hasSelectedObra() {
        return localStorage.getItem('selectedObraId') !== null;
    }

    // Obtener ID de obra seleccionada
    getSelectedObraId() {
        return localStorage.getItem('selectedObraId');
    }

    // Obtener nombre de obra seleccionada
    getSelectedObraNombre() {
        return localStorage.getItem('selectedObraNombre');
    }
}

// Exportar instancia única
export const obrasService = new ObrasService();

// Hacer disponible globalmente para debugging
window.obrasService = obrasService;

console.log('✅ Obras service initialized');

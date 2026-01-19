/**
 * Goals Service - Gestión de Metas/Misiones
 * Maneja CRUD de metas y cálculo de progreso
 */

class GoalsService {
    constructor() {
        this.tableName = 'metas_obra';
    }

    /**
     * Crear una nueva meta
     */
    async createGoal(obraId, goalData) {
        try {
            const { data, error } = await supabase
                .from(this.tableName)
                .insert([{
                    obra_id: obraId,
                    tipo: goalData.tipo,
                    descripcion: goalData.descripcion,
                    m3_objetivo: goalData.m3_objetivo,
                    fecha_inicio: goalData.fecha_inicio || new Date().toISOString().split('T')[0],
                    fecha_limite: goalData.fecha_limite,
                    material_objetivo: goalData.material_objetivo || null,
                    material_objetivo_id: goalData.material_objetivo_id || null,
                    activa: true
                }])
                .select()
                .single();

            if (error) throw error;

            console.log('✅ Meta creada:', data);
            return data;
        } catch (error) {
            console.error('❌ Error creating goal:', error);
            throw error;
        }
    }

    /**
     * Obtener metas activas de una obra
     */
    async getActiveGoals(obraId) {
        try {
            const { data, error } = await supabase
                .from(this.tableName)
                .select('*')
                .eq('obra_id', obraId)
                .eq('activa', true)
                .order('created_at', { ascending: false });

            if (error) throw error;

            console.log(`📊 ${data?.length || 0} metas activas cargadas`);
            return data || [];
        } catch (error) {
            console.error('❌ Error loading goals:', error);
            return [];
        }
    }

    /**
     * Obtener meta por tipo
     */
    async getGoalByType(obraId, tipo) {
        try {
            const { data, error } = await supabase
                .from(this.tableName)
                .select('*')
                .eq('obra_id', obraId)
                .eq('tipo', tipo)
                .eq('activa', true)
                .single();

            if (error && error.code !== 'PGRST116') throw error; // PGRST116 = no rows

            return data || null;
        } catch (error) {
            console.error('❌ Error loading goal by type:', error);
            return null;
        }
    }

    /**
     * Actualizar una meta
     */
    async updateGoal(goalId, updates) {
        try {
            const { data, error } = await supabase
                .from(this.tableName)
                .update({
                    ...updates,
                    updated_at: new Date().toISOString()
                })
                .eq('id', goalId)
                .select()
                .single();

            if (error) throw error;

            console.log('✅ Meta actualizada:', data);
            return data;
        } catch (error) {
            console.error('❌ Error updating goal:', error);
            throw error;
        }
    }

    /**
     * Desactivar una meta
     */
    async deactivateGoal(goalId) {
        return this.updateGoal(goalId, { activa: false });
    }

    /**
     * Eliminar una meta
     */
    async deleteGoal(goalId) {
        try {
            const { error } = await supabase
                .from(this.tableName)
                .delete()
                .eq('id', goalId);

            if (error) throw error;

            console.log('✅ Meta eliminada');
            return true;
        } catch (error) {
            console.error('❌ Error deleting goal:', error);
            throw error;
        }
    }

    /**
     * Calcular progreso de una meta
     */
    calculateProgress(goal, movements) {
        if (!goal) return null;

        // Filtrar movimientos relevantes desde fecha_inicio
        let relevantMovements = movements.filter(m =>
            m.tipo === goal.tipo &&
            m.fecha >= goal.fecha_inicio
        );

        // Si la meta tiene un material específico, filtrar por material_id
        if (goal.material_objetivo_id) {
            relevantMovements = relevantMovements.filter(m =>
                m.material_id === goal.material_objetivo_id
            );
        }
        // Fallback: si no hay material_objetivo_id pero sí material_objetivo (nombre)
        else if (goal.material_objetivo) {
            relevantMovements = relevantMovements.filter(m =>
                m.material === goal.material_objetivo
            );
        }
        // Si no hay material especificado, contar todos los movimientos del tipo correcto

        // Calcular m³ acumulados
        const m3Acumulados = relevantMovements.reduce(
            (sum, m) => sum + (parseFloat(m.capacidad) || 0),
            0
        );

        // Calcular porcentaje
        const porcentaje = (m3Acumulados / goal.m3_objetivo) * 100;

        // Calcular días de retraso
        const hoy = new Date();
        const fechaLimite = new Date(goal.fecha_limite);
        const diasRetraso = porcentaje < 100 && hoy > fechaLimite
            ? Math.ceil((hoy - fechaLimite) / (1000 * 60 * 60 * 24))
            : 0;

        return {
            m3Acumulados: parseFloat(m3Acumulados.toFixed(1)),
            m3Objetivo: parseFloat(goal.m3_objetivo),
            porcentaje: Math.min(parseFloat(porcentaje.toFixed(1)), 100),
            diasRetraso,
            completada: porcentaje >= 100,
            descripcion: goal.descripcion,
            fechaLimite: goal.fecha_limite
        };
    }
}

    /**
     * Obtener material por ID desde la tabla materiales
     */
    async getMaterialById(materialId) {
    try {
        const { data, error } = await supabase
            .from('materiales')
            .select('*')
            .eq('id', materialId)
            .single();

        if (error && error.code !== 'PGRST116') throw error;

        return data || null;
    } catch (error) {
        console.error('❌ Error loading material:', error);
        return null;
    }
}
}

// Inicializar servicio
window.goalsService = new GoalsService();
console.log('✅ Goals service initialized');

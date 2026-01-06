// Add this after getOriginsVolumeData function in boss-dashboard-service.js

    async getInternalTripsData(obraId = null, weekOffset = 0) {
    try {
        const range = this.getWeekRange(weekOffset);

        let query = supabaseClient
            .from('movimientos')
            .select('fecha, capacidad, material, destino, origen')
            .gte('fecha', range.start)
            .lte('fecha', range.end);

        if (obraId) query = query.eq('obra_id', obraId);

        const { data, error } = await query;
        if (error) throw error;

        // Filter only internal trips
        const internalTrips = data.filter(m => this.isInternalTrip(m));

        // Group by material
        const materials = [...new Set(internalTrips.map(m => m.material).filter(m => m))];
        const totalVolume = internalTrips.reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0);

        return {
            labels: materials.length > 0 ? materials : ['Interno'],
            data: materials.length > 0
                ? materials.map(mat => internalTrips.filter(m => m.material === mat).reduce((sum, m) => sum + (parseFloat(m.capacidad) || 0), 0))
                : [totalVolume],
            totalTrips: internalTrips.length,
            totalVolume
        };
    } catch (error) {
        console.error('Error getting internal trips data:', error);
        return { labels: [], data: [], totalTrips: 0, totalVolume: 0 };
    }
}

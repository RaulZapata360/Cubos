// Function to render internal trips in analytics tab
function renderInternalTrips() {
    const container = document.getElementById('internalTripsContainer');
    if (!container) return;

    // Filter internal trips (destino='Interno' OR origen='Interno')
    const internalTrips = movements.filter(m =>
        (m.destino && m.destino.toLowerCase() === 'interno') ||
        (m.origen && m.origen.toLowerCase() === 'interno')
    );

    if (internalTrips.length === 0) {
        container.innerHTML = `
            <div class="text-center py-6 text-text-muted text-xs">
                <span class="material-symbols-outlined text-2xl mb-2 opacity-50">swap_horiz</span>
                <p>Sin viajes internos hoy</p>
            </div>
        `;
        return;
    }

    // Calculate stats
    const totalVolume = internalTrips.reduce((sum, m) => sum + parseFloat(m.capacidad || 0), 0);
    const uniqueTrucks = new Set(internalTrips.map(m => m.camion_id)).size;

    container.innerHTML = `
        <div class="grid grid-cols-2 gap-2 mb-3">
            <div class="bg-cyan-500/10 border border-cyan-500/20 rounded-xl p-2 text-center">
                <div class="text-xs text-cyan-400 font-bold">${internalTrips.length}</div>
                <div class="text-[9px] text-text-muted uppercase">Vueltas</div>
            </div>
            <div class="bg-cyan-500/10 border border-cyan-500/20 rounded-xl p-2 text-center">
                <div class="text-xs text-cyan-400 font-bold">${totalVolume.toFixed(1)} m³</div>
                <div class="text-[9px] text-text-muted uppercase">Volumen</div>
            </div>
        </div>
    `;
}

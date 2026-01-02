// Boss Dashboard - Read-Only View
// Reads data from localStorage and displays analytics

class BossDashboard {
    constructor() {
        this.trucks = [];
        this.movements = [];
        this.refreshInterval = null;
        this.init();
    }

    init() {
        this.updateDate();
        this.loadData();
        this.migrateLegacyData();
        this.renderDashboard();
        this.startAutoRefresh();
    }

    // Migrate old data format
    migrateLegacyData() {
        let needsSave = false;

        this.trucks.forEach(truck => {
            if (truck.type !== undefined && truck.count !== undefined) {
                truck.incomingCount = truck.type === 'incoming' ? truck.count : 0;
                truck.outgoingCount = truck.type === 'outgoing' ? truck.count : 0;
                delete truck.type;
                delete truck.count;
                needsSave = true;
            }

            if (truck.incomingCount === undefined) truck.incomingCount = 0;
            if (truck.outgoingCount === undefined) truck.outgoingCount = 0;
        });

        if (needsSave) {
            console.log('Migrated legacy data');
        }
    }

    // Date Management
    updateDate() {
        const dateElement = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateElement.textContent = today.toLocaleDateString('es-ES', options);
    }

    // Load Data from localStorage
    loadData() {
        const trucksData = localStorage.getItem('trucks');
        const movementsData = localStorage.getItem('movements');

        this.trucks = trucksData ? JSON.parse(trucksData) : [];
        this.movements = movementsData ? JSON.parse(movementsData) : [];
    }

    // Render Complete Dashboard
    renderDashboard() {
        this.updateKPIs();
        this.updateVolumeBalance();
        this.updateHourlyActivity();
        this.updatePerformanceTable();
        this.updateMovementTable();
    }

    // KPI Cards
    updateKPIs() {
        const totalTrips = this.movements.length;

        // Total Trips
        document.getElementById('kpiTotalTrips').textContent = totalTrips;

        // Operating Time and Avg Per Hour
        if (this.movements.length > 0) {
            const sorted = [...this.movements].sort((a, b) =>
                new Date(a.timestamp) - new Date(b.timestamp)
            );

            const first = new Date(sorted[0].timestamp);
            const last = new Date(sorted[sorted.length - 1].timestamp);

            const diffMs = last - first;
            const hours = Math.floor(diffMs / (1000 * 60 * 60));
            const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));

            document.getElementById('kpiOperatingTime').textContent = `${hours}h ${minutes}m`;

            const totalHours = diffMs / (1000 * 60 * 60);
            const avgTrips = totalHours > 0 ? (this.movements.length / totalHours).toFixed(1) : 0;
            document.getElementById('kpiAvgPerHour').textContent = avgTrips;
        } else {
            document.getElementById('kpiOperatingTime').textContent = '0h 0m';
            document.getElementById('kpiAvgPerHour').textContent = '0';
        }
    }

    // Volume Balance
    updateVolumeBalance() {
        const fillVolume = this.calculateVolume('incoming');
        const excavationVolume = this.calculateVolume('outgoing');

        document.getElementById('dashFillVolume').textContent = `+${fillVolume.toFixed(1)} m³`;
        document.getElementById('dashExcavationVolume').textContent = `-${excavationVolume.toFixed(1)} m³`;

        // Material breakdown
        const fillBreakdown = this.calculateMaterialBreakdown('incoming');
        const excavationBreakdown = this.calculateMaterialBreakdown('outgoing');

        this.renderMaterialBreakdown('dashFillBreakdown', fillBreakdown);
        this.renderMaterialBreakdown('dashExcavationBreakdown', excavationBreakdown);
    }

    calculateMaterialBreakdown(type) {
        const breakdown = {};

        this.movements
            .filter(m => m.type === type && m.material)
            .forEach(movement => {
                const material = movement.material;
                if (!breakdown[material]) {
                    breakdown[material] = 0;
                }
                breakdown[material] += movement.capacity;
            });

        return breakdown;
    }

    renderMaterialBreakdown(elementId, breakdown) {
        const element = document.getElementById(elementId);
        if (!element) return;

        const materials = Object.keys(breakdown);

        if (materials.length === 0) {
            element.innerHTML = '<div class="material-item" style="color: var(--text-muted); font-size: 12px; font-style: italic;">Sin materiales especificados</div>';
            return;
        }

        element.innerHTML = materials
            .sort((a, b) => breakdown[b] - breakdown[a]) // Sort by volume descending
            .map(material => `
                <div class="material-item">
                    <span class="material-name">${material}</span>
                    <span class="material-volume">${breakdown[material].toFixed(1)} m³</span>
                </div>
            `).join('');
    }

    calculateVolume(type) {
        // Calculate from movements, not truck properties
        return this.movements
            .filter(m => m.type === type)
            .reduce((sum, movement) => sum + movement.capacity, 0);
    }

    // Hourly Activity Chart
    updateHourlyActivity() {
        const activityElement = document.getElementById('hourlyActivity');

        if (this.movements.length === 0) {
            activityElement.innerHTML = '<p class="analytics-empty">No hay datos disponibles</p>';
            return;
        }

        // Group movements by hour
        const hourlyData = {};
        this.movements.forEach(movement => {
            const hour = new Date(movement.timestamp).getHours();
            hourlyData[hour] = (hourlyData[hour] || 0) + 1;
        });

        const maxCount = Math.max(...Object.values(hourlyData));
        const hours = Object.keys(hourlyData).sort((a, b) => a - b);

        activityElement.innerHTML = hours.map(hour => {
            const count = hourlyData[hour];
            const percentage = (count / maxCount) * 100;
            const displayHour = parseInt(hour) % 12 || 12;
            const period = parseInt(hour) >= 12 ? 'PM' : 'AM';

            return `
                <div class="hour-bar">
                    <div class="hour-label">${displayHour} ${period}</div>
                    <div class="hour-graph">
                        <div class="hour-fill" style="width: ${percentage}%"></div>
                    </div>
                    <div class="hour-count">${count}</div>
                </div>
            `;
        }).join('');
    }

    // Performance Table with Breakdown - Separated by Type
    updatePerformanceTable() {
        const container = document.querySelector('#performanceTable').parentElement;
        const table = document.querySelector('#performanceTable');

        if (this.trucks.length === 0) {
            container.innerHTML = `
                <table class="performance-table" id="performanceTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Camión</th>
                            <th>Patente</th>
                            <th>Relleno</th>
                            <th>Excavación</th>
                            <th>Total</th>
                            <th>Volumen</th>
                            <th>Capacidad</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="8" class="empty-table">No hay camiones registrados</td>
                        </tr>
                    </tbody>
                </table>
            `;
            return;
        }

        // Separate trucks by primary type
        const incomingTrucks = this.trucks.filter(t =>
            t.registeredType === 'incoming' || (t.registeredType === 'mixed' && t.incomingCount >= t.outgoingCount)
        ).sort((a, b) => (b.incomingCount + b.outgoingCount) - (a.incomingCount + a.outgoingCount));

        const outgoingTrucks = this.trucks.filter(t =>
            t.registeredType === 'outgoing' || (t.registeredType === 'mixed' && t.outgoingCount > t.incomingCount)
        ).sort((a, b) => (b.incomingCount + b.outgoingCount) - (a.incomingCount + a.outgoingCount));

        let html = '';
        let globalIndex = 0;

        // Relleno Section
        if (incomingTrucks.length > 0) {
            html += `
                <div class="table-section-header incoming-header">
                    📥 Camiones de Relleno (${incomingTrucks.length})
                </div>
                <table class="performance-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Camión</th>
                            <th>Patente</th>
                            <th>Relleno</th>
                            <th>Excavación</th>
                            <th>Total</th>
                            <th>Volumen</th>
                            <th>Capacidad</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            html += incomingTrucks.map(truck => {
                globalIndex++;
                const totalTrips = truck.incomingCount + truck.outgoingCount;
                const incomingVol = truck.incomingCount * truck.capacity;
                const outgoingVol = truck.outgoingCount * truck.capacity;
                const rankClass = globalIndex === 1 ? 'top' : '';

                return `
                    <tr>
                        <td><span class="rank-badge ${rankClass}">${globalIndex}</span></td>
                        <td class="table-truck">${truck.name}</td>
                        <td>${truck.licensePlate}</td>
                        <td style="color: var(--incoming-primary); font-weight: bold;">${truck.incomingCount}</td>
                        <td style="color: var(--outgoing-primary);">${truck.outgoingCount}</td>
                        <td>${totalTrips}</td>
                        <td>${incomingVol.toFixed(1)} m³ / ${outgoingVol.toFixed(1)} m³</td>
                        <td>${truck.capacity} m³</td>
                    </tr>
                `;
            }).join('');

            html += `
                    </tbody>
                </table>
            `;
        }

        // Excavación Section
        if (outgoingTrucks.length > 0) {
            html += `
                <div class="table-section-header outgoing-header">
                    📤 Camiones de Excavación/Corte (${outgoingTrucks.length})
                </div>
                <table class="performance-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Camión</th>
                            <th>Patente</th>
                            <th>Relleno</th>
                            <th>Excavación</th>
                            <th>Total</th>
                            <th>Volumen</th>
                            <th>Capacidad</th>
                        </tr>
                    </thead>
                    <tbody>
            `;

            html += outgoingTrucks.map(truck => {
                globalIndex++;
                const totalTrips = truck.incomingCount + truck.outgoingCount;
                const incomingVol = truck.incomingCount * truck.capacity;
                const outgoingVol = truck.outgoingCount * truck.capacity;

                return `
                    <tr>
                        <td><span class="rank-badge">${globalIndex}</span></td>
                        <td class="table-truck">${truck.name}</td>
                        <td>${truck.licensePlate}</td>
                        <td style="color: var(--incoming-primary);">${truck.incomingCount}</td>
                        <td style="color: var(--outgoing-primary); font-weight: bold;">${truck.outgoingCount}</td>
                        <td>${totalTrips}</td>
                        <td>${incomingVol.toFixed(1)} m³ / ${outgoingVol.toFixed(1)} m³</td>
                        <td>${truck.capacity} m³</td>
                    </tr>
                `;
            }).join('');

            html += `
                    </tbody>
                </table>
            `;
        }

        container.innerHTML = html;
    }

    // Movement Table
    updateMovementTable() {
        const tableBody = document.querySelector('#movementTable tbody');

        if (this.movements.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 40px;">
                        No hay movimientos registrados
                    </td>
                </tr>
            `;
            return;
        }

        // Sort movements by timestamp (most recent first)
        const sortedMovements = [...this.movements].sort((a, b) =>
            new Date(b.timestamp) - new Date(a.timestamp)
        );

        // Limit to last 50 movements for performance
        const displayMovements = sortedMovements.slice(0, 50);

        tableBody.innerHTML = displayMovements.map(movement => {
            const date = new Date(movement.timestamp);
            const hours = date.getHours() % 12 || 12;
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const period = date.getHours() >= 12 ? 'PM' : 'AM';
            const timeStr = `${hours}:${minutes} ${period}`;

            const typeText = movement.type === 'incoming' ? 'Entrante' : 'Saliente';
            const volumeSign = movement.type === 'incoming' ? '+' : '-';
            const volumeClass = movement.type === 'incoming' ? 'positive' : 'negative';

            return `
                <tr>
                    <td class="table-time">${timeStr}</td>
                    <td class="table-truck">${movement.truckName}</td>
                    <td>${movement.licensePlate}</td>
                    <td>${typeText}</td>
                    <td class="table-location">${movement.material || '-'}</td>
                    <td class="table-volume ${volumeClass}">${volumeSign}${movement.capacity.toFixed(1)} m³</td>
                    <td class="table-location">${movement.location || '-'}</td>
                </tr>
            `;
        }).join('');
    }

    // Auto-refresh with Real-Time Sync
    startAutoRefresh() {
        const indicator = document.getElementById('refreshIndicator');
        const text = document.getElementById('refreshText');

        // Initial state
        text.textContent = 'Sincronización en tiempo real activa';

        // REAL-TIME SYNC: Listen for storage changes from other tabs/windows
        window.addEventListener('storage', (e) => {
            // Only react to changes in trucks or movements
            if (e.key === 'trucks' || e.key === 'movements') {
                console.log('Storage changed:', e.key);
                indicator.classList.add('active');
                text.textContent = 'Actualizando datos en tiempo real...';

                this.loadData();
                this.renderDashboard();

                setTimeout(() => {
                    indicator.classList.remove('active');
                    text.textContent = 'Sincronización en tiempo real activa';
                }, 1000);
            }
        });

        // Backup: Also refresh every 30 seconds (in case of same-tab updates)
        this.refreshInterval = setInterval(() => {
            this.loadData();
            this.renderDashboard();
        }, 30000); // 30 seconds
    }

    stopAutoRefresh() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
            this.refreshInterval = null;
        }
    }
}

// Initialize Dashboard
let bossDashboard;

document.addEventListener('DOMContentLoaded', () => {
    bossDashboard = new BossDashboard();
});

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (bossDashboard) {
        bossDashboard.stopAutoRefresh();
    }
});

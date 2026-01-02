class HistoryManager {
    constructor() {
        this.history = this.loadHistory();
        this.checkAutoArchive(); // Check if we need to auto-archive
        this.init();
    }

    init() {
        this.renderHistory();
    }

    loadHistory() {
        const stored = localStorage.getItem('dailyHistory');
        return stored ? JSON.parse(stored) : [];
    }

    saveHistory() {
        localStorage.setItem('dailyHistory', JSON.stringify(this.history));
    }

    // Check if we need to auto-archive previous day's data
    checkAutoArchive() {
        const lastDate = localStorage.getItem('lastDate');
        const today = new Date().toDateString();

        // If date changed and we have data, auto-archive
        if (lastDate && lastDate !== today) {
            const trucks = JSON.parse(localStorage.getItem('trucks') || '[]');
            const movements = JSON.parse(localStorage.getItem('movements') || '[]');

            // Only archive if there's actual data
            if (movements.length > 0) {
                console.log('Auto-archiving previous day data...');
                this.archiveCurrentDay(true); // true = silent mode
            }
        }
    }

    archiveCurrentDay(silent = false) {
        // Load current data
        const trucks = JSON.parse(localStorage.getItem('trucks') || '[]');
        const movements = JSON.parse(localStorage.getItem('movements') || '[]');
        const materials = JSON.parse(localStorage.getItem('materials') || '{}');

        if (movements.length === 0) {
            if (!silent) {
                alert('No hay movimientos para archivar.');
            }
            return;
        }

        // Calculate statistics
        const fillVolume = movements
            .filter(m => m.type === 'incoming')
            .reduce((sum, m) => sum + m.capacity, 0);

        const excavationVolume = movements
            .filter(m => m.type === 'outgoing')
            .reduce((sum, m) => sum + m.capacity, 0);

        const incomingCount = movements.filter(m => m.type === 'incoming').length;
        const outgoingCount = movements.filter(m => m.type === 'outgoing').length;

        // Create archive entry
        const archive = {
            id: Date.now(),
            date: new Date().toISOString(),
            dateStr: new Date().toLocaleDateString('es-ES', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            }),
            trucks: trucks.length,
            totalTrips: movements.length,
            incomingTrips: incomingCount,
            outgoingTrips: outgoingCount,
            fillVolume: fillVolume,
            excavationVolume: excavationVolume,
            trucksData: JSON.parse(JSON.stringify(trucks)),
            movementsData: JSON.parse(JSON.stringify(movements)),
            materialsData: JSON.parse(JSON.stringify(materials))
        };

        // Add to history
        this.history.unshift(archive);
        this.saveHistory();

        if (silent) {
            // Auto-archive mode - just archive and continue
            console.log('Day auto-archived successfully');
            this.renderHistory();
        } else {
            // Manual archive - ask if user wants to clear data
            if (confirm('¿Deseas limpiar los datos actuales después de archivar?')) {
                localStorage.removeItem('trucks');
                localStorage.removeItem('movements');
                alert('Día archivado y datos limpiados. Puedes comenzar un nuevo día.');
                window.location.href = 'index.html';
            } else {
                alert('Día archivado exitosamente.');
                this.renderHistory();
            }
        }
    }

    renderHistory() {
        const container = document.getElementById('historyList');

        if (this.history.length === 0) {
            container.innerHTML = `
                <div style="text-align: center; padding: 60px 20px; color: var(--text-muted);">
                    <div style="font-size: 48px; margin-bottom: 16px;">📭</div>
                    <p style="font-size: 16px; font-weight: 600; margin-bottom: 8px;">No hay reportes archivados</p>
                    <p style="font-size: 14px;">Los reportes diarios aparecerán aquí cuando los archives</p>
                </div>
            `;
            return;
        }

        container.innerHTML = this.history.map(archive => `
            <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 16px; margin-bottom: 16px;">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px;">
                    <div>
                        <h3 style="font-size: 16px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px;">
                            ${archive.dateStr}
                        </h3>
                        <p style="font-size: 12px; color: var(--text-muted);">
                            ${new Date(archive.date).toLocaleTimeString('es-ES')}
                        </p>
                    </div>
                    <button onclick="historyManager.deleteArchive(${archive.id})" 
                        style="background: rgba(239, 68, 68, 0.2); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); padding: 6px 12px; border-radius: 6px; font-size: 11px; cursor: pointer; font-weight: 600;">
                        Eliminar
                    </button>
                </div>

                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-bottom: 12px;">
                    <div style="background: rgba(255,255,255,0.03); padding: 12px; border-radius: 8px;">
                        <div style="font-size: 11px; color: var(--text-muted); margin-bottom: 4px;">Camiones</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--text-primary);">${archive.trucks}</div>
                    </div>
                    <div style="background: rgba(255,255,255,0.03); padding: 12px; border-radius: 8px;">
                        <div style="font-size: 11px; color: var(--text-muted); margin-bottom: 4px;">Total Vueltas</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--text-primary);">${archive.totalTrips}</div>
                    </div>
                    <div style="background: rgba(255,255,255,0.03); padding: 12px; border-radius: 8px; border-left: 3px solid var(--incoming-primary);">
                        <div style="font-size: 11px; color: var(--text-muted); margin-bottom: 4px;">Relleno</div>
                        <div style="font-size: 16px; font-weight: 700; color: var(--incoming-primary);">
                            ${archive.incomingTrips} (${archive.fillVolume.toFixed(1)} m³)
                        </div>
                    </div>
                    <div style="background: rgba(255,255,255,0.03); padding: 12px; border-radius: 8px; border-left: 3px solid var(--outgoing-primary);">
                        <div style="font-size: 11px; color: var(--text-muted); margin-bottom: 4px;">Excavación</div>
                        <div style="font-size: 16px; font-weight: 700; color: var(--outgoing-primary);">
                            ${archive.outgoingTrips} (${archive.excavationVolume.toFixed(1)} m³)
                        </div>
                    </div>
                </div>

                <div style="display: flex; gap: 8px;">
                    <button onclick="historyManager.viewDetails(${archive.id})" 
                        style="flex: 1; padding: 10px; background: rgba(59, 130, 246, 0.2); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.3); border-radius: 8px; font-size: 12px; cursor: pointer; font-weight: 600;">
                        Ver Detalles
                    </button>
                    <button onclick="historyManager.downloadPDF(${archive.id})" 
                        style="flex: 1; padding: 10px; background: rgba(139, 92, 246, 0.2); color: #8b5cf6; border: 1px solid rgba(139, 92, 246, 0.3); border-radius: 8px; font-size: 12px; cursor: pointer; font-weight: 600;">
                        Descargar PDF
                    </button>
                </div>
            </div>
        `).join('');
    }

    viewDetails(archiveId) {
        const archive = this.history.find(a => a.id === archiveId);
        if (!archive) return;

        // Create modal
        const modal = document.createElement('div');
        modal.className = 'modal active';
        modal.id = 'detailsModal';

        // Calculate additional stats
        const movements = archive.movementsData || [];
        const trucks = archive.trucksData || [];

        // Calculate operating time
        let operatingTime = '0h 0m';
        let avgPerHour = 0;
        if (movements.length > 0) {
            const sorted = [...movements].sort((a, b) =>
                new Date(a.timestamp) - new Date(b.timestamp)
            );
            const first = new Date(sorted[0].timestamp);
            const last = new Date(sorted[sorted.length - 1].timestamp);
            const diffMs = last - first;
            const hours = Math.floor(diffMs / (1000 * 60 * 60));
            const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
            operatingTime = `${hours}h ${minutes}m`;

            const totalHours = diffMs / (1000 * 60 * 60);
            avgPerHour = totalHours > 0 ? (movements.length / totalHours).toFixed(1) : 0;
        }

        // Group movements by hour for activity chart
        const hourlyData = {};
        movements.forEach(movement => {
            const hour = new Date(movement.timestamp).getHours();
            hourlyData[hour] = (hourlyData[hour] || 0) + 1;
        });
        const maxCount = Math.max(...Object.values(hourlyData), 1);
        const hours = Object.keys(hourlyData).sort((a, b) => a - b);

        // Sort trucks by performance
        const sortedTrucks = [...trucks].sort((a, b) =>
            (b.incomingCount + b.outgoingCount) - (a.incomingCount + a.outgoingCount)
        );

        // Build material breakdown
        const incomingMaterials = {};
        const outgoingMaterials = {};
        movements.forEach(m => {
            if (m.material) {
                if (m.type === 'incoming') {
                    incomingMaterials[m.material] = (incomingMaterials[m.material] || 0) + m.capacity;
                } else {
                    outgoingMaterials[m.material] = (outgoingMaterials[m.material] || 0) + m.capacity;
                }
            }
        });

        modal.innerHTML = `
            <div class="modal-content" style="max-width: 1200px; max-height: 90vh; overflow-y: auto;">
                <div class="modal-header">
                    <h3>📊 Detalles del Reporte - ${archive.dateStr}</h3>
                    <button class="close-btn" onclick="document.getElementById('detailsModal').remove()">×</button>
                </div>
                <div style="padding: 20px;">
                    <!-- KPI Cards -->
                    <div class="kpi-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px;">
                        <div class="kpi-card" style="background: var(--bg-card); padding: 16px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <div style="font-size: 11px; color: var(--text-secondary); text-transform: uppercase; margin-bottom: 8px;">Total Vueltas</div>
                            <div style="font-size: 28px; font-weight: 800; background: linear-gradient(135deg, var(--accent-blue) 0%, var(--accent-purple) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">${archive.totalTrips}</div>
                        </div>
                        <div class="kpi-card" style="background: var(--bg-card); padding: 16px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <div style="font-size: 11px; color: var(--text-secondary); text-transform: uppercase; margin-bottom: 8px;">Promedio/Hora</div>
                            <div style="font-size: 28px; font-weight: 800; background: linear-gradient(135deg, var(--accent-blue) 0%, var(--accent-purple) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">${avgPerHour}</div>
                        </div>
                        <div class="kpi-card" style="background: var(--bg-card); padding: 16px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <div style="font-size: 11px; color: var(--text-secondary); text-transform: uppercase; margin-bottom: 8px;">Tiempo Operando</div>
                            <div style="font-size: 28px; font-weight: 800; background: linear-gradient(135deg, var(--accent-blue) 0%, var(--accent-purple) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">${operatingTime}</div>
                        </div>
                    </div>

                    <!-- Dashboard Grid -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                        <!-- Volume Balance -->
                        <div style="background: var(--bg-card); padding: 20px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 16px;">Balance de Volumen</h3>
                            <div class="volume-balance">
                                <div class="balance-item incoming-balance" style="margin-bottom: 16px;">
                                    <div class="balance-icon" style="font-size: 32px;">📦</div>
                                    <div class="balance-info">
                                        <div class="balance-label" style="font-size: 12px; color: var(--text-secondary);">Relleno</div>
                                        <div class="balance-value" style="font-size: 24px; font-weight: 700; color: var(--incoming-primary);">+${archive.fillVolume.toFixed(1)} m³</div>
                                        ${Object.keys(incomingMaterials).length > 0 ? `
                                            <div class="material-breakdown" style="margin-top: 8px; padding-top: 8px; border-top: 1px solid var(--border-color);">
                                                ${Object.entries(incomingMaterials).map(([mat, vol]) => `
                                                    <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px;">
                                                        <span style="color: var(--text-secondary);">${mat}</span>
                                                        <span style="color: var(--text-primary); font-weight: 600;">${vol.toFixed(1)} m³</span>
                                                    </div>
                                                `).join('')}
                                            </div>
                                        ` : ''}
                                    </div>
                                </div>
                                <div class="balance-item outgoing-balance">
                                    <div class="balance-icon" style="font-size: 32px;">🚚</div>
                                    <div class="balance-info">
                                        <div class="balance-label" style="font-size: 12px; color: var(--text-secondary);">Excavación</div>
                                        <div class="balance-value" style="font-size: 24px; font-weight: 700; color: var(--outgoing-primary);">-${archive.excavationVolume.toFixed(1)} m³</div>
                                        ${Object.keys(outgoingMaterials).length > 0 ? `
                                            <div class="material-breakdown" style="margin-top: 8px; padding-top: 8px; border-top: 1px solid var(--border-color);">
                                                ${Object.entries(outgoingMaterials).map(([mat, vol]) => `
                                                    <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px;">
                                                        <span style="color: var(--text-secondary);">${mat}</span>
                                                        <span style="color: var(--text-primary); font-weight: 600;">${vol.toFixed(1)} m³</span>
                                                    </div>
                                                `).join('')}
                                            </div>
                                        ` : ''}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Hourly Activity -->
                        <div style="background: var(--bg-card); padding: 20px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 16px;">Actividad por Hora</h3>
                            <div class="hourly-activity">
                                ${hours.length > 0 ? hours.map(hour => {
            const count = hourlyData[hour];
            const percentage = (count / maxCount) * 100;
            const displayHour = parseInt(hour) % 12 || 12;
            const period = parseInt(hour) >= 12 ? 'PM' : 'AM';
            return `
                                        <div class="hour-bar" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                                            <div class="hour-label" style="min-width: 50px; font-size: 11px; color: var(--text-secondary);">${displayHour} ${period}</div>
                                            <div class="hour-graph" style="flex: 1; height: 20px; background: rgba(255,255,255,0.05); border-radius: 4px; overflow: hidden;">
                                                <div class="hour-fill" style="width: ${percentage}%; height: 100%; background: linear-gradient(90deg, var(--accent-blue), var(--accent-purple)); border-radius: 4px;"></div>
                                            </div>
                                            <div class="hour-count" style="min-width: 30px; text-align: right; font-size: 12px; font-weight: 600;">${count}</div>
                                        </div>
                                    `;
        }).join('') : '<p style="color: var(--text-muted); text-align: center;">No hay datos</p>'}
                            </div>
                        </div>
                    </div>

                    <!-- Truck Performance Table -->
                    <div style="background: var(--bg-card); padding: 20px; border-radius: 12px; border: 1px solid var(--border-color); margin-bottom: 20px;">
                        <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 16px;">Rendimiento por Camión</h3>
                        <div style="overflow-x: auto;">
                            <table class="performance-table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">#</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Camión</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Patente</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Relleno</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Excavación</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Total</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Volumen</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${sortedTrucks.map((truck, index) => {
            const totalTrips = truck.incomingCount + truck.outgoingCount;
            const totalVol = (truck.incomingCount * truck.capacity) + (truck.outgoingCount * truck.capacity);
            return `
                                            <tr style="border-bottom: 1px solid var(--border-color);">
                                                <td style="padding: 10px; font-size: 13px;">
                                                    <span style="display: inline-block; width: 24px; height: 24px; border-radius: 50%; background: ${index === 0 ? 'linear-gradient(135deg, #ffd700 0%, #ffed4e 100%)' : 'var(--bg-glass)'}; text-align: center; line-height: 24px; font-weight: 700; font-size: 12px; color: ${index === 0 ? '#000' : 'var(--text-primary)'};">${index + 1}</span>
                                                </td>
                                                <td style="padding: 10px; font-size: 13px; font-weight: 600;">${truck.name}</td>
                                                <td style="padding: 10px; font-size: 13px;">${truck.licensePlate}</td>
                                                <td style="padding: 10px; font-size: 13px; color: var(--incoming-primary);">${truck.incomingCount}</td>
                                                <td style="padding: 10px; font-size: 13px; color: var(--outgoing-primary);">${truck.outgoingCount}</td>
                                                <td style="padding: 10px; font-size: 13px; font-weight: 700;">${totalTrips}</td>
                                                <td style="padding: 10px; font-size: 13px; font-weight: 600;">${totalVol.toFixed(1)} m³</td>
                                            </tr>
                                        `;
        }).join('')}
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Movement History Table -->
                    <div style="background: var(--bg-card); padding: 20px; border-radius: 12px; border: 1px solid var(--border-color);">
                        <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 16px;">Historial de Movimientos (${movements.length})</h3>
                        <div style="overflow-x: auto; max-height: 400px; overflow-y: auto;">
                            <table class="movement-table" style="width: 100%; border-collapse: collapse;">
                                <thead style="position: sticky; top: 0; background: var(--bg-card); z-index: 10;">
                                    <tr>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Hora</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Camión</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Tipo</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Volumen</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Material</th>
                                        <th style="text-align: left; padding: 10px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border-color);">Ubicación</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${[...movements].sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp)).map(movement => {
            const date = new Date(movement.timestamp);
            const hours = date.getHours();
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const period = hours >= 12 ? 'PM' : 'AM';
            const displayHours = hours % 12 || 12;
            const timeStr = `${displayHours}:${minutes} ${period}`;
            const typeIcon = movement.type === 'incoming' ? '📥' : '📤';
            const typeText = movement.type === 'incoming' ? 'Relleno' : 'Excavación';
            const volumeSign = movement.type === 'incoming' ? '+' : '-';
            const volumeColor = movement.type === 'incoming' ? 'var(--incoming-primary)' : 'var(--outgoing-primary)';

            return `
                                            <tr style="border-bottom: 1px solid var(--border-color);">
                                                <td style="padding: 10px; font-size: 12px; color: var(--text-secondary);">${timeStr}</td>
                                                <td style="padding: 10px; font-size: 13px; font-weight: 600;">${movement.truckName}</td>
                                                <td style="padding: 10px; font-size: 13px;">${typeIcon} ${typeText}</td>
                                                <td style="padding: 10px; font-size: 13px; font-weight: 700; color: ${volumeColor};">${volumeSign}${movement.capacity.toFixed(1)} m³</td>
                                                <td style="padding: 10px; font-size: 12px; color: var(--text-muted);">${movement.material || '-'}</td>
                                                <td style="padding: 10px; font-size: 12px; color: var(--text-muted); font-style: italic;">${movement.location || '-'}</td>
                                            </tr>
                                        `;
        }).join('')}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(modal);

        // Close on outside click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });
    }

    downloadPDF(archiveId) {
        const archive = this.history.find(a => a.id === archiveId);
        if (!archive) return;

        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        const archiveDate = new Date(archive.date);
        const dateStr = archiveDate.toLocaleDateString('es-ES', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
        });

        // Calculate additional stats
        const movements = archive.movementsData || [];
        const trucks = archive.trucksData || [];

        // Calculate operating time
        let operatingTime = '0h 0m';
        let avgPerHour = '0';
        if (movements.length > 0) {
            const sorted = [...movements].sort((a, b) =>
                new Date(a.timestamp) - new Date(b.timestamp)
            );
            const first = new Date(sorted[0].timestamp);
            const last = new Date(sorted[sorted.length - 1].timestamp);
            const diffMs = last - first;
            const hours = Math.floor(diffMs / (1000 * 60 * 60));
            const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
            operatingTime = `${hours}h ${minutes}m`;

            const totalHours = diffMs / (1000 * 60 * 60);
            avgPerHour = totalHours > 0 ? (movements.length / totalHours).toFixed(1) : '0';
        }

        // Build material breakdown
        const incomingMaterials = {};
        const outgoingMaterials = {};
        movements.forEach(m => {
            if (m.material) {
                if (m.type === 'incoming') {
                    incomingMaterials[m.material] = (incomingMaterials[m.material] || 0) + m.capacity;
                } else {
                    outgoingMaterials[m.material] = (outgoingMaterials[m.material] || 0) + m.capacity;
                }
            }
        });

        // Sort trucks by performance
        const sortedTrucks = [...trucks].sort((a, b) =>
            (b.incomingCount + b.outgoingCount) - (a.incomingCount + a.outgoingCount)
        );

        // Group movements by hour for activity chart
        const hourlyData = {};
        movements.forEach(movement => {
            const hour = new Date(movement.timestamp).getHours();
            hourlyData[hour] = (hourlyData[hour] || 0) + 1;
        });
        const maxHourlyCount = Math.max(...Object.values(hourlyData), 1);
        const hours = Object.keys(hourlyData).sort((a, b) => a - b);

        // Modern Color Palette
        const darkBg = [30, 41, 59]; // slate-800
        const cardBg = [51, 65, 85]; // slate-700
        const primaryGreen = [16, 185, 129]; // emerald-500
        const primaryOrange = [251, 146, 60]; // orange-400
        const accentBlue = [96, 165, 250]; // blue-400
        const accentPurple = [167, 139, 250]; // violet-400
        const textLight = [241, 245, 249]; // slate-100
        const textMuted = [148, 163, 184]; // slate-400

        // ========== PAGE 1: MODERN HEADER ==========

        // Dark gradient header background
        doc.setFillColor(...darkBg);
        doc.rect(0, 0, 210, 55, 'F');

        // Accent line at top
        doc.setFillColor(...accentBlue);
        doc.rect(0, 0, 210, 3, 'F');

        // Title
        doc.setTextColor(...textLight);
        doc.setFontSize(24);
        doc.setFont(undefined, 'bold');
        doc.text('REPORTE DIARIO DE CAMIONES', 105, 22, { align: 'center' });

        // Date
        doc.setFontSize(12);
        doc.setFont(undefined, 'normal');
        doc.setTextColor(...textMuted);
        doc.text(dateStr, 105, 32, { align: 'center' });

        // Generation timestamp
        doc.setFontSize(9);
        doc.text(`Generado: ${new Date().toLocaleString('es-ES')}`, 105, 40, { align: 'center' });

        let yPos = 65;

        // ========== KPI CARDS ==========
        doc.setTextColor(0, 0, 0);

        const kpis = [
            { label: 'TOTAL VUELTAS', value: archive.totalTrips.toString(), color: primaryGreen },
            { label: 'PROMEDIO/HORA', value: avgPerHour, color: primaryOrange },
            { label: 'TIEMPO OPERANDO', value: operatingTime, color: accentPurple }
        ];

        const cardWidth = 58;
        const cardHeight = 28;
        const cardSpacing = 8;
        let cardX = 15;

        kpis.forEach((kpi) => {
            // Card shadow (offset)
            doc.setFillColor(200, 200, 200);
            doc.roundedRect(cardX + 1, yPos + 1, cardWidth, cardHeight, 4, 4, 'F');

            // Card background
            doc.setFillColor(255, 255, 255);
            doc.roundedRect(cardX, yPos, cardWidth, cardHeight, 4, 4, 'F');

            // Colored accent bar
            doc.setFillColor(...kpi.color);
            doc.roundedRect(cardX, yPos, cardWidth, 4, 4, 4, 'F');

            // Label
            doc.setFontSize(8);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(...textMuted);
            doc.text(kpi.label, cardX + cardWidth / 2, yPos + 12, { align: 'center' });

            // Value
            doc.setFontSize(18);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(...kpi.color);
            doc.text(kpi.value, cardX + cardWidth / 2, yPos + 23, { align: 'center' });

            cardX += cardWidth + cardSpacing;
        });

        yPos += cardHeight + 15;

        // ========== SUMMARY SECTION ==========
        doc.setFontSize(13);
        doc.setFont(undefined, 'bold');
        doc.setTextColor(...accentBlue);
        doc.text('Resumen General', 15, yPos);
        yPos += 3;

        doc.autoTable({
            startY: yPos,
            head: [['Concepto', 'Valor']],
            body: [
                ['Total Camiones Registrados', archive.trucks.toString()],
                ['Vueltas de Relleno', `${archive.incomingTrips} vueltas`],
                ['Vueltas de Excavacion', `${archive.outgoingTrips} vueltas`],
                ['Volumen Total Movido', `${(archive.fillVolume + archive.excavationVolume).toFixed(1)} m3`]
            ],
            theme: 'grid',
            headStyles: {
                fillColor: accentBlue,
                textColor: textLight,
                fontSize: 9,
                fontStyle: 'bold',
                halign: 'left'
            },
            bodyStyles: {
                fontSize: 9,
                textColor: [30, 41, 59]
            },
            columnStyles: {
                0: { fontStyle: 'bold', cellWidth: 85 },
                1: { halign: 'right', cellWidth: 'auto', fontStyle: 'bold' }
            },
            margin: { left: 15, right: 15 }
        });

        yPos = doc.lastAutoTable.finalY + 12;

        // ========== VOLUME BALANCE SECTION ==========
        doc.setFontSize(13);
        doc.setFont(undefined, 'bold');
        doc.setTextColor(...accentBlue);
        doc.text('Balance de Volumen', 15, yPos);
        yPos += 3;

        // Incoming Volume Table (Left)
        const incomingBody = [
            ['TOTAL RELLENO', `+${archive.fillVolume.toFixed(1)} m3`],
            ...Object.entries(incomingMaterials).map(([mat, vol]) => [
                `  ${mat}`, `${vol.toFixed(1)} m3`
            ])
        ];

        doc.autoTable({
            startY: yPos,
            head: [['Material', 'Volumen']],
            body: incomingBody.length > 1 ? incomingBody : [['TOTAL RELLENO', `+${archive.fillVolume.toFixed(1)} m3`]],
            theme: 'grid',
            headStyles: {
                fillColor: primaryGreen,
                textColor: textLight,
                fontSize: 9,
                fontStyle: 'bold'
            },
            bodyStyles: {
                fontSize: 8,
                textColor: [30, 41, 59]
            },
            columnStyles: {
                0: { cellWidth: 60 },
                1: { halign: 'right', fontStyle: 'bold', cellWidth: 30 }
            },
            didParseCell: function (data) {
                if (data.section === 'body' && data.row.index === 0) {
                    data.cell.styles.fontStyle = 'bold';
                    data.cell.styles.fillColor = [220, 252, 231];
                    data.cell.styles.textColor = [6, 95, 70];
                }
            },
            margin: { left: 15, right: 110 }
        });

        const incomingTableEnd = doc.lastAutoTable.finalY;

        // Outgoing Volume Table (Right)
        const outgoingBody = [
            ['TOTAL EXCAVACION', `-${archive.excavationVolume.toFixed(1)} m3`],
            ...Object.entries(outgoingMaterials).map(([mat, vol]) => [
                `  ${mat}`, `${vol.toFixed(1)} m3`
            ])
        ];

        doc.autoTable({
            startY: yPos,
            head: [['Material', 'Volumen']],
            body: outgoingBody.length > 1 ? outgoingBody : [['TOTAL EXCAVACION', `-${archive.excavationVolume.toFixed(1)} m3`]],
            theme: 'grid',
            headStyles: {
                fillColor: primaryOrange,
                textColor: textLight,
                fontSize: 9,
                fontStyle: 'bold'
            },
            bodyStyles: {
                fontSize: 8,
                textColor: [30, 41, 59]
            },
            columnStyles: {
                0: { cellWidth: 60 },
                1: { halign: 'right', fontStyle: 'bold', cellWidth: 30 }
            },
            didParseCell: function (data) {
                if (data.section === 'body' && data.row.index === 0) {
                    data.cell.styles.fontStyle = 'bold';
                    data.cell.styles.fillColor = [254, 243, 199];
                    data.cell.styles.textColor = [124, 45, 18];
                }
            },
            margin: { left: 110, right: 15 }
        });

        yPos = Math.max(incomingTableEnd, doc.lastAutoTable.finalY) + 12;

        // ========== HOURLY ACTIVITY CHART ==========
        if (hours.length > 0) {
            doc.setFontSize(13);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(...accentBlue);
            doc.text('Actividad por Hora', 15, yPos);
            yPos += 8;

            const barHeight = 6;
            const barMaxWidth = 150;
            const barSpacing = 2;

            hours.forEach(hour => {
                const count = hourlyData[hour];
                const percentage = (count / maxHourlyCount);
                const barWidth = percentage * barMaxWidth;
                const displayHour = parseInt(hour) % 12 || 12;
                const period = parseInt(hour) >= 12 ? 'PM' : 'AM';

                // Hour label
                doc.setFontSize(8);
                doc.setFont(undefined, 'normal');
                doc.setTextColor(...textMuted);
                doc.text(`${displayHour} ${period}`, 15, yPos + 4);

                // Bar background
                doc.setFillColor(240, 240, 240);
                doc.roundedRect(35, yPos, barMaxWidth, barHeight, 2, 2, 'F');

                // Bar fill
                doc.setFillColor(...accentBlue);
                if (barWidth > 0) {
                    doc.roundedRect(35, yPos, barWidth, barHeight, 2, 2, 'F');
                }

                // Count label
                doc.setFontSize(8);
                doc.setFont(undefined, 'bold');
                doc.setTextColor(0, 0, 0);
                doc.text(count.toString(), 188, yPos + 4);

                yPos += barHeight + barSpacing;
            });

            yPos += 8;
        }

        // Check if we need a new page
        if (yPos > 230) {
            doc.addPage();
            yPos = 20;
        }

        // ========== TRUCK PERFORMANCE TABLE ==========
        doc.setFontSize(13);
        doc.setFont(undefined, 'bold');
        doc.setTextColor(...accentBlue);
        doc.text('Rendimiento por Camion', 15, yPos);
        yPos += 3;

        const truckTableData = sortedTrucks.map((truck, index) => {
            const totalTrips = truck.incomingCount + truck.outgoingCount;
            const totalVol = (truck.incomingCount * truck.capacity) + (truck.outgoingCount * truck.capacity);
            return [
                (index + 1).toString(),
                truck.name,
                truck.licensePlate,
                truck.incomingCount.toString(),
                truck.outgoingCount.toString(),
                totalTrips.toString(),
                `${totalVol.toFixed(1)} m3`
            ];
        });

        doc.autoTable({
            startY: yPos,
            head: [['#', 'Camion', 'Patente', 'Relleno', 'Excavacion', 'Total', 'Volumen']],
            body: truckTableData,
            theme: 'grid',
            headStyles: {
                fillColor: accentPurple,
                textColor: textLight,
                fontSize: 9,
                fontStyle: 'bold',
                halign: 'center'
            },
            bodyStyles: {
                fontSize: 8,
                textColor: [30, 41, 59]
            },
            columnStyles: {
                0: { cellWidth: 10, halign: 'center', fontStyle: 'bold' },
                1: { cellWidth: 35, fontStyle: 'bold' },
                2: { cellWidth: 25, halign: 'center' },
                3: { cellWidth: 20, halign: 'center' },
                4: { cellWidth: 25, halign: 'center' },
                5: { cellWidth: 18, halign: 'center', fontStyle: 'bold' },
                6: { cellWidth: 28, halign: 'right', fontStyle: 'bold' }
            },
            didParseCell: function (data) {
                // Highlight top performer with gold
                if (data.section === 'body' && data.row.index === 0) {
                    data.cell.styles.fillColor = [255, 237, 213];
                    data.cell.styles.textColor = [120, 53, 15];
                }
            },
            margin: { left: 15, right: 15 }
        });

        yPos = doc.lastAutoTable.finalY + 12;

        // ========== NEW PAGE FOR MOVEMENTS ==========
        if (movements.length > 0) {
            doc.addPage();
            yPos = 20;

            doc.setFontSize(13);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(...accentBlue);
            doc.text(`Historial de Movimientos (${movements.length} registros)`, 15, yPos);
            yPos += 3;

            // Movement History Table
            const movementTableData = [...movements]
                .sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp))
                .map(movement => {
                    const date = new Date(movement.timestamp);
                    const hours = date.getHours();
                    const minutes = date.getMinutes().toString().padStart(2, '0');
                    const period = hours >= 12 ? 'PM' : 'AM';
                    const displayHours = hours % 12 || 12;
                    const timeStr = `${displayHours}:${minutes} ${period}`;
                    const typeText = movement.type === 'incoming' ? 'Relleno' : 'Excavacion';
                    const volumeSign = movement.type === 'incoming' ? '+' : '-';

                    return [
                        timeStr,
                        movement.truckName,
                        movement.licensePlate,
                        typeText,
                        `${volumeSign}${movement.capacity.toFixed(1)} m3`,
                        movement.material || '-',
                        movement.location || '-'
                    ];
                });

            doc.autoTable({
                startY: yPos,
                head: [['Hora', 'Camion', 'Patente', 'Tipo', 'Volumen', 'Material', 'Ubicacion']],
                body: movementTableData,
                theme: 'striped',
                headStyles: {
                    fillColor: accentBlue,
                    textColor: textLight,
                    fontSize: 8,
                    fontStyle: 'bold',
                    halign: 'center'
                },
                bodyStyles: {
                    fontSize: 7,
                    textColor: [30, 41, 59]
                },
                columnStyles: {
                    0: { cellWidth: 20, halign: 'center' },
                    1: { cellWidth: 28, fontStyle: 'bold' },
                    2: { cellWidth: 22, halign: 'center' },
                    3: { cellWidth: 24, halign: 'center' },
                    4: { cellWidth: 24, halign: 'right', fontStyle: 'bold' },
                    5: { cellWidth: 26 },
                    6: { cellWidth: 28, fontSize: 6 }
                },
                didParseCell: function (data) {
                    // Color code by type
                    if (data.section === 'body' && data.column.index === 3) {
                        if (data.cell.raw === 'Relleno') {
                            data.cell.styles.textColor = primaryGreen;
                            data.cell.styles.fontStyle = 'bold';
                        } else {
                            data.cell.styles.textColor = primaryOrange;
                            data.cell.styles.fontStyle = 'bold';
                        }
                    }
                },
                margin: { left: 15, right: 15 }
            });
        }

        // ========== MODERN FOOTER ON ALL PAGES ==========
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);

            // Footer background
            doc.setFillColor(...darkBg);
            doc.rect(0, 285, 210, 12, 'F');

            // Footer content
            doc.setFontSize(8);
            doc.setFont(undefined, 'normal');
            doc.setTextColor(...textMuted);
            doc.text('Sistema de Conteo de Camiones', 15, 291);
            doc.text(`Pagina ${i} de ${pageCount}`, 105, 291, { align: 'center' });
            doc.text(dateStr, 195, 291, { align: 'right' });
        }

        // Download
        const filename = `Reporte_${archiveDate.getFullYear()}-${(archiveDate.getMonth() + 1).toString().padStart(2, '0')}-${archiveDate.getDate().toString().padStart(2, '0')}.pdf`;
        doc.save(filename);
    }

    deleteArchive(archiveId) {
        if (!confirm('¿Estás seguro de eliminar este reporte archivado?')) return;

        this.history = this.history.filter(a => a.id !== archiveId);
        this.saveHistory();
        this.renderHistory();
    }
}

// Initialize
let historyManager;
document.addEventListener('DOMContentLoaded', () => {
    historyManager = new HistoryManager();
});

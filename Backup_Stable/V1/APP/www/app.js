// Truck Counter Application - Mixed Trip Types
// Trucks can now do both incoming AND outgoing trips

class TruckManager {
    constructor() {
        this.trucks = this.loadTrucks();
        this.movements = this.loadMovements();
        this.materials = this.loadMaterials();
        this.currentSelectorType = null;
        this.currentMaterialType = 'incoming';
        this.currentTab = 'resumen';
        this.editingTruckId = null; // Track if we're editing a truck
        this.init();
    }

    init() {
        this.updateDate();
        this.checkDateReset();
        this.migrateLegacyData(); // Migrate old data format
        this.renderTruckList();
        this.updateCounters();
        this.updateSummary();
        this.renderMovementLog();
        this.updateAnalytics();
        this.attachEventListeners();
        this.setupKeyboardShortcuts();
        this.setupTabNavigation();
    }

    // Date Management
    updateDate() {
        const dateElement = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateElement.textContent = today.toLocaleDateString('es-ES', options);
    }

    checkDateReset() {
        const lastDate = localStorage.getItem('lastDate');
        const today = new Date().toDateString();

        if (lastDate !== today) {
            // Auto-archive previous day's data before resetting
            if (this.movements.length > 0) {
                console.log('Auto-archiving previous day data before reset...');
                this.autoArchiveDay();
            }

            // Reset counters and movements for new day
            this.trucks.forEach(truck => {
                truck.incomingCount = 0;
                truck.outgoingCount = 0;
            });
            this.movements = [];
            this.saveTrucks();
            this.saveMovements();
            localStorage.setItem('lastDate', today);
        }
    }

    // Auto-archive day data
    autoArchiveDay() {
        const fillVolume = this.movements
            .filter(m => m.type === 'incoming')
            .reduce((sum, m) => sum + m.capacity, 0);

        const excavationVolume = this.movements
            .filter(m => m.type === 'outgoing')
            .reduce((sum, m) => sum + m.capacity, 0);

        const incomingCount = this.movements.filter(m => m.type === 'incoming').length;
        const outgoingCount = this.movements.filter(m => m.type === 'outgoing').length;

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
            trucks: this.trucks.length,
            totalTrips: this.movements.length,
            incomingTrips: incomingCount,
            outgoingTrips: outgoingCount,
            fillVolume: fillVolume,
            excavationVolume: excavationVolume,
            trucksData: JSON.parse(JSON.stringify(this.trucks)),
            movementsData: JSON.parse(JSON.stringify(this.movements)),
            materialsData: JSON.parse(JSON.stringify(this.materials))
        };

        // Load existing history and add new archive
        const history = JSON.parse(localStorage.getItem('dailyHistory') || '[]');
        history.unshift(archive);
        localStorage.setItem('dailyHistory', JSON.stringify(history));

        console.log('Day auto-archived successfully');
    }

    // Migrate old data format (type-based) to new format (mixed trips)
    migrateLegacyData() {
        let needsSave = false;

        this.trucks.forEach(truck => {
            // Check if old format (has 'type' and 'count')
            if (truck.type !== undefined && truck.count !== undefined) {
                // Migrate to new format
                truck.incomingCount = truck.type === 'incoming' ? truck.count : 0;
                truck.outgoingCount = truck.type === 'outgoing' ? truck.count : 0;
                truck.registeredType = truck.type; // Preserve original registration type
                delete truck.type;
                delete truck.count;
                needsSave = true;
            }

            // Ensure new properties exist
            if (truck.incomingCount === undefined) truck.incomingCount = 0;
            if (truck.outgoingCount === undefined) truck.outgoingCount = 0;

            // Infer registeredType if missing
            if (truck.registeredType === undefined) {
                if (truck.incomingCount > 0 && truck.outgoingCount > 0) {
                    truck.registeredType = 'mixed';
                } else if (truck.incomingCount > 0) {
                    truck.registeredType = 'incoming';
                } else if (truck.outgoingCount > 0) {
                    truck.registeredType = 'outgoing';
                } else {
                    truck.registeredType = 'incoming'; // Default
                }
                needsSave = true;
            }
        });

        if (needsSave) {
            this.saveTrucks();
            console.log('Migrated legacy truck data to new format');
        }
    }

    // LocalStorage Management
    loadTrucks() {
        const stored = localStorage.getItem('trucks');
        return stored ? JSON.parse(stored) : [];
    }

    saveTrucks() {
        localStorage.setItem('trucks', JSON.stringify(this.trucks));
    }

    loadMovements() {
        const stored = localStorage.getItem('movements');
        return stored ? JSON.parse(stored) : [];
    }

    saveMovements() {
        localStorage.setItem('movements', JSON.stringify(this.movements));
    }

    loadMaterials() {
        const stored = localStorage.getItem('materials');
        if (stored) {
            return JSON.parse(stored);
        }
        // Default materials
        return {
            incoming: ['Base estabilizada', 'Grava', 'Ripio', 'Arena'],
            outgoing: ['Arcilla', 'Basura', 'Arena', 'Tierra']
        };
    }

    saveMaterials() {
        localStorage.setItem('materials', JSON.stringify(this.materials));
    }

    addMaterial(name, type) {
        if (!name || !name.trim()) return;
        const trimmedName = name.trim();
        if (!this.materials[type].includes(trimmedName)) {
            this.materials[type].push(trimmedName);
            this.saveMaterials();
            this.renderMaterialList();

            // Refresh material selector if it's open
            const materialSelectorModal = document.getElementById('materialSelectorModal');
            if (materialSelectorModal && materialSelectorModal.classList.contains('active')) {
                this.openMaterialSelector(this.selectedTripType);
            }
        }
    }

    deleteMaterial(name, type) {
        this.materials[type] = this.materials[type].filter(m => m !== name);
        this.saveMaterials();
        this.renderMaterialList();

        // Refresh material selector if it's open
        const materialSelectorModal = document.getElementById('materialSelectorModal');
        if (materialSelectorModal && materialSelectorModal.classList.contains('active')) {
            this.openMaterialSelector(this.selectedTripType);
        }
    }

    // Frequent Trucks Management
    loadFrequentTrucks() {
        const stored = localStorage.getItem('frequentTrucks');
        return stored ? JSON.parse(stored) : [];
    }

    saveFrequentTrucks(frequentTrucks) {
        localStorage.setItem('frequentTrucks', JSON.stringify(frequentTrucks));
    }

    updateTruckUsageStats(truckData) {
        let frequentTrucks = this.loadFrequentTrucks();

        // Find if truck already exists in frequent list
        const existingIndex = frequentTrucks.findIndex(ft =>
            ft.licensePlate.toUpperCase().trim().replace(/\s+/g, '') ===
            truckData.licensePlate.toUpperCase().trim().replace(/\s+/g, '')
        );

        if (existingIndex >= 0) {
            // Update existing truck
            frequentTrucks[existingIndex].usageCount++;
            frequentTrucks[existingIndex].lastUsed = new Date().toISOString();
            // Update other data in case it changed
            frequentTrucks[existingIndex].name = truckData.name;
            frequentTrucks[existingIndex].capacity = truckData.capacity;
        } else {
            // Add new truck to frequent list
            frequentTrucks.push({
                name: truckData.name,
                licensePlate: truckData.licensePlate,
                capacity: truckData.capacity,
                usageCount: 1,
                lastUsed: new Date().toISOString()
            });
        }

        // Sort by usage count (descending) and keep top 20
        frequentTrucks.sort((a, b) => b.usageCount - a.usageCount);
        frequentTrucks = frequentTrucks.slice(0, 20);

        this.saveFrequentTrucks(frequentTrucks);
    }

    getFrequentTrucks() {
        return this.loadFrequentTrucks();
    }

    // Truck Management - WITH DUPLICATE DETECTION
    addTruck(name, licensePlate, capacity, type) {
        // Normalize license plate for comparison (uppercase, no spaces)
        const normalizedPlate = licensePlate.toUpperCase().trim().replace(/\s+/g, '');

        // Check if truck with same license plate already exists
        const existingTruck = this.trucks.find(t =>
            t.licensePlate.toUpperCase().trim().replace(/\s+/g, '') === normalizedPlate
        );

        if (existingTruck) {
            // Truck already exists - check if it's trying to add opposite type
            const isAddingIncoming = type === 'incoming';
            const isAddingOutgoing = type === 'outgoing';

            // Check current registered type
            const currentType = existingTruck.registeredType;

            // If trying to add the same type, show warning
            if (currentType === type) {
                alert(`El camión con patente ${existingTruck.licensePlate} ya está registrado para ${type === 'incoming' ? 'Relleno' : 'Excavación'}.`);
                return;
            }

            // If it's already mixed, show info
            if (currentType === 'mixed') {
                alert(`El camión con patente ${existingTruck.licensePlate} ya está registrado para ambas operaciones (Relleno y Excavación).`);
                return;
            }

            // Otherwise, this is adding the opposite type - truck becomes mixed!
            existingTruck.registeredType = 'mixed';
            this.saveTrucks();
            alert(`✅ Camión ${existingTruck.name} ahora realizará AMBAS operaciones:\n📥 Relleno\n📤 Excavación`);

            // Update the UI
            this.renderTruckList();
            this.updateSummary();
            return;
        }

        // New truck - create with specified type
        const truck = {
            id: Date.now(),
            name,
            licensePlate: licensePlate.toUpperCase().trim(),
            capacity: parseFloat(capacity),
            registeredType: type, // Track what type(s) this truck is registered for
            incomingCount: 0,
            outgoingCount: 0
        };

        this.trucks.push(truck);
        this.saveTrucks();

        // Update usage statistics for frequent trucks
        this.updateTruckUsageStats({
            name: truck.name,
            licensePlate: truck.licensePlate,
            capacity: truck.capacity
        });

        this.renderTruckList();
        this.updateCounters();
        this.updateSummary();
        this.updateAnalytics();
    }

    deleteTruck(id) {
        // IMPORTANTE: Solo eliminamos el camión de la nómina
        // Los movimientos se mantienen para el registro del día

        this.trucks = this.trucks.filter(t => t.id !== id);
        this.saveTrucks();

        // Actualizar UI
        this.renderTruckList();
        this.renderMovementLog(); // Los movimientos siguen ahí
        this.updateCounters();
        this.updateSummary();
        this.updateAnalytics();
    }

    showDeleteConfirmation(event, truckId, truckName) {
        event.stopPropagation();

        // Remove any existing confirmation dropdowns
        const existingDropdown = document.querySelector('.delete-confirmation-dropdown');
        if (existingDropdown) {
            existingDropdown.remove();
        }

        // Get button position
        const button = event.target;
        const buttonRect = button.getBoundingClientRect();

        // Create dropdown
        const dropdown = document.createElement('div');
        dropdown.className = 'delete-confirmation-dropdown';
        dropdown.innerHTML = `
            <div class="delete-confirmation-content">
                <div class="delete-confirmation-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 20px; height: 20px; color: #ef4444;">
                        <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                    </svg>
                    <span>¿Eliminar camión?</span>
                </div>
                <div class="delete-confirmation-message">
                    Se eliminará <strong>${truckName}</strong> de la nómina. Sus vueltas registradas se mantendrán.
                </div>
                <div class="delete-confirmation-actions">
                    <button class="confirm-delete-btn" onclick="truckManager.confirmDelete(${truckId})">
                        Sí, eliminar
                    </button>
                    <button class="cancel-delete-btn" onclick="truckManager.cancelDelete()">
                        Cancelar
                    </button>
                </div>
            </div>
        `;

        // Position dropdown
        dropdown.style.position = 'fixed';
        dropdown.style.top = `${buttonRect.bottom + 8}px`;
        dropdown.style.left = `${buttonRect.left}px`;
        dropdown.style.zIndex = '10000';

        document.body.appendChild(dropdown);

        // Close on outside click
        setTimeout(() => {
            document.addEventListener('click', this.handleOutsideClick.bind(this), { once: true });
        }, 10);
    }

    handleOutsideClick(event) {
        const dropdown = document.querySelector('.delete-confirmation-dropdown');
        if (dropdown && !dropdown.contains(event.target)) {
            dropdown.remove();
        }
    }

    confirmDelete(truckId) {
        this.cancelDelete();
        this.deleteTruck(truckId);
    }

    cancelDelete() {
        const dropdown = document.querySelector('.delete-confirmation-dropdown');
        if (dropdown) {
            dropdown.remove();
        }
    }

    openEditModal(truckId) {
        const truck = this.trucks.find(t => t.id === truckId);
        if (!truck) return;

        // Set editing mode
        this.editingTruckId = truckId;

        // Pre-fill form with truck data
        document.getElementById('truckName').value = truck.name;
        document.getElementById('licensePlate').value = truck.licensePlate;
        document.getElementById('capacity').value = truck.capacity;

        // Select the correct radio button
        const radioButton = document.querySelector(`input[name="truckType"][value="${truck.registeredType === 'mixed' ? 'incoming' : truck.registeredType}"]`);
        if (radioButton) {
            radioButton.checked = true;
        }

        // Open modal
        this.openModal();
    }

    editTruck(truckId, name, licensePlate, capacity, type) {
        const truck = this.trucks.find(t => t.id === truckId);
        if (!truck) return;

        // Normalize license plate for comparison
        const normalizedPlate = licensePlate.toUpperCase().trim().replace(/\s+/g, '');

        // Check if license plate conflicts with another truck (excluding current truck)
        const conflictingTruck = this.trucks.find(t =>
            t.id !== truckId &&
            t.licensePlate.toUpperCase().trim().replace(/\s+/g, '') === normalizedPlate
        );

        if (conflictingTruck) {
            alert(`La patente ${licensePlate} ya está registrada en el camión "${conflictingTruck.name}".`);
            return;
        }

        // Store old values for updating movements
        const oldName = truck.name;
        const oldLicensePlate = truck.licensePlate;
        const oldCapacity = truck.capacity;

        // Update truck data
        truck.name = name.trim();
        truck.licensePlate = licensePlate.toUpperCase().trim();
        truck.capacity = parseFloat(capacity);

        // Update all movements associated with this truck
        this.movements.forEach(movement => {
            if (movement.truckId === truckId) {
                movement.truckName = truck.name;
                movement.licensePlate = truck.licensePlate;
                movement.capacity = truck.capacity;
            }
        });

        // Save changes
        this.saveTrucks();
        this.saveMovements();

        // Update UI
        this.renderTruckList();
        this.renderMovementLog();
        this.updateCounters();
        this.updateSummary();
        this.updateAnalytics();

        // Reset editing mode
        this.editingTruckId = null;
    }

    deleteMovement(movementId) {
        const movement = this.movements.find(m => m.id === movementId);
        if (!movement) return;

        // Find the truck and decrement its counter
        const truck = this.trucks.find(t => t.id === movement.truckId);
        if (truck) {
            if (movement.type === 'incoming') {
                truck.incomingCount = Math.max(0, truck.incomingCount - 1);
            } else {
                truck.outgoingCount = Math.max(0, truck.outgoingCount - 1);
            }
            this.saveTrucks();
        }

        // Remove the movement
        this.movements = this.movements.filter(m => m.id !== movementId);
        this.saveMovements();

        // Update UI
        this.renderTruckList();
        this.renderMovementLog();
        this.updateCounters();
        this.updateSummary();
        this.updateAnalytics();
    }

    selectTruckForTrip(truckId, tripType) {
        // Store selected truck and type
        this.selectedTruckId = truckId;
        this.selectedTripType = tripType;

        // Close truck selector
        this.closeTruckSelector();

        // Open material selector
        this.openMaterialSelector(tripType);
    }

    incrementTruckCounter(material) {
        const truck = this.trucks.find(t => t.id === this.selectedTruckId);
        if (truck) {
            // Increment appropriate counter
            if (this.selectedTripType === 'incoming') {
                truck.incomingCount++;
            } else {
                truck.outgoingCount++;
            }

            // Get location from input
            const location = document.getElementById('tripLocation').value.trim();

            // Create movement record
            const movement = {
                id: Date.now(),
                truckId: truck.id,
                truckName: truck.name,
                licensePlate: truck.licensePlate,
                type: this.selectedTripType,
                capacity: truck.capacity,
                timestamp: new Date().toISOString(),
                location: location || null,
                material: material || null
            };

            this.movements.push(movement);

            this.saveTrucks();
            this.saveMovements();
            this.updateCounters();
            this.updateSummary();
            this.renderTruckList();
            this.renderMovementLog();
            this.updateAnalytics();

            // Animate the counter
            this.animateCounter(this.selectedTripType);

            // Clear inputs
            document.getElementById('tripLocation').value = '';

            // Close material selector
            this.closeMaterialSelector();

            // Clear selection
            this.selectedTruckId = null;
            this.selectedTripType = null;
        }
    }

    // UI Updates
    updateCounters() {
        const incomingCount = this.movements.filter(m => m.type === 'incoming').length;
        const outgoingCount = this.movements.filter(m => m.type === 'outgoing').length;

        document.getElementById('incomingCount').textContent = incomingCount;
        document.getElementById('outgoingCount').textContent = outgoingCount;

        // Update movement tab counters
        document.getElementById('movementIncomingCount').textContent = incomingCount;
        document.getElementById('movementOutgoingCount').textContent = outgoingCount;

        // Update volume displays
        const incomingVolume = this.calculateVolume('incoming');
        const outgoingVolume = this.calculateVolume('outgoing');

        document.getElementById('incomingVolume').textContent = `${incomingVolume.toFixed(1)} m³`;
        document.getElementById('outgoingVolume').textContent = `${outgoingVolume.toFixed(1)} m³`;
    }

    calculateVolume(type) {
        return this.movements
            .filter(m => m.type === type)
            .reduce((sum, movement) => sum + movement.capacity, 0);
    }

    updateSummary() {
        const totalTrips = this.movements.length;
        const totalVolume = this.calculateVolume('incoming') + this.calculateVolume('outgoing');

        // Update both total displays
        document.getElementById('totalTrucks').textContent = this.trucks.length;
        document.getElementById('totalTrucksFooter').textContent = totalTrips;
        document.getElementById('totalVolume').textContent = `${totalVolume.toFixed(1)} m³`;
    }

    renderTruckList() {
        const listElement = document.getElementById('truckList');

        if (this.trucks.length === 0) {
            listElement.innerHTML = `
                <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                    </svg>
                    <p>No hay camiones registrados</p>
                    <p class="empty-hint">Toca el botón "NUEVO CAMIÓN" para agregar</p>
                </div>
            `;
            return;
        }

        let html = '';

        // Filter trucks by their registered type
        const incomingTrucks = this.trucks.filter(t =>
            t.registeredType === 'incoming' || t.registeredType === 'mixed'
        );
        const outgoingTrucks = this.trucks.filter(t =>
            t.registeredType === 'outgoing' || t.registeredType === 'mixed'
        );

        // Incoming Section (Green - Relleno)
        if (incomingTrucks.length > 0) {
            html += `
                <div class="truck-section-header incoming-header">
                    <span class="section-icon">📥</span>
                    <span class="section-title">Relleno</span>
                    <span class="section-count">${incomingTrucks.length}</span>
                </div>
            `;

            html += incomingTrucks.map(truck => {
                const totalCount = truck.incomingCount + truck.outgoingCount;
                const incomingVol = truck.incomingCount * truck.capacity;
                const outgoingVol = truck.outgoingCount * truck.capacity;
                const isMixed = truck.registeredType === 'mixed';

                return `
                    <div class="truck-item incoming-truck ${isMixed ? 'mixed-truck' : ''}">
                        <div class="truck-info">
                            <div class="truck-name">${truck.name}</div>
                            <div class="truck-details">
                                ${truck.licensePlate} • ${truck.capacity} m³
                            </div>
                            ${isMixed ? `
                                <div class="truck-breakdown">
                                    <span class="breakdown-incoming">📥 ${truck.incomingCount} (${incomingVol.toFixed(1)}m³)</span>
                                    <span class="breakdown-outgoing">📤 ${truck.outgoingCount} (${outgoingVol.toFixed(1)}m³)</span>
                                </div>
                            ` : `
                                <div class="truck-breakdown">
                                    <span class="breakdown-incoming">📥 ${truck.incomingCount} vueltas (${incomingVol.toFixed(1)}m³)</span>
                                </div>
                            `}
                        </div>
                        <div class="truck-count">${totalCount}</div>
                        <button class="edit-btn" onclick="truckManager.openEditModal(${truck.id})">
                            Editar
                        </button>
                        <button class="delete-btn" onclick="truckManager.showDeleteConfirmation(event, ${truck.id}, '${truck.name}')">
                            Eliminar
                        </button>
                    </div>
                `;
            }).join('');
        }

        // Outgoing Section (Orange - Excavación)
        if (outgoingTrucks.length > 0) {
            html += `
                <div class="truck-section-header outgoing-header">
                    <span class="section-icon">📤</span>
                    <span class="section-title">Excavación</span>
                    <span class="section-count">${outgoingTrucks.length}</span>
                </div>
            `;

            html += outgoingTrucks.map(truck => {
                const totalCount = truck.incomingCount + truck.outgoingCount;
                const incomingVol = truck.incomingCount * truck.capacity;
                const outgoingVol = truck.outgoingCount * truck.capacity;
                const isMixed = truck.registeredType === 'mixed';

                return `
                    <div class="truck-item outgoing-truck ${isMixed ? 'mixed-truck' : ''}">
                        <div class="truck-info">
                            <div class="truck-name">${truck.name}</div>
                            <div class="truck-details">
                                ${truck.licensePlate} • ${truck.capacity} m³
                            </div>
                            ${isMixed ? `
                                <div class="truck-breakdown">
                                    <span class="breakdown-incoming">📥 ${truck.incomingCount} (${incomingVol.toFixed(1)}m³)</span>
                                    <span class="breakdown-outgoing">📤 ${truck.outgoingCount} (${outgoingVol.toFixed(1)}m³)</span>
                                </div>
                            ` : `
                                <div class="truck-breakdown">
                                    <span class="breakdown-outgoing">📤 ${truck.outgoingCount} vueltas (${outgoingVol.toFixed(1)}m³)</span>
                                </div>
                            `}
                        </div>
                        <div class="truck-count">${totalCount}</div>
                        <button class="edit-btn" onclick="truckManager.openEditModal(${truck.id})">
                            Editar
                        </button>
                        <button class="delete-btn" onclick="truckManager.showDeleteConfirmation(event, ${truck.id}, '${truck.name}')">
                            Eliminar
                        </button>
                    </div>
                `;
            }).join('');
        }

        listElement.innerHTML = html;
    }

    // Movement Log
    renderMovementLog() {
        const logElement = document.getElementById('movementLog');

        if (this.movements.length === 0) {
            logElement.innerHTML = `
                <div class="empty-movement">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <p>No hay movimientos registrados</p>
                    <p class="empty-hint">Los movimientos aparecerán aquí cuando registres vueltas</p>
                </div>
            `;
            return;
        }

        // Sort movements by timestamp (most recent first)
        const sortedMovements = [...this.movements].sort((a, b) =>
            new Date(b.timestamp) - new Date(a.timestamp)
        );

        logElement.innerHTML = sortedMovements.map(movement => {
            const date = new Date(movement.timestamp);
            const hours = date.getHours();
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const period = hours >= 12 ? 'PM' : 'AM';
            const displayHours = hours % 12 || 12;

            const typeClass = movement.type === 'incoming' ? 'incoming-movement' : 'outgoing-movement';
            const icon = movement.type === 'incoming' ? '📥' : '📤';
            const volumeSign = movement.type === 'incoming' ? '+' : '-';

            return `
                <div class="movement-item ${typeClass}">
                    <div class="movement-time">
                        <div class="time-hour">${displayHours}:${minutes}</div>
                        <div class="time-period">${period}</div>
                    </div>
                    <div class="movement-icon">${icon}</div>
                    <div class="movement-details">
                        <div class="movement-truck">${movement.truckName}</div>
                        <div class="movement-info">${movement.licensePlate} • ${movement.capacity} m³</div>
                        ${movement.location ? `<div class="movement-location">📍 ${movement.location}</div>` : ''}
                        ${movement.material ? `<div class="movement-material">🏗️ ${movement.material}</div>` : ''}
                    </div>
                    <div class="movement-volume">
                        <div class="volume-value">${volumeSign}${movement.capacity.toFixed(1)}</div>
                        <div class="volume-label">m³</div>
                    </div>
                    <button class="delete-movement-btn" onclick="truckManager.deleteMovement(${movement.id})" title="Eliminar vuelta">
                        ✕
                    </button>
                </div>
            `;
        }).join('');
    }

    // Analytics
    updateAnalytics() {
        this.updateVolumeBalance();
        this.updateTruckPerformance();
        this.updateHourlyActivity();
        this.updateSummaryStats();
    }

    updateVolumeBalance() {
        const fillVolume = this.calculateVolume('incoming');
        const excavationVolume = this.calculateVolume('outgoing');

        document.getElementById('analyticsFillVolume').textContent = `+${fillVolume.toFixed(1)} m³`;
        document.getElementById('analyticsExcavationVolume').textContent = `-${excavationVolume.toFixed(1)} m³`;
    }

    updateTruckPerformance() {
        const performanceElement = document.getElementById('truckPerformance');

        if (this.trucks.length === 0 || this.movements.length === 0) {
            performanceElement.innerHTML = '<p class="analytics-empty">Registra vueltas para ver estadísticas</p>';
            return;
        }

        // Sort trucks by total trip count
        const sortedTrucks = [...this.trucks].sort((a, b) =>
            (b.incomingCount + b.outgoingCount) - (a.incomingCount + a.outgoingCount)
        );

        performanceElement.innerHTML = sortedTrucks.map(truck => {
            const totalTrips = truck.incomingCount + truck.outgoingCount;
            const incomingVol = truck.incomingCount * truck.capacity;
            const outgoingVol = truck.outgoingCount * truck.capacity;
            const totalVol = incomingVol + outgoingVol;

            return `
                <div class="performance-item">
                    <div class="performance-truck">${truck.name}</div>
                    <div class="performance-stats">
                        ${totalTrips} vueltas • 
                        📥 ${truck.incomingCount} (${incomingVol.toFixed(1)}m³) • 
                        📤 ${truck.outgoingCount} (${outgoingVol.toFixed(1)}m³)
                    </div>
                </div>
            `;
        }).join('');
    }

    updateHourlyActivity() {
        const activityElement = document.getElementById('hourlyActivity');

        if (this.movements.length === 0) {
            activityElement.innerHTML = '<p class="analytics-empty">Registra vueltas para ver actividad</p>';
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

    updateSummaryStats() {
        if (this.movements.length === 0) {
            document.getElementById('firstTrip').textContent = '--:--';
            document.getElementById('lastTrip').textContent = '--:--';
            document.getElementById('operatingTime').textContent = '0h 0m';
            document.getElementById('avgTripsPerHour').textContent = '0';
            return;
        }

        // Sort movements by time
        const sorted = [...this.movements].sort((a, b) =>
            new Date(a.timestamp) - new Date(b.timestamp)
        );

        const first = new Date(sorted[0].timestamp);
        const last = new Date(sorted[sorted.length - 1].timestamp);

        // Format times
        const formatTime = (date) => {
            const hours = date.getHours() % 12 || 12;
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const period = date.getHours() >= 12 ? 'PM' : 'AM';
            return `${hours}:${minutes} ${period}`;
        };

        document.getElementById('firstTrip').textContent = formatTime(first);
        document.getElementById('lastTrip').textContent = formatTime(last);

        // Calculate operating time
        const diffMs = last - first;
        const hours = Math.floor(diffMs / (1000 * 60 * 60));
        const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
        document.getElementById('operatingTime').textContent = `${hours}h ${minutes}m`;

        // Calculate average trips per hour
        const totalHours = diffMs / (1000 * 60 * 60);
        const avgTrips = totalHours > 0 ? (this.movements.length / totalHours).toFixed(1) : 0;
        document.getElementById('avgTripsPerHour').textContent = avgTrips;
    }

    animateCounter(type) {
        const element = document.getElementById(`${type}Count`);
        element.classList.add('pulse');
        setTimeout(() => {
            element.classList.remove('pulse');
        }, 300);
    }

    // Tab Navigation
    setupTabNavigation() {
        const tabBtns = document.querySelectorAll('.tab-btn');
        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const tab = btn.dataset.tab;
                this.switchTab(tab);
            });
        });
    }

    switchTab(tabName) {
        // Update buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.tab === tabName);
        });

        // Update content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.toggle('active', content.id === `tab-${tabName}`);
        });

        this.currentTab = tabName;

        // Refresh analytics when switching to analytics tab
        if (tabName === 'analisis') {
            this.updateAnalytics();
        }
    }

    // Truck Selector Modal - FILTERS BY REGISTERED TYPE
    openTruckSelector(type) {
        this.currentSelectorType = type;
        const modal = document.getElementById('truckSelectorModal');
        const title = document.getElementById('selectorTitle');
        const listElement = document.getElementById('truckSelectorList');

        // Update title
        const typeText = type === 'incoming' ? 'Relleno' : 'Excavación';
        const icon = type === 'incoming' ? '📥' : '📤';
        title.textContent = `${icon} Registrar ${typeText}`;

        // Filter trucks by registeredType
        const filteredTrucks = this.trucks.filter(t =>
            t.registeredType === type || t.registeredType === 'mixed'
        );

        if (filteredTrucks.length === 0) {
            listElement.innerHTML = `
                <div class="empty-selector">
                    <p>No hay camiones registrados para ${typeText}</p>
                    <p class="empty-hint">Agrega uno usando el botón de abajo</p>
                </div>
                <button class="add-truck-selector-btn" onclick="event.stopPropagation(); truckManager.closeTruckSelector(); truckManager.openModalWithType('${type}')">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    <span>Agregar nuevo camión</span>
                </button>
            `;
        } else {
            listElement.innerHTML = filteredTrucks.map(truck => {
                const typeCount = type === 'incoming' ? truck.incomingCount : truck.outgoingCount;
                const typeVolume = typeCount * truck.capacity;

                return `
                    <button class="truck-selector-btn" onclick="truckManager.selectTruckForTrip(${truck.id}, '${type}')">
                        <div class="selector-truck-icon">${icon}</div>
                        <div class="selector-truck-info">
                            <div class="selector-truck-name">${truck.name}</div>
                            <div class="selector-truck-details">${truck.licensePlate} • ${truck.capacity} m³</div>
                            <div class="selector-truck-stats">
                                ${typeText} hoy: ${typeCount} • Vol: ${typeVolume.toFixed(1)} m³
                            </div>
                        </div>
                        <div class="selector-truck-count">${typeCount}</div>
                    </button>
                `;
            }).join('') + `
                <button class="add-truck-selector-btn" onclick="event.stopPropagation(); truckManager.closeTruckSelector(); truckManager.openModalWithType('${type}')">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    <span>Agregar nuevo camión</span>
                </button>
            `;
        }

        modal.classList.add('active');

        // Focus location input
        setTimeout(() => {
            document.getElementById('tripLocation').focus();
        }, 100);
    }

    updateMaterialSelect(type) {
        const select = document.getElementById('tripMaterial');
        const materials = this.materials[type || this.currentSelectorType] || [];

        select.innerHTML = '<option value="">Seleccionar material (opcional)</option>' +
            materials.map(m => `<option value="${m}">${m}</option>`).join('');
    }

    closeTruckSelector() {
        document.getElementById('truckSelectorModal').classList.remove('active');
        document.getElementById('tripLocation').value = '';
        this.currentSelectorType = null;
    }

    // Material Selector Modal
    openMaterialSelector(type) {
        const modal = document.getElementById('materialSelectorModal');
        const title = document.getElementById('materialSelectorTitle');
        const listElement = document.getElementById('materialSelectorList');

        const typeText = type === 'incoming' ? 'Relleno' : 'Excavación';
        const icon = type === 'incoming' ? '📥' : '📤';
        title.textContent = `${icon} Seleccionar Material - ${typeText}`;

        const materials = this.materials[type] || [];

        listElement.innerHTML = materials.map(material => `
            <button class="truck-selector-btn" onclick="truckManager.incrementTruckCounter('${material}')">
                <div class="selector-truck-icon">🏗️</div>
                <div class="selector-truck-info">
                    <div class="selector-truck-name">${material}</div>
                </div>
            </button>
        `).join('') + `
            <button class="truck-selector-btn" onclick="truckManager.incrementTruckCounter(null)" style="opacity: 0.6;">
                <div class="selector-truck-icon">⏭️</div>
                <div class="selector-truck-info">
                    <div class="selector-truck-name">Sin material</div>
                </div>
            </button>
            <button class="add-truck-selector-btn" onclick="event.stopPropagation(); truckManager.openMaterialModal()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Agregar nuevo material</span>
            </button>
        `;

        modal.classList.add('active');
    }

    closeMaterialSelector() {
        document.getElementById('materialSelectorModal').classList.remove('active');
    }

    // Keyboard Shortcuts
    setupKeyboardShortcuts() {
        document.addEventListener('keydown', (e) => {
            // Check if any modal is open
            const truckModalOpen = document.getElementById('truckModal').classList.contains('active');
            const selectorModalOpen = document.getElementById('truckSelectorModal').classList.contains('active');
            const isTyping = e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA';

            if (isTyping && !e.ctrlKey && !e.altKey) {
                return;
            }

            const key = e.key.toLowerCase();

            // ESC to close any modal
            if (key === 'escape') {
                if (truckModalOpen) {
                    this.closeModal();
                } else if (selectorModalOpen) {
                    this.closeTruckSelector();
                } else if (document.getElementById('materialSelectorModal').classList.contains('active')) {
                    this.closeMaterialSelector();
                } else if (document.getElementById('materialModal').classList.contains('active')) {
                    this.closeMaterialModal();
                }
                e.preventDefault();
                return;
            }

            // Don't trigger other shortcuts if truck registration modal is open
            if (truckModalOpen) {
                return;
            }

            switch (key) {
                case 'e':
                    this.openTruckSelector('incoming');
                    e.preventDefault();
                    break;
                case 's':
                    this.openTruckSelector('outgoing');
                    e.preventDefault();
                    break;
                case 'n':
                    if (!selectorModalOpen) {
                        this.openModal();
                        e.preventDefault();
                    }
                    break;
            }
        });
    }

    // Material Management Modal
    openMaterialModal() {
        const modal = document.getElementById('materialModal');
        modal.classList.add('active');
        this.renderMaterialList();

        // Setup tab listeners
        document.querySelectorAll('.material-tab-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const type = btn.dataset.type;
                this.currentMaterialType = type;
                document.querySelectorAll('.material-tab-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                this.renderMaterialList();
            });
        });
    }

    closeMaterialModal() {
        document.getElementById('materialModal').classList.remove('active');
        document.getElementById('newMaterialName').value = '';
    }

    renderMaterialList() {
        const listElement = document.getElementById('materialList');
        const materials = this.materials[this.currentMaterialType] || [];

        if (materials.length === 0) {
            listElement.innerHTML = '<p class="empty-materials">No hay materiales agregados</p>';
            return;
        }

        listElement.innerHTML = materials.map(material => `
            <div class="material-item">
                <span>${material}</span>
                <button class="delete-material-btn" onclick="truckManager.deleteMaterial('${material}', '${this.currentMaterialType}')">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
        `).join('');
    }

    // Event Listeners
    attachEventListeners() {
        // Counter buttons now open selector
        document.getElementById('incomingBtn').addEventListener('click', () => {
            this.openTruckSelector('incoming');
        });

        document.getElementById('outgoingBtn').addEventListener('click', () => {
            this.openTruckSelector('outgoing');
        });

        // Selector modal controls
        document.getElementById('closeSelectorModal').addEventListener('click', () => {
            this.closeTruckSelector();
        });

        // Add truck button
        document.getElementById('addTruckBtn').addEventListener('click', () => {
            this.openModal();
        });

        // Registration modal controls
        document.getElementById('closeModal').addEventListener('click', () => {
            this.closeModal();
        });

        document.getElementById('cancelBtn').addEventListener('click', () => {
            this.closeModal();
        });

        // Form submission
        document.getElementById('truckForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleFormSubmit();
        });

        // Close modals on outside click
        document.getElementById('truckModal').addEventListener('click', (e) => {
            if (e.target.id === 'truckModal') {
                this.closeModal();
            }
        });

        document.getElementById('truckSelectorModal').addEventListener('click', (e) => {
            if (e.target.id === 'truckSelectorModal') {
                this.closeTruckSelector();
            }
        });

        // Material modal controls
        document.getElementById('closeMaterialModal').addEventListener('click', () => {
            this.closeMaterialModal();
        });

        document.getElementById('addMaterialBtn').addEventListener('click', () => {
            const input = document.getElementById('newMaterialName');
            const name = input.value.trim();
            if (name) {
                this.addMaterial(name, this.currentMaterialType);
                input.value = '';
            }
        });

        document.getElementById('newMaterialName').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                const name = e.target.value.trim();
                if (name) {
                    this.addMaterial(name, this.currentMaterialType);
                    e.target.value = '';
                }
            }
        });

        document.getElementById('materialModal').addEventListener('click', (e) => {
            if (e.target.id === 'materialModal') {
                this.closeMaterialModal();
            }
        });

        // Material selector modal controls
        document.getElementById('closeMaterialSelectorModal').addEventListener('click', () => {
            this.closeMaterialSelector();
        });

        document.getElementById('materialSelectorModal').addEventListener('click', (e) => {
            if (e.target.id === 'materialSelectorModal') {
                this.closeMaterialSelector();
            }
        });

        // Frequent trucks button and modal controls
        document.getElementById('showFrequentTrucksBtn').addEventListener('click', () => {
            this.openFrequentTrucksModal();
        });

        document.getElementById('closeFrequentTrucksModal').addEventListener('click', () => {
            this.closeFrequentTrucksModal();
        });

        document.getElementById('frequentTrucksModal').addEventListener('click', (e) => {
            if (e.target.id === 'frequentTrucksModal') {
                this.closeFrequentTrucksModal();
            }
        });
    }

    openModal() {
        document.getElementById('truckModal').classList.add('active');
        // Focus on first input
        setTimeout(() => {
            document.getElementById('truckName').focus();
        }, 100);
    }

    openModalWithType(type) {
        this.openModal();
        // Pre-select the type
        const radioButton = document.querySelector(`input[name="truckType"][value="${type}"]`);
        if (radioButton) {
            radioButton.checked = true;
        }
    }

    closeModal() {
        document.getElementById('truckModal').classList.remove('active');
        document.getElementById('truckForm').reset();
        this.editingTruckId = null; // Reset edit mode
    }

    // Frequent Trucks Modal
    openFrequentTrucksModal() {
        this.renderFrequentTrucksList();
        document.getElementById('frequentTrucksModal').classList.add('active');
    }

    closeFrequentTrucksModal() {
        document.getElementById('frequentTrucksModal').classList.remove('active');
    }

    renderFrequentTrucksList() {
        const frequentTrucks = this.getFrequentTrucks();
        const listElement = document.getElementById('frequentTrucksList');

        if (frequentTrucks.length === 0) {
            listElement.innerHTML = `
                <div class="empty-selector">
                    <p>No hay camiones frecuentes aún</p>
                    <p class="empty-hint">Los camiones que agregues aparecerán aquí para acceso rápido</p>
                </div>
            `;
            return;
        }

        listElement.innerHTML = frequentTrucks.map(truck => `
            <div class="truck-selector-item" onclick="truckManager.addFromFrequent('${truck.licensePlate}')">
                <div class="truck-selector-info">
                    <div class="truck-selector-name">${truck.name}</div>
                    <div class="truck-selector-details">
                        <span class="truck-selector-plate">${truck.licensePlate}</span>
                        <span class="truck-selector-capacity">${truck.capacity} m³</span>
                        <span class="truck-selector-usage" style="color: var(--text-muted); font-size: 11px;">
                            ⚡ ${truck.usageCount} ${truck.usageCount === 1 ? 'vez' : 'veces'}
                        </span>
                    </div>
                </div>
                <div class="truck-selector-arrow">→</div>
            </div>
        `).join('');
    }

    addFromFrequent(licensePlate) {
        const frequentTrucks = this.getFrequentTrucks();
        const truck = frequentTrucks.find(t =>
            t.licensePlate.toUpperCase().trim().replace(/\s+/g, '') ===
            licensePlate.toUpperCase().trim().replace(/\s+/g, '')
        );

        if (!truck) return;

        // Check if truck already exists in current day
        const existingTruck = this.trucks.find(t =>
            t.licensePlate.toUpperCase().trim().replace(/\s+/g, '') ===
            truck.licensePlate.toUpperCase().trim().replace(/\s+/g, '')
        );

        if (existingTruck) {
            alert(`El camión ${truck.name} (${truck.licensePlate}) ya está en la nómina de hoy.`);
            this.closeFrequentTrucksModal();
            return;
        }

        // Close frequent trucks modal
        this.closeFrequentTrucksModal();

        // Pre-fill the form with truck data
        document.getElementById('truckName').value = truck.name;
        document.getElementById('licensePlate').value = truck.licensePlate;
        document.getElementById('capacity').value = truck.capacity;

        // Open the registration modal
        this.openModal();
    }

    handleFormSubmit() {
        const name = document.getElementById('truckName').value.trim();
        const licensePlate = document.getElementById('licensePlate').value.trim().toUpperCase();
        const capacity = document.getElementById('capacity').value;
        const type = document.querySelector('input[name="truckType"]:checked')?.value;

        if (name && licensePlate && capacity && type) {
            if (this.editingTruckId) {
                // Edit mode
                this.editTruck(this.editingTruckId, name, licensePlate, capacity, type);
            } else {
                // Create mode
                this.addTruck(name, licensePlate, capacity, type);
            }
            this.closeModal();
        }
    }

    // PDF Report Generation - Professional Version with Tables
    generatePDFReport() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        const today = new Date();
        const dateStr = today.toLocaleDateString('es-ES', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
        });
        const timeStr = today.toLocaleTimeString('es-ES');

        // Colors
        const primaryColor = [16, 185, 129]; // Green
        const secondaryColor = [245, 158, 11]; // Orange
        const accentColor = [59, 130, 246]; // Blue

        // Header with background
        doc.setFillColor(...primaryColor);
        doc.rect(0, 0, 210, 45, 'F');

        doc.setTextColor(255, 255, 255);
        doc.setFontSize(24);
        doc.setFont(undefined, 'bold');
        doc.text('Reporte Diario de Camiones', 105, 20, { align: 'center' });

        doc.setFontSize(12);
        doc.setFont(undefined, 'normal');
        doc.text(dateStr, 105, 30, { align: 'center' });
        doc.text(`Generado: ${timeStr}`, 105, 37, { align: 'center' });

        doc.setTextColor(0, 0, 0);
        let yPos = 55;

        // Summary Section with Table
        const fillVolume = this.calculateVolume('incoming');
        const excavationVolume = this.calculateVolume('outgoing');
        const netVolume = fillVolume - excavationVolume;
        const incomingCount = this.movements.filter(m => m.type === 'incoming').length;
        const outgoingCount = this.movements.filter(m => m.type === 'outgoing').length;

        doc.setFontSize(14);
        doc.setFont(undefined, 'bold');
        doc.setTextColor(...accentColor);
        doc.text('📊 Resumen del Día', 14, yPos);
        yPos += 2;

        doc.autoTable({
            startY: yPos,
            head: [['Concepto', 'Valor']],
            body: [
                ['Total Camiones Registrados', this.trucks.length.toString()],
                ['Total Vueltas', `${this.movements.length} (↓${incomingCount} / ↑${outgoingCount})`],
                ['Volumen Relleno', `+${fillVolume.toFixed(1)} m³`],
                ['Volumen Excavación', `-${excavationVolume.toFixed(1)} m³`]
            ],
            theme: 'striped',
            headStyles: {
                fillColor: primaryColor,
                fontSize: 11,
                fontStyle: 'bold'
            },
            bodyStyles: {
                fontSize: 10
            },
            columnStyles: {
                0: { fontStyle: 'bold', cellWidth: 80 },
                1: { halign: 'right', cellWidth: 'auto' }
            },
            margin: { left: 14, right: 14 }
        });

        yPos = doc.lastAutoTable.finalY + 15;

        // Truck Performance Table
        if (this.trucks.length > 0) {
            doc.setFontSize(14);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(...accentColor);
            doc.text('🚛 Rendimiento por Camión', 14, yPos);
            yPos += 2;

            const truckData = this.trucks.map(truck => {
                const totalTrips = truck.incomingCount + truck.outgoingCount;
                const incomingVol = truck.incomingCount * truck.capacity;
                const outgoingVol = truck.outgoingCount * truck.capacity;
                const totalVol = incomingVol + outgoingVol;

                return [
                    truck.name,
                    truck.licensePlate,
                    `${truck.capacity} m³`,
                    totalTrips.toString(),
                    `${truck.incomingCount} (${incomingVol.toFixed(1)}m³)`,
                    `${truck.outgoingCount} (${outgoingVol.toFixed(1)}m³)`,
                    `${totalVol.toFixed(1)} m³`
                ];
            });

            doc.autoTable({
                startY: yPos,
                head: [['Camión', 'Patente', 'Capacidad', 'Vueltas', 'Relleno', 'Excavación', 'Vol. Total']],
                body: truckData,
                theme: 'grid',
                headStyles: {
                    fillColor: secondaryColor,
                    fontSize: 9,
                    fontStyle: 'bold'
                },
                bodyStyles: {
                    fontSize: 8
                },
                columnStyles: {
                    0: { cellWidth: 35 },
                    1: { cellWidth: 25 },
                    2: { cellWidth: 22, halign: 'center' },
                    3: { cellWidth: 18, halign: 'center' },
                    4: { cellWidth: 30, halign: 'right' },
                    5: { cellWidth: 30, halign: 'right' },
                    6: { cellWidth: 25, halign: 'right', fontStyle: 'bold' }
                },
                margin: { left: 14, right: 14 }
            });

            yPos = doc.lastAutoTable.finalY + 15;
        }

        // Movements Log Table
        if (this.movements.length > 0) {
            // Check if we need a new page
            if (yPos > 200) {
                doc.addPage();
                yPos = 20;
            }

            doc.setFontSize(14);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(...accentColor);
            doc.text('📋 Registro de Movimientos', 14, yPos);
            yPos += 2;

            const sortedMovements = [...this.movements].sort((a, b) =>
                new Date(a.timestamp) - new Date(b.timestamp)
            );

            const movementData = sortedMovements.map(movement => {
                const date = new Date(movement.timestamp);
                const hours = date.getHours();
                const minutes = date.getMinutes().toString().padStart(2, '0');
                const period = hours >= 12 ? 'PM' : 'AM';
                const displayHours = hours % 12 || 12;
                const timeStr = `${displayHours}:${minutes} ${period}`;

                const typeIcon = movement.type === 'incoming' ? '↓' : '↑';
                const typeText = movement.type === 'incoming' ? 'Relleno' : 'Excavación';
                const volumeSign = movement.type === 'incoming' ? '+' : '-';

                return [
                    timeStr,
                    `${typeIcon} ${typeText}`,
                    movement.truckName,
                    movement.licensePlate,
                    `${volumeSign}${movement.capacity.toFixed(1)} m³`,
                    movement.material || '-',
                    movement.location || '-'
                ];
            });

            doc.autoTable({
                startY: yPos,
                head: [['Hora', 'Tipo', 'Camión', 'Patente', 'Volumen', 'Material', 'Ubicación']],
                body: movementData,
                theme: 'striped',
                headStyles: {
                    fillColor: accentColor,
                    fontSize: 8,
                    fontStyle: 'bold'
                },
                bodyStyles: {
                    fontSize: 7
                },
                columnStyles: {
                    0: { cellWidth: 20, halign: 'center' },
                    1: { cellWidth: 25 },
                    2: { cellWidth: 30 },
                    3: { cellWidth: 22 },
                    4: { cellWidth: 22, halign: 'right', fontStyle: 'bold' },
                    5: { cellWidth: 28 },
                    6: { cellWidth: 28 }
                },
                margin: { left: 14, right: 14 },
                didParseCell: function (data) {
                    // Color code by type
                    if (data.section === 'body' && data.column.index === 1) {
                        if (data.cell.raw.includes('Relleno')) {
                            data.cell.styles.textColor = primaryColor;
                            data.cell.styles.fontStyle = 'bold';
                        } else {
                            data.cell.styles.textColor = secondaryColor;
                            data.cell.styles.fontStyle = 'bold';
                        }
                    }
                }
            });
        }

        // Footer on all pages
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setFont(undefined, 'italic');
            doc.setTextColor(128, 128, 128);
            doc.text(`Página ${i} de ${pageCount}`, 105, 287, { align: 'center' });
            doc.text('Sistema de Conteo de Camiones', 14, 287);
        }

        // Download PDF
        const filename = `Reporte_${today.getFullYear()}-${(today.getMonth() + 1).toString().padStart(2, '0')}-${today.getDate().toString().padStart(2, '0')}.pdf`;
        doc.save(filename);
    }
}

// Initialize the application
let truckManager;

document.addEventListener('DOMContentLoaded', () => {
    truckManager = new TruckManager();
});

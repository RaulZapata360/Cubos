// ============================================
// LOCATIONS MANAGER - Google Maps Integration
// ============================================
// Manages origins and destinations with Google Maps

import { supabaseClient } from './supabase-client.js';

class LocationsManager {
    constructor() {
        this.map = null;
        this.marker = null;
        this.geocoder = null;
        this.currentLocation = null; // { id, type: 'origen'|'destino', nombre }
    }

    /**
     * Load and render origins in admin panel
     */
    async loadOrigenes() {
        try {
            const obraId = window.currentObraId;
            if (!obraId) {
                console.warn('No obra selected');
                return;
            }

            const { data, error } = await supabaseClient
                .from('origenes')
                .select('*')
                .eq('obra_id', obraId)
                .is('deleted_at', null)
                .order('nombre');

            if (error) throw error;

            const container = document.getElementById('adminOriginsList');

            if (!data || data.length === 0) {
                container.innerHTML = `
                    <div class="text-center py-6 bg-white/5 rounded-xl border border-white/10">
                        <span class="material-symbols-outlined text-3xl text-text-muted opacity-30">location_off</span>
                        <p class="text-xs text-text-muted mt-2">No hay orígenes configurados</p>
                    </div>
                `;
                return;
            }

            container.innerHTML = data.map(origen => `
                <div class="flex items-center justify-between p-3 bg-white/5 rounded-xl border border-white/10 hover:border-success/30 transition-all">
                    <div class="flex-1">
                        <p class="text-sm font-bold text-main">${origen.nombre}</p>
                        ${origen.direccion ? `
                            <p class="text-xs text-text-muted mt-1 flex items-center gap-1">
                                <span class="material-symbols-outlined text-[12px]">location_on</span>
                                ${origen.direccion}
                            </p>
                        ` : `
                            <p class="text-xs text-warning mt-1">⚠️ Sin dirección configurada</p>
                        `}
                    </div>
                    <button onclick="window.locationsManager.openEditLocation('${origen.id}', 'origen', '${origen.nombre.replace(/'/g, "\\'")}')"
                        class="ml-3 px-3 py-2 bg-primary/20 text-primary border border-primary/30 rounded-lg text-xs font-bold hover:bg-primary/30 transition-all flex items-center gap-1">
                        <span class="material-symbols-outlined text-sm">edit_location</span>
                        Editar
                    </button>
                </div>
            `).join('');

        } catch (error) {
            console.error('Error loading origenes:', error);
            document.getElementById('adminOriginsList').innerHTML = `
                <div class="text-center py-6 bg-danger/10 rounded-xl border border-danger/30">
                    <p class="text-xs text-danger">Error al cargar orígenes</p>
                </div>
            `;
        }
    }

    /**
     * Load and render destinations in admin panel
     */
    async loadDestinos() {
        try {
            const obraId = window.currentObraId;
            if (!obraId) {
                console.warn('No obra selected');
                return;
            }

            const { data, error } = await supabaseClient
                .from('destinos')
                .select('*')
                .eq('obra_id', obraId)
                .is('deleted_at', null)
                .order('nombre');

            if (error) throw error;

            const container = document.getElementById('adminDestinosList');

            if (!data || data.length === 0) {
                container.innerHTML = `
                    <div class="text-center py-6 bg-white/5 rounded-xl border border-white/10">
                        <span class="material-symbols-outlined text-3xl text-text-muted opacity-30">location_off</span>
                        <p class="text-xs text-text-muted mt-2">No hay destinos configurados</p>
                    </div>
                `;
                return;
            }

            container.innerHTML = data.map(destino => `
                <div class="flex items-center justify-between p-3 bg-white/5 rounded-xl border border-white/10 hover:border-warning/30 transition-all">
                    <div class="flex-1">
                        <p class="text-sm font-bold text-main">${destino.nombre}</p>
                        ${destino.direccion ? `
                            <p class="text-xs text-text-muted mt-1 flex items-center gap-1">
                                <span class="material-symbols-outlined text-[12px]">location_on</span>
                                ${destino.direccion}
                            </p>
                        ` : `
                            <p class="text-xs text-warning mt-1">⚠️ Sin dirección configurada</p>
                        `}
                    </div>
                    <button onclick="window.locationsManager.openEditLocation('${destino.id}', 'destino', '${destino.nombre.replace(/'/g, "\\'")}')"
                        class="ml-3 px-3 py-2 bg-primary/20 text-primary border border-primary/30 rounded-lg text-xs font-bold hover:bg-primary/30 transition-all flex items-center gap-1">
                        <span class="material-symbols-outlined text-sm">edit_location</span>
                        Editar
                    </button>
                </div>
            `).join('');

        } catch (error) {
            console.error('Error loading destinos:', error);
            document.getElementById('adminDestinosList').innerHTML = `
                <div class="text-center py-6 bg-danger/10 rounded-xl border border-danger/30">
                    <p class="text-xs text-danger">Error al cargar destinos</p>
                </div>
            `;
        }
    }

    /**
     * Open edit location modal
     */
    async openEditLocation(id, type, nombre) {
        this.currentLocation = { id, type, nombre };

        // Update modal title
        document.getElementById('editLocationTitle').textContent = `Editar Ubicación: ${nombre}`;
        document.getElementById('editLocationSubtitle').textContent =
            type === 'origen' ? 'Origen / Árido' : 'Destino / Botadero';

        // Load current location data
        const table = type === 'origen' ? 'origenes' : 'destinos';
        const { data, error } = await supabaseClient
            .from(table)
            .select('*')
            .eq('id', id)
            .single();

        if (error) {
            console.error('Error loading location:', error);
            return;
        }

        // Populate form
        document.getElementById('locationAddress').value = data.direccion || '';
        document.getElementById('locationLatitude').value = data.latitud || '';
        document.getElementById('locationLongitude').value = data.longitud || '';

        // Show modal
        document.getElementById('editLocationModal').classList.remove('hidden');

        // Initialize map
        setTimeout(() => this.initializeMap(data.latitud, data.longitud), 300);
    }

    /**
     * Initialize Google Maps
     */
    initializeMap(lat, lng) {
        const mapContainer = document.getElementById('locationMap');

        // Default to Santiago, Chile if no coordinates
        const center = {
            lat: lat ? parseFloat(lat) : -33.4489,
            lng: lng ? parseFloat(lng) : -70.6693
        };

        // Create map
        this.map = new google.maps.Map(mapContainer, {
            center: center,
            zoom: lat && lng ? 15 : 11,
            mapTypeControl: true,
            streetViewControl: false,
            fullscreenControl: false,
            styles: [
                { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
                { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
                { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] }
            ]
        });

        // Create marker
        this.marker = new google.maps.Marker({
            position: center,
            map: this.map,
            draggable: true,
            animation: google.maps.Animation.DROP
        });

        // Initialize geocoder
        this.geocoder = new google.maps.Geocoder();

        // Listen for marker drag
        this.marker.addListener('dragend', () => {
            const position = this.marker.getPosition();
            this.updateCoordinates(position.lat(), position.lng());
            this.reverseGeocode(position.lat(), position.lng());
        });

        // Listen for map click
        this.map.addListener('click', (event) => {
            const lat = event.latLng.lat();
            const lng = event.latLng.lng();
            this.marker.setPosition(event.latLng);
            this.updateCoordinates(lat, lng);
            this.reverseGeocode(lat, lng);
        });

        // Listen for address input
        const addressInput = document.getElementById('locationAddress');
        addressInput.addEventListener('blur', () => {
            const address = addressInput.value.trim();
            if (address) {
                this.geocodeAddress(address);
            }
        });
    }

    /**
     * Update coordinates display
     */
    updateCoordinates(lat, lng) {
        document.getElementById('locationLatitude').value = lat.toFixed(8);
        document.getElementById('locationLongitude').value = lng.toFixed(8);
    }

    /**
     * Geocode address to coordinates
     */
    geocodeAddress(address) {
        this.geocoder.geocode({ address: address }, (results, status) => {
            if (status === 'OK') {
                const location = results[0].geometry.location;
                this.map.setCenter(location);
                this.map.setZoom(15);
                this.marker.setPosition(location);
                this.updateCoordinates(location.lat(), location.lng());
            } else {
                alert('No se pudo encontrar la dirección. Por favor, verifica e intenta nuevamente.');
            }
        });
    }

    /**
     * Reverse geocode coordinates to address
     */
    reverseGeocode(lat, lng) {
        this.geocoder.geocode({ location: { lat, lng } }, (results, status) => {
            if (status === 'OK' && results[0]) {
                document.getElementById('locationAddress').value = results[0].formatted_address;
            }
        });
    }

    /**
     * Save location
     */
    async saveLocation() {
        const address = document.getElementById('locationAddress').value.trim();
        const lat = document.getElementById('locationLatitude').value;
        const lng = document.getElementById('locationLongitude').value;

        if (!address) {
            alert('Por favor, ingresa una dirección');
            return;
        }

        if (!lat || !lng) {
            alert('Por favor, selecciona una ubicación en el mapa');
            return;
        }

        try {
            const table = this.currentLocation.type === 'origen' ? 'origenes' : 'destinos';

            const { error } = await supabaseClient
                .from(table)
                .update({
                    direccion: address,
                    latitud: parseFloat(lat),
                    longitud: parseFloat(lng)
                })
                .eq('id', this.currentLocation.id);

            if (error) throw error;

            // Close modal
            this.closeEditLocation();

            // Reload lists
            await this.loadOrigenes();
            await this.loadDestinos();

            // Show success message
            alert('✅ Ubicación guardada correctamente');

        } catch (error) {
            console.error('Error saving location:', error);
            alert('❌ Error al guardar la ubicación');
        }
    }

    /**
     * Close edit location modal
     */
    closeEditLocation() {
        document.getElementById('editLocationModal').classList.add('hidden');
        this.currentLocation = null;
        this.map = null;
        this.marker = null;
    }
}

// Export singleton instance
export const locationsManager = new LocationsManager();

// Make it globally available
window.locationsManager = locationsManager;

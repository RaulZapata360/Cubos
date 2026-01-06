# 🔌 Plan de Implementación: Modo Offline Completo con Sincronización Diferida

## 📋 Resumen Ejecutivo

**Objetivo:** Permitir que los contadores registren vueltas sin conexión a internet y sincronicen automáticamente cuando se recupere la conectividad.

**Prioridad:** 🔴 CRÍTICA  
**Tiempo Estimado:** 2-3 semanas  
**Complejidad:** Alta  
**Impacto en Usuarios:** Muy Alto (elimina pérdida de datos)

---

## 🎯 Objetivos Específicos

### Funcionales
- ✅ Registrar movimientos sin conexión
- ✅ Almacenar datos localmente en IndexedDB
- ✅ Sincronizar automáticamente al recuperar conexión
- ✅ Indicador visual del estado de conexión
- ✅ Cola de sincronización con reintentos automáticos
- ✅ Resolución de conflictos (si dos usuarios editan lo mismo)

### No Funcionales
- ✅ Capacidad de almacenar hasta 1000 movimientos offline
- ✅ Sincronización en segundo plano (Service Worker)
- ✅ Tiempo de sincronización < 5 segundos para 100 registros
- ✅ Feedback visual en tiempo real del progreso

---

## 🏗️ Arquitectura Propuesta

### Componentes Nuevos

```
┌─────────────────────────────────────────┐
│         Frontend (index.html)           │
│  ┌────────────────────────────────┐     │
│  │ OfflineManager                 │     │
│  │ - detectConnectionStatus()     │     │
│  │ - queueOperation()             │     │
│  │ - syncPendingOperations()      │     │
│  └────────────────────────────────┘     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      IndexedDB (Local Storage)          │
│  ┌────────────────────────────────┐     │
│  │ pending_movements              │     │
│  │ - id (auto-increment)          │     │
│  │ - operation_type (INSERT)      │     │
│  │ - data (JSON)                  │     │
│  │ - timestamp                    │     │
│  │ - retry_count                  │     │
│  │ - status (pending/synced/error)│     │
│  └────────────────────────────────┘     │
│  ┌────────────────────────────────┐     │
│  │ cached_data                    │     │
│  │ - trucks, materials, etc.      │     │
│  └────────────────────────────────┘     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      Service Worker (sw.js)             │
│  - Background Sync API                  │
│  - Periodic Sync (cada 5 min)           │
│  - Retry Logic con Exponential Backoff  │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Supabase Backend                │
│  - Recibe batch de operaciones          │
│  - Valida y ejecuta transacciones       │
│  - Retorna conflictos si existen        │
└─────────────────────────────────────────┘
```

---

## 📝 Plan de Implementación Detallado

### FASE 1: Infraestructura Base (Semana 1)

#### Tarea 1.1: Crear IndexedDB Manager
**Archivo:** `WEB/offline-db.js`

```javascript
// offline-db.js
class OfflineDB {
    constructor() {
        this.dbName = 'CubosOfflineDB';
        this.version = 1;
        this.db = null;
    }

    async init() {
        return new Promise((resolve, reject) => {
            const request = indexedDB.open(this.dbName, this.version);
            
            request.onerror = () => reject(request.error);
            request.onsuccess = () => {
                this.db = request.result;
                resolve(this.db);
            };
            
            request.onupgradeneeded = (event) => {
                const db = event.target.result;
                
                // Store para operaciones pendientes
                if (!db.objectStoreNames.contains('pending_operations')) {
                    const store = db.createObjectStore('pending_operations', { 
                        keyPath: 'id', 
                        autoIncrement: true 
                    });
                    store.createIndex('timestamp', 'timestamp', { unique: false });
                    store.createIndex('status', 'status', { unique: false });
                }
                
                // Store para datos cacheados
                if (!db.objectStoreNames.contains('cached_data')) {
                    db.createObjectStore('cached_data', { keyPath: 'key' });
                }
            };
        });
    }

    async addPendingOperation(operation) {
        const tx = this.db.transaction(['pending_operations'], 'readwrite');
        const store = tx.objectStore('pending_operations');
        
        const operationData = {
            type: operation.type, // 'INSERT_MOVEMENT', 'UPDATE_TRUCK', etc.
            data: operation.data,
            timestamp: new Date().toISOString(),
            retry_count: 0,
            status: 'pending',
            error: null
        };
        
        return new Promise((resolve, reject) => {
            const request = store.add(operationData);
            request.onsuccess = () => resolve(request.result);
            request.onerror = () => reject(request.error);
        });
    }

    async getPendingOperations() {
        const tx = this.db.transaction(['pending_operations'], 'readonly');
        const store = tx.objectStore('pending_operations');
        const index = store.index('status');
        
        return new Promise((resolve, reject) => {
            const request = index.getAll('pending');
            request.onsuccess = () => resolve(request.result);
            request.onerror = () => reject(request.error);
        });
    }

    async markOperationSynced(id) {
        const tx = this.db.transaction(['pending_operations'], 'readwrite');
        const store = tx.objectStore('pending_operations');
        
        return new Promise((resolve, reject) => {
            const getRequest = store.get(id);
            getRequest.onsuccess = () => {
                const operation = getRequest.result;
                operation.status = 'synced';
                operation.synced_at = new Date().toISOString();
                
                const updateRequest = store.put(operation);
                updateRequest.onsuccess = () => resolve();
                updateRequest.onerror = () => reject(updateRequest.error);
            };
        });
    }

    async markOperationFailed(id, error) {
        const tx = this.db.transaction(['pending_operations'], 'readwrite');
        const store = tx.objectStore('pending_operations');
        
        return new Promise((resolve, reject) => {
            const getRequest = store.get(id);
            getRequest.onsuccess = () => {
                const operation = getRequest.result;
                operation.retry_count += 1;
                operation.error = error;
                operation.status = operation.retry_count >= 5 ? 'failed' : 'pending';
                
                const updateRequest = store.put(operation);
                updateRequest.onsuccess = () => resolve();
                updateRequest.onerror = () => reject(updateRequest.error);
            };
        });
    }

    async cacheData(key, data, ttl = 3600000) { // TTL en ms (default 1 hora)
        const tx = this.db.transaction(['cached_data'], 'readwrite');
        const store = tx.objectStore('cached_data');
        
        const cacheEntry = {
            key,
            data,
            timestamp: Date.now(),
            ttl
        };
        
        return new Promise((resolve, reject) => {
            const request = store.put(cacheEntry);
            request.onsuccess = () => resolve();
            request.onerror = () => reject(request.error);
        });
    }

    async getCachedData(key) {
        const tx = this.db.transaction(['cached_data'], 'readonly');
        const store = tx.objectStore('cached_data');
        
        return new Promise((resolve, reject) => {
            const request = store.get(key);
            request.onsuccess = () => {
                const result = request.result;
                if (!result) {
                    resolve(null);
                    return;
                }
                
                const isExpired = (Date.now() - result.timestamp) > result.ttl;
                resolve(isExpired ? null : result.data);
            };
            request.onerror = () => reject(request.error);
        });
    }
}

export const offlineDB = new OfflineDB();
```

**Criterio de Aceptación:**
- ✅ IndexedDB se inicializa correctamente
- ✅ Se pueden agregar operaciones pendientes
- ✅ Se pueden recuperar operaciones pendientes
- ✅ Se pueden marcar operaciones como sincronizadas

---

#### Tarea 1.2: Crear Offline Manager
**Archivo:** `WEB/offline-manager.js`

```javascript
// offline-manager.js
import { offlineDB } from './offline-db.js';
import { supabaseClient } from './supabase-client.js';

class OfflineManager {
    constructor() {
        this.isOnline = navigator.onLine;
        this.syncInProgress = false;
        this.listeners = [];
        this.setupEventListeners();
    }

    setupEventListeners() {
        window.addEventListener('online', () => {
            console.log('🟢 Conexión restaurada');
            this.isOnline = true;
            this.notifyListeners('online');
            this.syncPendingOperations();
        });

        window.addEventListener('offline', () => {
            console.log('🔴 Conexión perdida');
            this.isOnline = false;
            this.notifyListeners('offline');
        });
    }

    onConnectionChange(callback) {
        this.listeners.push(callback);
    }

    notifyListeners(status) {
        this.listeners.forEach(cb => cb(status));
    }

    async queueOperation(type, data) {
        console.log(`📥 Encolando operación: ${type}`, data);
        
        try {
            const id = await offlineDB.addPendingOperation({ type, data });
            console.log(`✅ Operación encolada con ID: ${id}`);
            
            // Si estamos online, intentar sincronizar inmediatamente
            if (this.isOnline) {
                setTimeout(() => this.syncPendingOperations(), 100);
            }
            
            return { success: true, id, queued: true };
        } catch (error) {
            console.error('❌ Error al encolar operación:', error);
            return { success: false, error: error.message };
        }
    }

    async syncPendingOperations() {
        if (this.syncInProgress) {
            console.log('⏳ Sincronización ya en progreso...');
            return;
        }

        if (!this.isOnline) {
            console.log('🔴 Sin conexión, sincronización cancelada');
            return;
        }

        this.syncInProgress = true;
        console.log('🔄 Iniciando sincronización...');

        try {
            const pending = await offlineDB.getPendingOperations();
            console.log(`📊 Operaciones pendientes: ${pending.length}`);

            if (pending.length === 0) {
                this.syncInProgress = false;
                return;
            }

            // Mostrar indicador de sincronización
            this.showSyncIndicator(pending.length);

            let synced = 0;
            let failed = 0;

            for (const operation of pending) {
                try {
                    await this.executeOperation(operation);
                    await offlineDB.markOperationSynced(operation.id);
                    synced++;
                    this.updateSyncProgress(synced, pending.length);
                } catch (error) {
                    console.error(`❌ Error sincronizando operación ${operation.id}:`, error);
                    await offlineDB.markOperationFailed(operation.id, error.message);
                    failed++;
                }
            }

            console.log(`✅ Sincronización completa: ${synced} exitosas, ${failed} fallidas`);
            this.hideSyncIndicator();
            
            if (synced > 0) {
                this.showSuccessNotification(`${synced} operaciones sincronizadas`);
            }

        } catch (error) {
            console.error('❌ Error en sincronización:', error);
        } finally {
            this.syncInProgress = false;
        }
    }

    async executeOperation(operation) {
        switch (operation.type) {
            case 'INSERT_MOVEMENT':
                return await this.insertMovement(operation.data);
            
            case 'INSERT_TRUCK':
                return await this.insertTruck(operation.data);
            
            case 'UPDATE_TRUCK':
                return await this.updateTruck(operation.data);
            
            case 'DELETE_TRUCK':
                return await this.deleteTruck(operation.data);
            
            default:
                throw new Error(`Tipo de operación desconocido: ${operation.type}`);
        }
    }

    async insertMovement(data) {
        const { error } = await supabaseClient
            .from('movimientos')
            .insert([data]);
        
        if (error) throw error;
    }

    async insertTruck(data) {
        const { error } = await supabaseClient
            .from('camiones')
            .insert([data]);
        
        if (error) throw error;
    }

    async updateTruck(data) {
        const { id, ...updates } = data;
        const { error } = await supabaseClient
            .from('camiones')
            .update(updates)
            .eq('id', id);
        
        if (error) throw error;
    }

    async deleteTruck(data) {
        const { error } = await supabaseClient
            .from('camiones')
            .update({ nomina_fecha: null })
            .eq('id', data.id);
        
        if (error) throw error;
    }

    showSyncIndicator(total) {
        const indicator = document.getElementById('syncIndicator');
        if (indicator) {
            indicator.classList.remove('hidden');
            indicator.querySelector('.sync-total').textContent = total;
            indicator.querySelector('.sync-current').textContent = '0';
        }
    }

    updateSyncProgress(current, total) {
        const indicator = document.getElementById('syncIndicator');
        if (indicator) {
            indicator.querySelector('.sync-current').textContent = current;
            const percentage = (current / total) * 100;
            indicator.querySelector('.sync-progress-bar').style.width = `${percentage}%`;
        }
    }

    hideSyncIndicator() {
        const indicator = document.getElementById('syncIndicator');
        if (indicator) {
            setTimeout(() => {
                indicator.classList.add('hidden');
            }, 2000);
        }
    }

    showSuccessNotification(message) {
        // Usar el sistema de notificaciones existente
        const toast = document.createElement('div');
        toast.className = 'fixed top-4 right-4 bg-emerald-500 text-white px-4 py-2 rounded-lg shadow-lg z-50 animate-in fade-in slide-in-from-top';
        toast.textContent = `✅ ${message}`;
        document.body.appendChild(toast);
        
        setTimeout(() => {
            toast.classList.add('animate-out', 'fade-out', 'slide-out-to-top');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    async getPendingCount() {
        const pending = await offlineDB.getPendingOperations();
        return pending.length;
    }
}

export const offlineManager = new OfflineManager();
```

**Criterio de Aceptación:**
- ✅ Detecta cambios de conexión
- ✅ Encola operaciones correctamente
- ✅ Sincroniza operaciones al recuperar conexión
- ✅ Muestra progreso de sincronización

---

### FASE 2: Integración con UI (Semana 2)

#### Tarea 2.1: Modificar index.html para usar Offline Manager

**Cambios en `index.html`:**

```javascript
// Al inicio del script module
import { offlineManager } from './offline-manager.js';
import { offlineDB } from './offline-db.js';

// Inicializar IndexedDB
await offlineDB.init();

// Modificar función registerMovement
async function registerMovement(camionId, tipo, capacidad, material, destino, ubicacion) {
    const movementData = {
        obra_id: currentObraId,
        camion_id: camionId,
        tipo: tipo,
        material: material,
        capacidad: parseFloat(capacidad),
        origen: tipo === 'incoming' ? destino : null,
        destino: tipo === 'outgoing' ? destino : null,
        ubicacion: ubicacion || null,
        fecha: getTargetDate().toISOString().split('T')[0],
        timestamp: new Date().toISOString(),
        registrado_por: window.currentSession?.user?.id
    };

    try {
        // Intentar insertar directamente si hay conexión
        if (offlineManager.isOnline) {
            const { data, error } = await supabaseClient
                .from('movimientos')
                .insert([movementData])
                .select();

            if (error) {
                // Si falla, encolar para sincronización
                console.warn('Error al insertar, encolando...', error);
                await offlineManager.queueOperation('INSERT_MOVEMENT', movementData);
                showOfflineNotification('Vuelta guardada localmente. Se sincronizará cuando haya conexión.');
            } else {
                console.log('✅ Movimiento registrado online');
            }
        } else {
            // Sin conexión, encolar directamente
            await offlineManager.queueOperation('INSERT_MOVEMENT', movementData);
            showOfflineNotification('Sin conexión. Vuelta guardada localmente.');
        }

        // Actualizar UI local inmediatamente
        movements.unshift(movementData);
        renderMovementLog();
        updateSummary();

        // Actualizar contador del camión
        const truck = trucks.find(t => t.id === camionId);
        if (truck) {
            if (tipo === 'incoming') truck.contador_entrante++;
            else truck.contador_saliente++;
            renderTruckList();
        }

        return { success: true };

    } catch (error) {
        console.error('Error crítico:', error);
        return { success: false, error: error.message };
    }
}
```

#### Tarea 2.2: Agregar Indicadores Visuales

**HTML para agregar en index.html (antes del closing body):**

```html
<!-- Connection Status Indicator -->
<div id="connectionStatus" class="fixed top-2 left-1/2 transform -translate-x-1/2 z-50 transition-all duration-300">
    <div class="flex items-center gap-2 px-3 py-1.5 rounded-full glass-card border border-border text-xs font-bold">
        <div id="statusDot" class="w-2 h-2 rounded-full bg-emerald-500"></div>
        <span id="statusText">En línea</span>
        <span id="pendingCount" class="hidden ml-2 px-2 py-0.5 bg-warning/20 text-warning rounded-full text-[10px]">
            0 pendientes
        </span>
    </div>
</div>

<!-- Sync Progress Indicator -->
<div id="syncIndicator" class="hidden fixed bottom-20 left-1/2 transform -translate-x-1/2 z-50">
    <div class="glass-card px-4 py-3 rounded-xl border border-border min-w-[250px]">
        <div class="flex items-center gap-3 mb-2">
            <div class="w-6 h-6 border-2 border-primary/30 border-t-primary rounded-full animate-spin"></div>
            <span class="text-xs font-bold text-main">Sincronizando...</span>
        </div>
        <div class="text-[10px] text-text-muted mb-2">
            <span class="sync-current">0</span> / <span class="sync-total">0</span> operaciones
        </div>
        <div class="h-1 bg-black/20 rounded-full overflow-hidden">
            <div class="sync-progress-bar h-full bg-primary transition-all duration-300" style="width: 0%"></div>
        </div>
    </div>
</div>
```

**JavaScript para manejar indicadores:**

```javascript
// Actualizar indicador de conexión
offlineManager.onConnectionChange((status) => {
    const statusDot = document.getElementById('statusDot');
    const statusText = document.getElementById('statusText');
    const connectionStatus = document.getElementById('connectionStatus');
    
    if (status === 'online') {
        statusDot.className = 'w-2 h-2 rounded-full bg-emerald-500';
        statusText.textContent = 'En línea';
        connectionStatus.classList.remove('bg-red-500/10');
        connectionStatus.classList.add('bg-emerald-500/10');
    } else {
        statusDot.className = 'w-2 h-2 rounded-full bg-red-500 animate-pulse';
        statusText.textContent = 'Sin conexión';
        connectionStatus.classList.remove('bg-emerald-500/10');
        connectionStatus.classList.add('bg-red-500/10');
    }
    
    updatePendingCount();
});

// Actualizar contador de operaciones pendientes
async function updatePendingCount() {
    const count = await offlineManager.getPendingCount();
    const pendingCount = document.getElementById('pendingCount');
    
    if (count > 0) {
        pendingCount.textContent = `${count} pendiente${count > 1 ? 's' : ''}`;
        pendingCount.classList.remove('hidden');
    } else {
        pendingCount.classList.add('hidden');
    }
}

// Actualizar cada 10 segundos
setInterval(updatePendingCount, 10000);
```

---

### FASE 3: Service Worker Avanzado (Semana 2-3)

#### Tarea 3.1: Mejorar Service Worker con Background Sync

**Modificar `WEB/sw.js`:**

```javascript
// sw.js
const CACHE_NAME = 'cubos-v3.5.4';
const OFFLINE_URL = '/offline.html';

// Recursos críticos para caché
const CRITICAL_RESOURCES = [
    '/',
    '/index.html',
    '/boss.html',
    '/login.html',
    '/styles.css',
    '/supabase-client.js',
    '/auth-service.js',
    '/offline-manager.js',
    '/offline-db.js',
    '/avatar-icons.js'
];

// Instalación
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(CRITICAL_RESOURCES);
        })
    );
    self.skipWaiting();
});

// Activación
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    self.clients.claim();
});

// Estrategia de caché
self.addEventListener('fetch', (event) => {
    const { request } = event;
    const url = new URL(request.url);

    // Solo cachear requests del mismo origen
    if (url.origin !== location.origin) {
        return;
    }

    // Network First para API calls
    if (url.pathname.includes('/rest/v1/')) {
        event.respondWith(networkFirst(request));
        return;
    }

    // Cache First para assets estáticos
    event.respondWith(cacheFirst(request));
});

async function networkFirst(request) {
    try {
        const response = await fetch(request);
        const cache = await caches.open(CACHE_NAME);
        cache.put(request, response.clone());
        return response;
    } catch (error) {
        const cached = await caches.match(request);
        return cached || new Response('Offline', { status: 503 });
    }
}

async function cacheFirst(request) {
    const cached = await caches.match(request);
    if (cached) {
        return cached;
    }

    try {
        const response = await fetch(request);
        const cache = await caches.open(CACHE_NAME);
        cache.put(request, response.clone());
        return response;
    } catch (error) {
        return new Response('Offline', { status: 503 });
    }
}

// Background Sync para sincronización automática
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-operations') {
        event.waitUntil(syncPendingOperations());
    }
});

async function syncPendingOperations() {
    try {
        // Abrir IndexedDB desde Service Worker
        const db = await openDB();
        const pending = await getPendingOperations(db);

        for (const operation of pending) {
            try {
                await executeOperation(operation);
                await markOperationSynced(db, operation.id);
            } catch (error) {
                console.error('Error syncing operation:', error);
                await markOperationFailed(db, operation.id, error.message);
            }
        }

        // Notificar a los clientes
        const clients = await self.clients.matchAll();
        clients.forEach(client => {
            client.postMessage({
                type: 'SYNC_COMPLETE',
                count: pending.length
            });
        });

    } catch (error) {
        console.error('Background sync failed:', error);
    }
}

// Periodic Background Sync (cada 5 minutos)
self.addEventListener('periodicsync', (event) => {
    if (event.tag === 'periodic-sync') {
        event.waitUntil(syncPendingOperations());
    }
});

// Helper functions para IndexedDB en Service Worker
function openDB() {
    return new Promise((resolve, reject) => {
        const request = indexedDB.open('CubosOfflineDB', 1);
        request.onsuccess = () => resolve(request.result);
        request.onerror = () => reject(request.error);
    });
}

function getPendingOperations(db) {
    return new Promise((resolve, reject) => {
        const tx = db.transaction(['pending_operations'], 'readonly');
        const store = tx.objectStore('pending_operations');
        const index = store.index('status');
        const request = index.getAll('pending');
        request.onsuccess = () => resolve(request.result);
        request.onerror = () => reject(request.error);
    });
}

async function executeOperation(operation) {
    // Aquí iría la lógica de ejecución
    // Similar a la del OfflineManager
    const response = await fetch('/rest/v1/movimientos', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': 'YOUR_SUPABASE_KEY'
        },
        body: JSON.stringify(operation.data)
    });

    if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
    }
}

function markOperationSynced(db, id) {
    return new Promise((resolve, reject) => {
        const tx = db.transaction(['pending_operations'], 'readwrite');
        const store = tx.objectStore('pending_operations');
        const getRequest = store.get(id);
        
        getRequest.onsuccess = () => {
            const operation = getRequest.result;
            operation.status = 'synced';
            operation.synced_at = new Date().toISOString();
            
            const updateRequest = store.put(operation);
            updateRequest.onsuccess = () => resolve();
            updateRequest.onerror = () => reject(updateRequest.error);
        };
    });
}

function markOperationFailed(db, id, error) {
    return new Promise((resolve, reject) => {
        const tx = db.transaction(['pending_operations'], 'readwrite');
        const store = tx.objectStore('pending_operations');
        const getRequest = store.get(id);
        
        getRequest.onsuccess = () => {
            const operation = getRequest.result;
            operation.retry_count += 1;
            operation.error = error;
            operation.status = operation.retry_count >= 5 ? 'failed' : 'pending';
            
            const updateRequest = store.put(operation);
            updateRequest.onsuccess = () => resolve();
            updateRequest.onerror = () => reject(updateRequest.error);
        };
    });
}
```

#### Tarea 3.2: Registrar Background Sync

**En `index.html`, después de registrar el Service Worker:**

```javascript
// Registrar Background Sync
if ('serviceWorker' in navigator && 'sync' in ServiceWorkerRegistration.prototype) {
    navigator.serviceWorker.ready.then((registration) => {
        // Registrar sync tag
        return registration.sync.register('sync-operations');
    }).then(() => {
        console.log('✅ Background Sync registrado');
    }).catch((error) => {
        console.error('❌ Error registrando Background Sync:', error);
    });
}

// Registrar Periodic Background Sync (si está disponible)
if ('serviceWorker' in navigator && 'periodicSync' in ServiceWorkerRegistration.prototype) {
    navigator.serviceWorker.ready.then((registration) => {
        return registration.periodicSync.register('periodic-sync', {
            minInterval: 5 * 60 * 1000 // 5 minutos
        });
    }).then(() => {
        console.log('✅ Periodic Sync registrado');
    }).catch((error) => {
        console.warn('⚠️ Periodic Sync no disponible:', error);
    });
}

// Escuchar mensajes del Service Worker
navigator.serviceWorker.addEventListener('message', (event) => {
    if (event.data.type === 'SYNC_COMPLETE') {
        console.log(`✅ Sincronización en segundo plano completada: ${event.data.count} operaciones`);
        updatePendingCount();
        loadMovements(true); // Recargar datos
    }
});
```

---

### FASE 4: Testing y Optimización (Semana 3)

#### Tarea 4.1: Crear Suite de Tests

**Archivo:** `WEB/tests/offline-mode.test.js`

```javascript
// offline-mode.test.js
describe('Offline Mode', () => {
    let offlineDB, offlineManager;

    beforeEach(async () => {
        // Inicializar DB de prueba
        offlineDB = new OfflineDB();
        await offlineDB.init();
        offlineManager = new OfflineManager();
    });

    test('Debe encolar operación cuando está offline', async () => {
        offlineManager.isOnline = false;
        
        const result = await offlineManager.queueOperation('INSERT_MOVEMENT', {
            obra_id: 'test-obra',
            tipo: 'incoming',
            capacidad: 10
        });

        expect(result.success).toBe(true);
        expect(result.queued).toBe(true);

        const pending = await offlineDB.getPendingOperations();
        expect(pending.length).toBe(1);
    });

    test('Debe sincronizar operaciones pendientes al recuperar conexión', async () => {
        // Encolar operación
        await offlineManager.queueOperation('INSERT_MOVEMENT', {
            obra_id: 'test-obra',
            tipo: 'incoming',
            capacidad: 10
        });

        // Simular recuperación de conexión
        offlineManager.isOnline = true;
        await offlineManager.syncPendingOperations();

        const pending = await offlineDB.getPendingOperations();
        expect(pending.length).toBe(0);
    });

    test('Debe reintentar operaciones fallidas', async () => {
        // TODO: Implementar test de reintentos
    });

    test('Debe manejar conflictos de sincronización', async () => {
        // TODO: Implementar test de conflictos
    });
});
```

#### Tarea 4.2: Pruebas Manuales

**Checklist de Pruebas:**

- [ ] **Escenario 1: Registro Offline Básico**
  1. Desactivar WiFi/Datos
  2. Registrar 5 vueltas
  3. Verificar que aparecen en UI
  4. Verificar contador de pendientes
  5. Activar conexión
  6. Verificar sincronización automática

- [ ] **Escenario 2: Conexión Intermitente**
  1. Registrar vuelta con conexión
  2. Desactivar conexión
  3. Registrar 3 vueltas
  4. Activar conexión
  5. Registrar 2 vueltas más
  6. Verificar que todas se sincronizaron

- [ ] **Escenario 3: Múltiples Operaciones**
  1. Offline: Registrar camión nuevo
  2. Offline: Registrar 10 vueltas con ese camión
  3. Offline: Editar datos del camión
  4. Activar conexión
  5. Verificar sincronización en orden correcto

- [ ] **Escenario 4: Cierre y Reapertura**
  1. Offline: Registrar 5 vueltas
  2. Cerrar navegador
  3. Reabrir (aún offline)
  4. Verificar que las 5 vueltas siguen pendientes
  5. Activar conexión
  6. Verificar sincronización

---

## 📊 Métricas de Éxito

### KPIs Técnicos
- ✅ **Tasa de Sincronización:** > 99% de operaciones sincronizadas exitosamente
- ✅ **Tiempo de Sincronización:** < 5 segundos para 100 registros
- ✅ **Capacidad Offline:** Mínimo 1000 operaciones almacenadas
- ✅ **Tasa de Conflictos:** < 1% de operaciones con conflictos

### KPIs de Usuario
- ✅ **Satisfacción:** > 90% de usuarios satisfechos con modo offline
- ✅ **Pérdida de Datos:** 0% de datos perdidos
- ✅ **Tiempo de Respuesta UI:** < 100ms para registrar vuelta offline
- ✅ **Claridad de Estado:** 100% de usuarios entienden el estado de conexión

---

## 🚨 Riesgos y Mitigaciones

### Riesgo 1: Conflictos de Sincronización
**Probabilidad:** Media  
**Impacto:** Alto  
**Mitigación:**
- Implementar timestamps para detectar conflictos
- Estrategia "Last Write Wins" para la mayoría de casos
- UI para resolución manual de conflictos críticos

### Riesgo 2: Límite de Almacenamiento IndexedDB
**Probabilidad:** Baja  
**Impacto:** Alto  
**Mitigación:**
- Monitorear uso de cuota
- Limpiar operaciones sincronizadas después de 7 días
- Alertar al usuario si se acerca al límite

### Riesgo 3: Service Worker no Soportado
**Probabilidad:** Muy Baja  
**Impacto:** Medio  
**Mitigación:**
- Fallback a sincronización manual
- Detección de capacidades del navegador
- Mensaje claro al usuario sobre limitaciones

---

## 📅 Cronograma

### Semana 1
- **Días 1-2:** Implementar IndexedDB Manager
- **Días 3-4:** Implementar Offline Manager
- **Día 5:** Testing unitario de componentes base

### Semana 2
- **Días 1-2:** Integración con index.html
- **Días 3-4:** Implementar indicadores visuales
- **Día 5:** Testing de integración

### Semana 3
- **Días 1-2:** Mejorar Service Worker
- **Días 3-4:** Testing exhaustivo (manual + automatizado)
- **Día 5:** Documentación y deployment

---

## 🎓 Recursos y Referencias

### Documentación Técnica
- [IndexedDB API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
- [Background Sync API](https://developer.chrome.com/docs/workbox/modules/workbox-background-sync/)
- [Service Worker Lifecycle](https://web.dev/service-worker-lifecycle/)

### Librerías Recomendadas (Opcional)
- **Dexie.js:** Wrapper moderno para IndexedDB (simplifica código)
- **Workbox:** Toolkit de Google para Service Workers avanzados

---

## ✅ Checklist de Deployment

Antes de lanzar a producción:

- [ ] Todos los tests pasan (unitarios + integración)
- [ ] Pruebas manuales completadas en 3+ dispositivos
- [ ] Documentación actualizada
- [ ] Migración de datos existentes (si aplica)
- [ ] Monitoreo configurado (Sentry, Analytics)
- [ ] Rollback plan definido
- [ ] Comunicación a usuarios sobre nueva funcionalidad
- [ ] Training para contadores sobre modo offline

---

## 📞 Contacto y Soporte

**Desarrollador Principal:** [Tu Nombre]  
**Email:** [tu-email]  
**Slack/Discord:** [canal-de-desarrollo]

---

**Última Actualización:** 4 de Enero, 2026  
**Versión del Plan:** 1.0

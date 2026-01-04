const CACHE_NAME = 'cubos-v3-cache-v14';
const ASSETS_TO_CACHE = [
    '/login.html',
    '/boss.html',
    '/index.html',
    '/site-selector.html',
    '/register.html',
    '/styles.css',
    '/manifest.json',
    '/icons/icon-192x192.png'
];

// Install Event
self.addEventListener('install', (event) => {
    self.skipWaiting();
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('SW: Pre-caching critical assets');
            return cache.addAll(ASSETS_TO_CACHE);
        })
    );
});

// Activate Event
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((keys) => {
            return Promise.all(
                keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
            );
        })
    );
    self.clients.claim();
});

// Fetch Event
self.addEventListener('fetch', (event) => {
    // Solo manejamos peticiones del mismo origen
    if (!event.request.url.startsWith(self.location.origin)) {
        return;
    }

    // Estrategia: Network First para archivos HTML (para asegurar que la versión siempre sea la última)
    if (event.request.mode === 'navigate' || event.request.url.endsWith('.html')) {
        event.respondWith(
            fetch(event.request)
                .then((response) => {
                    // Actualizamos el caché con la nueva respuesta
                    const copy = response.clone();
                    caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
                    return response;
                })
                .catch(() => caches.match(event.request)) // Si falla el red, usamos el cache
        );
        return;
    }

    // Estrategia: Cache First para el resto (imágenes, fuentes, etc)
    event.respondWith(
        caches.match(event.request).then((cachedResponse) => {
            if (cachedResponse) return cachedResponse;
            return fetch(event.request);
        })
    );
});

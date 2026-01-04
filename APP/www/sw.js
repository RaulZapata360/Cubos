const CACHE_NAME = 'cubos-v2-cache-v13';
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
    // Force the waiting service worker to become the active service worker.
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
    // Ensure the updated service worker takes control of all pages immediately.
    self.clients.claim();
});

// Fetch Event (Required for PWA installation)
self.addEventListener('fetch', (event) => {
    // We only want to handle same-origin requests
    if (!event.request.url.startsWith(self.location.origin)) {
        return;
    }

    event.respondWith(
        caches.match(event.request).then((cachedResponse) => {
            if (cachedResponse) {
                return cachedResponse;
            }
            return fetch(event.request).then((response) => {
                // If it's a valid response, maybe cache it dynamically? 
                // For now, just return it.
                return response;
            });
        }).catch(() => {
            // Error handling
        })
    );
});

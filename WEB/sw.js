const CACHE_NAME = 'cubos-v2-cache-v1';
const ASSETS_TO_CACHE = [
    '/',
    '/login.html',
    '/boss.html',
    '/index.html',
    '/styles.css',
    '/auth-service.js',
    '/supabase-client.js',
    '/avatar-icons.js',
    '/icons/icon-192x192.png',
    '/icons/icon-512x512.png'
];

// Install Event
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(ASSETS_TO_CACHE);
        })
    );
    self.skipWaiting();
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

// Fetch Event (Required for PWA installation)
self.addEventListener('fetch', (event) => {
    // Handle Supabase/External requests separately if needed
    if (event.request.url.includes('supabase.co')) {
        return;
    }

    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request).catch(() => {
                // Fallback or just let it fail for dynamic data
            });
        })
    );
});

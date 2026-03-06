// ==========================================
// QURANLOCK V5 - SERVICE WORKER
// ==========================================

const CACHE_NAME = 'quranlock-v5.0.0';
const STATIC_CACHE = 'quranlock-static-v5';
const DYNAMIC_CACHE = 'quranlock-dynamic-v5';

// Ressources à mettre en cache immédiatement
const STATIC_ASSETS = [
    '/',
    '/index.html',
    '/css/styles.css',
    '/js/app.js',
    '/js/data.js',
    '/js/firebase-config.js',
    '/manifest.json',
    '/assets/icons/icon-192x192.png',
    '/assets/icons/icon-512x512.png'
];

// Installation du Service Worker
self.addEventListener('install', event => {
    console.log('🕌 QuranLock SW: Installation...');
    
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then(cache => {
                console.log('📦 Mise en cache des ressources statiques...');
                return cache.addAll(STATIC_ASSETS);
            })
            .then(() => self.skipWaiting())
            .catch(err => console.error('Erreur cache:', err))
    );
});

// Activation du Service Worker
self.addEventListener('activate', event => {
    console.log('✅ QuranLock SW: Activation...');
    
    event.waitUntil(
        caches.keys()
            .then(cacheNames => {
                return Promise.all(
                    cacheNames
                        .filter(name => name !== STATIC_CACHE && name !== DYNAMIC_CACHE)
                        .map(name => {
                            console.log('🗑️ Suppression ancien cache:', name);
                            return caches.delete(name);
                        })
                );
            })
            .then(() => self.clients.claim())
    );
});

// Interception des requêtes
self.addEventListener('fetch', event => {
    const { request } = event;
    const url = new URL(request.url);
    
    // Ignorer les requêtes non-GET
    if (request.method !== 'GET') return;
    
    // Ignorer les requêtes vers des APIs externes (sauf Al-Quran Cloud)
    if (url.origin !== location.origin && !url.hostname.includes('alquran.cloud')) {
        return;
    }
    
    // Stratégie Cache First pour les ressources statiques
    if (isStaticAsset(url.pathname)) {
        event.respondWith(cacheFirst(request));
        return;
    }
    
    // Stratégie Network First pour l'API Quran
    if (url.hostname.includes('alquran.cloud')) {
        event.respondWith(networkFirst(request));
        return;
    }
    
    // Stratégie Stale While Revalidate pour le reste
    event.respondWith(staleWhileRevalidate(request));
});

// Vérifier si c'est une ressource statique
function isStaticAsset(pathname) {
    return pathname.match(/\.(css|js|png|jpg|jpeg|gif|svg|woff|woff2|ttf|eot)$/);
}

// Stratégie Cache First
async function cacheFirst(request) {
    const cached = await caches.match(request);
    if (cached) {
        return cached;
    }
    
    try {
        const response = await fetch(request);
        if (response.ok) {
            const cache = await caches.open(STATIC_CACHE);
            cache.put(request, response.clone());
        }
        return response;
    } catch (error) {
        return new Response('Ressource non disponible hors ligne', { status: 503 });
    }
}

// Stratégie Network First
async function networkFirst(request) {
    try {
        const response = await fetch(request);
        if (response.ok) {
            const cache = await caches.open(DYNAMIC_CACHE);
            cache.put(request, response.clone());
        }
        return response;
    } catch (error) {
        const cached = await caches.match(request);
        if (cached) {
            return cached;
        }
        return new Response(JSON.stringify({ error: 'Hors ligne' }), {
            status: 503,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// Stratégie Stale While Revalidate
async function staleWhileRevalidate(request) {
    const cached = await caches.match(request);
    
    const fetchPromise = fetch(request)
        .then(response => {
            if (response.ok) {
                const cache = caches.open(DYNAMIC_CACHE);
                cache.then(c => c.put(request, response.clone()));
            }
            return response;
        })
        .catch(() => cached);
    
    return cached || fetchPromise;
}

// Gestion des notifications push
self.addEventListener('push', event => {
    if (!event.data) return;
    
    const data = event.data.json();
    
    const options = {
        body: data.body || 'Nouvelle notification de QuranLock',
        icon: '/assets/icons/icon-192x192.png',
        badge: '/assets/icons/badge-72x72.png',
        vibrate: [100, 50, 100],
        data: {
            url: data.url || '/'
        },
        actions: [
            { action: 'open', title: 'Ouvrir' },
            { action: 'close', title: 'Fermer' }
        ]
    };
    
    event.waitUntil(
        self.registration.showNotification(data.title || 'QuranLock', options)
    );
});

// Clic sur notification
self.addEventListener('notificationclick', event => {
    event.notification.close();
    
    if (event.action === 'close') return;
    
    const urlToOpen = event.notification.data?.url || '/';
    
    event.waitUntil(
        clients.matchAll({ type: 'window', includeUncontrolled: true })
            .then(windowClients => {
                // Chercher une fenêtre existante
                for (const client of windowClients) {
                    if (client.url.includes(self.location.origin) && 'focus' in client) {
                        client.navigate(urlToOpen);
                        return client.focus();
                    }
                }
                // Sinon ouvrir une nouvelle fenêtre
                return clients.openWindow(urlToOpen);
            })
    );
});

// Synchronisation en arrière-plan
self.addEventListener('sync', event => {
    console.log('🔄 Sync event:', event.tag);
    
    if (event.tag === 'sync-bookmarks') {
        event.waitUntil(syncBookmarks());
    }
    
    if (event.tag === 'sync-progress') {
        event.waitUntil(syncProgress());
    }
});

async function syncBookmarks() {
    // Synchroniser les favoris avec Firebase
    console.log('📚 Synchronisation des favoris...');
}

async function syncProgress() {
    // Synchroniser la progression avec Firebase
    console.log('📊 Synchronisation de la progression...');
}

// Gestion des mises à jour
self.addEventListener('message', event => {
    if (event.data === 'skipWaiting') {
        self.skipWaiting();
    }
});

console.log('🕌 QuranLock Service Worker chargé');

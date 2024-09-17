self.addEventListener('install', function(event) {
  console.log('[Service Worker] Installing Service Worker...');
});

self.addEventListener('activate', function(event) {
  console.log('[Service Worker] Activating Service Worker...');
});

self.addEventListener('fetch', function(event) {
  console.log('[Service Worker] Fetching something....', event.request.url);
});
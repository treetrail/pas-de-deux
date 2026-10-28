// Offline cache of the web app. Network first, so a new version arrives as
// soon as there is a connection; without one, the last version from the
// cache starts.
const cacheName = "pas-de-deux";

// Files the app only loads later, possibly when there is no connection:
// the wake lock script at the first game, the tone at the end of the look.
const later = [
  "assets/packages/wakelock_plus/assets/no_sleep.js",
  "assets/assets/sounds/look_end.wav",
  "assets/AssetManifest.bin.json",
  "assets/shaders/ink_sparkle.frag",
  "assets/shaders/stretch_effect.frag",
];

self.addEventListener("install", (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(cacheName).then((cache) =>
      Promise.all(later.map((url) => cache.add(url).catch(() => {}))),
    ),
  );
});

self.addEventListener("activate", (event) => event.waitUntil(self.clients.claim()));

self.addEventListener("fetch", (event) => {
  const request = event.request;
  if (request.method !== "GET" || new URL(request.url).origin !== location.origin) return;
  event.respondWith(
    fetch(request)
      .then((response) => {
        if (response.ok) {
          const copy = response.clone();
          caches.open(cacheName).then((cache) => cache.put(request, copy));
        }
        return response;
      })
      .catch(() =>
        caches
          .match(request, { ignoreSearch: true })
          .then((cached) => cached || Response.error()),
      ),
  );
});

// The first visit loads before this worker runs; the page sends the files it
// loaded so far, so the second start already works offline.
self.addEventListener("message", (event) => {
  if (event.data?.type !== "cache") return;
  event.waitUntil(
    caches.open(cacheName).then((cache) =>
      Promise.all(
        event.data.urls.map(async (url) => {
          if (!(await cache.match(url))) await cache.add(url).catch(() => {});
        }),
      ),
    ),
  );
});

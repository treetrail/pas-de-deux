{{flutter_js}}
{{flutter_build_config}}

// Without serviceWorkerSettings: Flutter's own service worker is deprecated,
// the offline cache is sw.js (registered in index.html).
_flutter.loader.load();

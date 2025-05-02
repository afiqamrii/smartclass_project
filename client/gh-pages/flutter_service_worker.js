'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "783468387dbd9d48e99b9a0fc7f3737a",
"assets/AssetManifest.bin.json": "fc311cda9556d4e7ea7b88f6c6319df9",
"assets/AssetManifest.json": "35919e2f1be1a3439f63da6aa6e0f019",
"assets/assets/animations/animation1.json": "16f896de4cb49230e4b41fb55de89a77",
"assets/assets/animations/animation_success.json": "e33e8d38240c4d0fcab1f6bd6db559f5",
"assets/assets/animations/animation_welcome.json": "23be47b50b134f8c299e103bb3ef07c2",
"assets/assets/animations/emailSended.json": "65e7c4da7d939ef6bd6f5dd7ad5f0a08",
"assets/assets/animations/introPage2.json": "5718341c55af23733f547430892a6295",
"assets/assets/animations/introPage3.json": "d085f92ce5996eb8b3b20d82ab87ead1",
"assets/assets/animations/introPage4.json": "0fd1a89137561a6dae8ac2cc480c5ca0",
"assets/assets/animations/nfc.json": "34cdf6c92d69bed41403ff939b0ec757",
"assets/assets/animations/noClassAnimation.json": "45d3e4c7487c1089e5df8f4bff12e455",
"assets/assets/animations/passwordCheck.json": "ce55673d1f95ce2285b08a6f60637b5f",
"assets/assets/animations/refreshAnimation.lottie": "2f9640dc5f8005e3d37ed6969a034454",
"assets/assets/animations/reportUtilityAnimation.json": "c3fe754e79c76cc341b5fb352cce50db",
"assets/assets/animations/splashscreen_animation.json": "5f16dd2b81e0fa7c2a96000dfaedeeda",
"assets/assets/animations/test.json": "38bbb2732d185907d1b6d08706cc5551",
"assets/assets/animations/test.webm": "fda222d4a5236eb3b92567e2ed9fbcc3",
"assets/assets/animations/unavailableAnimation.json": "6c6367efadbfbc3967ea0c88f52a9204",
"assets/assets/animations/welcomepage.json": "775754a8536d395765c2ed7b0f5965e6",
"assets/assets/background/background.avif": "62030acc5b396a8a492987105b72c613",
"assets/assets/background/backgroundImage.jpg": "4399281a91dcdfd3ad0dfc8588ebf94c",
"assets/assets/background/welcomePageBackground.svg": "4dc22005020962574a047cab481eed94",
"assets/assets/icons/add.png": "59d77deeffd4209ba3df225bc0b5a01a",
"assets/assets/icons/admin.svg": "b418ee37d200bc8f93c135b07baf770f",
"assets/assets/icons/arrow-left.svg": "418218bf20c24dada9a28e601e483d52",
"assets/assets/icons/edit-button.png": "18c38ac5ecd0acaaf02a44234ad510f3",
"assets/assets/icons/edit-button.svg": "d923c896fe43980905a705d5077d6da4",
"assets/assets/icons/edit.png": "e5746e6163957c3a900efbb64e1d1e5f",
"assets/assets/icons/editicon.png": "dcc61546a124825aced55d92eb62c0de",
"assets/assets/icons/fingerprint.svg": "d7cc4bd1b628234bd3119e979cee4c7d",
"assets/assets/icons/forgotPassword.png": "c08efa6048cab7b563e1c56a154b3463",
"assets/assets/icons/home.svg": "90642535186b83002304963cc599720e",
"assets/assets/icons/lecturer.svg": "171bebfb7cf530ce4f88e275ff699ce5",
"assets/assets/icons/logout.png": "2866f3d528fc1b46801f482d49fc3d2b",
"assets/assets/icons/padlock.png": "5cfff37cc6859fbf132341d5956ebeda",
"assets/assets/icons/report.png": "046615ac6c759834c13344f63886420d",
"assets/assets/icons/reportIcon.png": "54ac4b7f4e23cb7939c0be222e899f9e",
"assets/assets/icons/student.svg": "9244292ecd33e518eba511d15d862607",
"assets/assets/icons/user.png": "29479ba0435741580ca9f4a467be6207",
"assets/assets/pictures/compPicture.jpg": "0337425ab5407cc189564798481f576e",
"assets/assets/pictures/electric.png": "40e2e8937ee05e4665ef0c8136b7eab0",
"assets/assets/pictures/electric.svg": "2820788a1c83ab7983d6ff52f9ea5a46",
"assets/assets/pictures/electricity.jpg": "29d51325cf8914a551384431e086427f",
"assets/assets/pictures/logo.png": "fb9f8482bc6adb2b2f168538a6daa679",
"assets/assets/pictures/Thunder%2520Illustration.png": "fd0d4bb2ba253ca31a90556cf4e64673",
"assets/assets/umtLogo.png": "2ab7402e06e04055a031b559fe993a30",
"assets/FontManifest.json": "c42fde24e2fa8dfcef30aad57e45faf2",
"assets/fonts/Figtree-Bold.ttf": "aae832abcd32ce810f204801f1f7414b",
"assets/fonts/Figtree-ExtraBold.ttf": "19a2528ef773ae826f8f1be9aa162ea7",
"assets/fonts/Figtree-Regular.ttf": "5f1dc6017b44a0872c44171c5b2fb589",
"assets/fonts/MaterialIcons-Regular.otf": "faf083b78a521ccc682483d9b55f2939",
"assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/lib/master/strings.json": "d1f4de129bce29c2f36cb929b470d005",
"assets/NOTICES": "c4b54e5707b54ebe26e14fd6faa007c7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/quickalert/assets/confirm.gif": "bdc3e511c73e97fbc5cfb0c2b5f78e00",
"assets/packages/quickalert/assets/error.gif": "c307db003cf53e131f1c704bb16fb9bf",
"assets/packages/quickalert/assets/info.gif": "90d7fface6e2d52554f8614a1f5deb6b",
"assets/packages/quickalert/assets/loading.gif": "ac70f280e4a1b90065fe981eafe8ae13",
"assets/packages/quickalert/assets/success.gif": "dcede9f3064fe66b69f7bbe7b6e3849f",
"assets/packages/quickalert/assets/warning.gif": "f45dfa3b5857b812e0c8227211635cc4",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "bba67726a38a49355abc50f307f469cc",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "d24cfa9d4e671257e0a165f6e087d763",
"/": "d24cfa9d4e671257e0a165f6e087d763",
"main.dart.js": "7cbb137efa11ffebbc1fa61f46729af8",
"manifest.json": "28e4daf08b95dfe66a0c20a535f57d31",
"version.json": "5a966234a81de939a55bbdb80822c5f2"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';

class TracearrState extends LunaModuleState {
  TracearrState() {
    reset();
  }

  @override
  void reset() {
    _activeStreamCount = 0;
    resetProfile();
    notifyListeners();
  }

  ///////////////////
  /// LIVE COUNTS ///
  ///////////////////

  /// Count of active streams as last reported by the Streams tab.
  /// Used by the bottom navigation bar to badge the Streams icon when
  /// another tab is active.
  int _activeStreamCount = 0;
  int get activeStreamCount => _activeStreamCount;

  void updateActiveStreamCount(int count) {
    if (_activeStreamCount == count) return;
    _activeStreamCount = count;
    notifyListeners();
  }

  ///////////////
  /// PROFILE ///
  ///////////////

  /// API handler. `null` when the module is disabled or unconfigured.
  TracearrAPI? _api;
  TracearrAPI? get api => _api;

  bool _enabled = false;
  bool get enabled => _enabled;

  String _host = '';
  String get host => _host;

  String _apiKey = '';
  String get apiKey => _apiKey;

  Map<dynamic, dynamic> _headers = {};
  Map<dynamic, dynamic> get headers => _headers;

  /// HTTP headers to attach when fetching images served by Tracearr.
  /// `posterUrl` returned by the API points back at Tracearr itself
  /// (proxied image route) and may require the same Bearer token used
  /// for the JSON API.
  Map<String, String> get imageHeaders {
    return {
      ..._headers.map((k, v) => MapEntry(k.toString(), v.toString())),
      if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
    };
  }

  /// Resolve a Tracearr image path to an absolute URL.
  ///
  /// The API returns `posterUrl` / `avatarUrl` / etc. as **paths relative
  /// to the Tracearr root** (e.g. `/api/v1/images/proxy?...`). Without
  /// resolution the browser fetches them against the LunaSea origin.
  ///
  /// Returns `null` if the input is empty or the module is unconfigured.
  /// Leaves already-absolute URLs untouched.
  String? resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (_host.isEmpty) return null;
    final base =
        _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$base$cleanPath';
  }

  void resetProfile() {
    final profile = LunaProfile.current;
    _enabled = profile.tracearrEnabled;
    _host = profile.tracearrHost;
    _apiKey = profile.tracearrKey;
    _headers = profile.tracearrHeaders;
    _api = _enabled && _host.isNotEmpty
        ? TracearrAPI(
            host: _host,
            apiKey: _apiKey,
            headers: Map<String, dynamic>.from(_headers),
          )
        : null;
  }
}

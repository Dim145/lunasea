import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/system/platform.dart';

/// Handles incoming `lunasea://` deep links, which are produced by the
/// LunaSea notification service as ntfy "click" URLs.
///
/// Expected URI shape: `lunasea://<module>?event=<event>&<extras>`
///
/// On receipt, this dispatches to the module's existing
/// `handleWebhook(data)` which contains the navigation logic.
class LunaDeepLinks {
  LunaDeepLinks._();
  static final LunaDeepLinks _instance = LunaDeepLinks._();
  factory LunaDeepLinks() => _instance;

  static bool get isSupported =>
      LunaPlatform.isAndroid || LunaPlatform.isIOS || LunaPlatform.isMacOS;

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  /// Subscribe to deep links and process any initial link the app was
  /// launched from. Safe to call multiple times.
  Future<void> initialize() async {
    if (!isSupported) return;
    if (_appLinks != null) return; // already initialized

    _appLinks = AppLinks();
    try {
      final initial = await _appLinks!.getInitialLink();
      if (initial != null) {
        // Fire after the first frame so the router/state is ready
        scheduleMicrotask(() => _handle(initial));
      }
    } catch (error, stack) {
      LunaLogger().error('Failed to read initial deep link', error, stack);
    }

    _sub = _appLinks!.uriLinkStream.listen(
      _handle,
      onError: (error, stack) {
        LunaLogger().error('Deep link stream error', error, stack);
      },
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _appLinks = null;
  }

  Future<void> _handle(Uri uri) async {
    if (uri.scheme != 'lunasea') {
      LunaLogger().debug('Ignoring non-lunasea deep link: $uri');
      return;
    }
    final module = LunaModule.fromKey(uri.host);
    if (module == null) {
      LunaLogger().warning('Unknown module in deep link: ${uri.host}');
      return;
    }
    LunaLogger().debug('Dispatching deep link to ${module.key}: ${uri.queryParameters}');
    try {
      await module.handleWebhook(Map<String, dynamic>.from(uri.queryParameters));
    } catch (error, stack) {
      LunaLogger().error('Failed to handle deep link $uri', error, stack);
    }
  }
}

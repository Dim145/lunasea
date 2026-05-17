import 'package:lunasea/core.dart';

abstract class LunaWebhooks {
  Future<void> handle(Map<dynamic, dynamic> data);

  /// Modules supported by the LunaSea notification service (ntfy backend).
  static const Set<LunaModule> supportedModules = {
    LunaModule.LIDARR,
    LunaModule.RADARR,
    LunaModule.SONARR,
    LunaModule.TAUTULLI,
    LunaModule.OVERSEERR,
  };

  /// Build the webhook URL the user should plug into their *arr / Tautulli /
  /// Overseerr instance, based on the configured notification service base URL
  /// and topic. Returns `null` if either is not configured yet.
  static String? buildTopicURL(LunaModule module) {
    final base = LunaSeaDatabase.NOTIFICATIONS_SERVICE_URL.read().trim();
    final topic = LunaSeaDatabase.NOTIFICATIONS_TOPIC.read().trim();
    if (base.isEmpty || topic.isEmpty) return null;
    final cleanBase = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    return '$cleanBase/v1/${module.key}/$topic';
  }
}

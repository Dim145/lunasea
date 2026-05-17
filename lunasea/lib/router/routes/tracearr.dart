import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/tracearr/core/state.dart';
import 'package:lunasea/modules/tracearr/routes/history_details/route.dart';
import 'package:lunasea/modules/tracearr/routes/home/route.dart';
import 'package:lunasea/modules/tracearr/routes/stream_details/route.dart';
import 'package:lunasea/modules/tracearr/routes/user_details/route.dart';
import 'package:lunasea/router/routes.dart';
import 'package:lunasea/vendor.dart';

enum TracearrRoutes with LunaRoutesMixin {
  HOME('/tracearr'),
  STREAM_DETAILS('stream/:id'),
  HISTORY_DETAILS('history/:id'),
  USER_DETAILS('user/:id');

  @override
  final String path;

  const TracearrRoutes(this.path);

  @override
  LunaModule get module => LunaModule.TRACEARR;

  @override
  bool isModuleEnabled(BuildContext context) {
    return context.read<TracearrState>().enabled;
  }

  @override
  GoRoute get routes {
    switch (this) {
      case TracearrRoutes.HOME:
        return route(widget: const TracearrRoute());
      case TracearrRoutes.STREAM_DETAILS:
        return route(builder: (_, state) {
          return TracearrStreamDetailsRoute(
            streamId: state.pathParameters['id'] ?? '',
            initialStream: state.extra as TracearrStream?,
          );
        });
      case TracearrRoutes.HISTORY_DETAILS:
        return route(builder: (_, state) {
          final item = state.extra as TracearrSessionHistory?;
          if (item == null) {
            return const _MissingExtraMessage(label: 'History entry');
          }
          return TracearrHistoryDetailsRoute(item: item);
        });
      case TracearrRoutes.USER_DETAILS:
        return route(builder: (_, state) {
          final user = state.extra as TracearrUser?;
          if (user == null) {
            return const _MissingExtraMessage(label: 'User');
          }
          return TracearrUserDetailsRoute(user: user);
        });
    }
  }

  @override
  List<GoRoute> get subroutes {
    switch (this) {
      case TracearrRoutes.HOME:
        return [
          TracearrRoutes.STREAM_DETAILS.routes,
          TracearrRoutes.HISTORY_DETAILS.routes,
          TracearrRoutes.USER_DETAILS.routes,
        ];
      default:
        return const [];
    }
  }
}

/// Fallback shown when a details route is opened without its `extra` payload
/// (e.g. deep link or browser refresh on the web).
class _MissingExtraMessage extends StatelessWidget {
  final String label;
  const _MissingExtraMessage({required this.label});

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: GlobalKey(),
      appBar: LunaAppBar(title: 'Details'),
      body: LunaMessage.goBack(
        context: context,
        text: '$label not available. Open the list and tap again.',
      ),
    );
  }
}

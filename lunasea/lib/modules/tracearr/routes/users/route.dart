import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/home/widgets/navigation_bar.dart';
import 'package:lunasea/router/routes/tracearr.dart';

class TracearrUsersRoute extends StatefulWidget {
  const TracearrUsersRoute({Key? key}) : super(key: key);

  @override
  State<TracearrUsersRoute> createState() => _State();
}

class _State extends State<TracearrUsersRoute>
    with AutomaticKeepAliveClientMixin, LunaLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<TracearrUsersResponse>? _future;

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    await _reload();
  }

  Future<void> _reload() async {
    final api = context.read<TracearrState>().api;
    if (api == null) return;
    setState(() => _future = api.service.users(page: 1, pageSize: 100));
    await _future;
  }

  Color _trustColor(int score) {
    if (score >= 80) return LunaColours.accent;
    if (score >= 50) return LunaColours.orange;
    return LunaColours.red;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.TRACEARR,
      body: LunaRefreshIndicator(
        context: context,
        key: _refreshKey,
        onRefresh: _reload,
        child: FutureBuilder<TracearrUsersResponse>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                LunaLogger().error(
                  'Unable to fetch Tracearr users',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return LunaMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (!snapshot.hasData) return const LunaLoader();
            if (snapshot.data!.data.isEmpty) {
              return LunaMessage(
                text: 'tracearr.NoUsersFound'.tr(),
                buttonText: 'lunasea.Refresh'.tr(),
                onTap: _refreshKey.currentState!.show,
              );
            }
            return LunaListView(
              controller: TracearrNavigationBar.scrollControllers[2],
              children: snapshot.data!.data.map(_tile).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _tile(TracearrUser user) {
    final tracearrState = context.read<TracearrState>();
    return LunaBlock(
      title: user.displayName.isEmpty ? user.username : user.displayName,
      posterUrl: tracearrState.resolveImageUrl(user.avatarUrl),
      posterHeaders: tracearrState.imageHeaders,
      posterPlaceholderIcon: Icons.person_rounded,
      posterIsSquare: true,
      body: [
        TextSpan(text: '${user.serverName} • ${user.role.value}\n'),
        TextSpan(
          text:
              '${user.sessionCount} sessions • Trust ${user.trustScore} • ${user.totalViolations} violations',
        ),
      ],
      trailing: LunaIconButton(
        text: '${user.trustScore}',
        color: _trustColor(user.trustScore),
      ),
      onTap: () => TracearrRoutes.USER_DETAILS.go(
        params: {'id': user.id},
        extra: user,
      ),
    );
  }
}

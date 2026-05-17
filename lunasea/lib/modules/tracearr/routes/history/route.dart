import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/home/widgets/navigation_bar.dart';
import 'package:lunasea/router/routes/tracearr.dart';

class TracearrHistoryRoute extends StatefulWidget {
  const TracearrHistoryRoute({Key? key}) : super(key: key);

  @override
  State<TracearrHistoryRoute> createState() => _State();
}

class _State extends State<TracearrHistoryRoute>
    with AutomaticKeepAliveClientMixin, LunaLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<TracearrHistoryResponse>? _future;

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    await _reload();
  }

  Future<void> _reload() async {
    final api = context.read<TracearrState>().api;
    if (api == null) return;
    setState(() {
      _future = api.service.history(
        page: 1,
        pageSize: TracearrDatabase.CONTENT_LOAD_LENGTH.read(),
      );
    });
    await _future;
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
        child: FutureBuilder<TracearrHistoryResponse>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                LunaLogger().error(
                  'Unable to fetch Tracearr history',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return LunaMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (!snapshot.hasData) return const LunaLoader();
            if (snapshot.data!.data.isEmpty) {
              return LunaMessage(
                text: 'tracearr.NoHistoryFound'.tr(),
                buttonText: 'lunasea.Refresh'.tr(),
                onTap: _refreshKey.currentState!.show,
              );
            }
            return LunaListView(
              controller: TracearrNavigationBar.scrollControllers[1],
              children: snapshot.data!.data.map(_tile).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _tile(TracearrSessionHistory item) {
    final mediaTitle = item.mediaTitle ?? 'Unknown';
    final title = item.mediaType == TracearrMediaType.episode &&
            item.showTitle != null
        ? '${item.showTitle} — $mediaTitle'
        : mediaTitle;
    final username = item.user?.username ?? 'Unknown user';
    final serverName = item.serverName ?? 'Unknown server';
    final watched = item.watched ?? false;
    final lines = <String>[
      '$username • $serverName',
      [
        if (watched) 'Watched',
        if (item.isTranscode == true) 'Transcode',
        if (item.resolution != null) item.resolution!,
        if (item.platform != null) item.platform!,
      ].join(' • '),
    ];
    final tracearrState = context.read<TracearrState>();
    final poster = tracearrState.resolveImageUrl(item.posterUrl);
    return LunaBlock(
      title: title,
      posterUrl: poster,
      posterHeaders: tracearrState.imageHeaders,
      posterPlaceholderIcon: Icons.live_tv_rounded,
      backgroundUrl: poster,
      backgroundHeaders: tracearrState.imageHeaders,
      body: lines.map((l) => TextSpan(text: l + '\n')).toList(),
      trailing: LunaIconButton(
        icon: watched ? Icons.check_circle_rounded : Icons.history_rounded,
        color: watched ? LunaColours.accent : Colors.grey,
      ),
      onTap: () => TracearrRoutes.HISTORY_DETAILS.go(
        params: {'id': item.id ?? 'unknown'},
        extra: item,
      ),
    );
  }
}

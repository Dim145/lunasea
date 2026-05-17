import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/home/widgets/navigation_bar.dart';
import 'package:lunasea/modules/tracearr/routes/streams/widgets/stream_tile.dart';

class TracearrStreamsRoute extends StatefulWidget {
  const TracearrStreamsRoute({Key? key}) : super(key: key);

  @override
  State<TracearrStreamsRoute> createState() => _State();
}

class _State extends State<TracearrStreamsRoute>
    with AutomaticKeepAliveClientMixin, LunaLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<TracearrStreamsResponse>? _future;
  Timer? _refreshTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(
      Duration(seconds: TracearrDatabase.REFRESH_RATE.read()),
      (_) => _reload(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Future<void> loadCallback() async {
    await _reload();
  }

  Future<void> _reload() async {
    final state = context.read<TracearrState>();
    final api = state.api;
    if (api == null) return;
    final future = api.service.streams();
    setState(() => _future = future);
    try {
      final response = await future;
      state.updateActiveStreamCount(response.data.length);
    } catch (_) {
      // errors surface via the FutureBuilder; don't touch the count
    }
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
        child: FutureBuilder<TracearrStreamsResponse>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                LunaLogger().error(
                  'Unable to fetch Tracearr streams',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return LunaMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (!snapshot.hasData) return const LunaLoader();
            return _list(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _list(TracearrStreamsResponse response) {
    if (response.data.isEmpty) {
      return LunaMessage(
        text: 'tracearr.NoActiveStreams'.tr(),
        buttonText: 'lunasea.Refresh'.tr(),
        onTap: _refreshKey.currentState!.show,
      );
    }
    return LunaListView(
      controller: TracearrNavigationBar.scrollControllers[0],
      children: [
        _summary(response.summary),
        ...response.data.map(
          (stream) => TracearrStreamTile(
            stream: stream,
            onRefresh: _reload,
          ),
        ),
      ],
    );
  }

  Widget _summary(TracearrStreamsSummary summary) {
    return LunaBlock(
      title: '${summary.total} active • ${summary.totalBitrate}',
      body: [
        TextSpan(
          text:
              '${summary.directPlays} direct • ${summary.directStreams} stream • ${summary.transcodes} transcode',
        ),
      ],
      trailing: const LunaIconButton(icon: Icons.equalizer_rounded),
    );
  }
}

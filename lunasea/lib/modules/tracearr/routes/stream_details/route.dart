import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/stream_details/widgets/blocks.dart';
import 'package:lunasea/modules/tracearr/routes/stream_details/widgets/bottom_action_bar.dart';
import 'package:lunasea/modules/tracearr/routes/streams/widgets/stream_tile.dart';

class TracearrStreamDetailsRoute extends StatefulWidget {
  final String streamId;
  final TracearrStream? initialStream;

  const TracearrStreamDetailsRoute({
    Key? key,
    required this.streamId,
    this.initialStream,
  }) : super(key: key);

  @override
  State<TracearrStreamDetailsRoute> createState() => _State();
}

class _State extends State<TracearrStreamDetailsRoute>
    with LunaScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<TracearrStreamsResponse>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final api = context.read<TracearrState>().api;
    if (api == null) return;
    setState(() => _future = api.service.streams());
    await _future;
  }

  TracearrStream? _findStream(TracearrStreamsResponse? snapshot) {
    final live = snapshot?.data.firstWhereOrNull((s) => s.id == widget.streamId);
    return live ?? widget.initialStream;
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: LunaAppBar(
        title: 'Activity Details',
        scrollControllers: [scrollController],
      ),
      body: LunaRefreshIndicator(
        context: context,
        key: _refreshKey,
        onRefresh: _reload,
        child: FutureBuilder<TracearrStreamsResponse>(
          future: _future,
          builder: (context, snapshot) {
            // If we have an initial stream, show it immediately while
            // the streams list refreshes in the background.
            if (snapshot.connectionState == ConnectionState.waiting &&
                widget.initialStream != null) {
              return _content(widget.initialStream!);
            }
            if (snapshot.hasError) {
              if (widget.initialStream != null) {
                return _content(widget.initialStream!);
              }
              return LunaMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (!snapshot.hasData) return const LunaLoader();
            final stream = _findStream(snapshot.data);
            if (stream == null) {
              return LunaMessage.goBack(
                context: context,
                text: 'Session ended',
              );
            }
            return _content(stream);
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<TracearrStreamsResponse>(
        future: _future,
        builder: (context, snapshot) {
          final stream = _findStream(snapshot.data) ?? widget.initialStream;
          if (stream == null) return const SizedBox.shrink();
          return TracearrStreamDetailsBottomActionBar(
            stream: stream,
            onTerminated: _reload,
          );
        },
      ),
    );
  }

  Widget _content(TracearrStream stream) {
    return LunaListView(
      controller: scrollController,
      children: [
        TracearrStreamTile(stream: stream, disableOnTap: true),
        LunaHeader(text: 'Metadata'),
        TracearrStreamMetadataBlock(stream: stream),
        LunaHeader(text: 'Player'),
        TracearrStreamPlayerBlock(stream: stream),
        LunaHeader(text: 'Stream'),
        TracearrStreamStreamBlock(stream: stream),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/history_details/widgets/blocks.dart';

class TracearrHistoryDetailsRoute extends StatefulWidget {
  final TracearrSessionHistory item;

  const TracearrHistoryDetailsRoute({Key? key, required this.item})
      : super(key: key);

  @override
  State<TracearrHistoryDetailsRoute> createState() => _State();
}

class _State extends State<TracearrHistoryDetailsRoute>
    with LunaScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final tracearrState = context.read<TracearrState>();
    final mediaTitle = item.mediaTitle ?? 'Unknown';
    final title = item.mediaType == TracearrMediaType.episode &&
            item.showTitle != null
        ? '${item.showTitle} — $mediaTitle'
        : mediaTitle;
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: LunaAppBar(
        title: 'History Details',
        scrollControllers: [scrollController],
      ),
      body: LunaListView(
        controller: scrollController,
        children: [
          LunaBlock(
            title: title,
            posterUrl: tracearrState.resolveImageUrl(item.posterUrl),
            posterHeaders: tracearrState.imageHeaders,
            posterPlaceholderIcon: Icons.live_tv_rounded,
            backgroundUrl: tracearrState.resolveImageUrl(item.posterUrl),
            backgroundHeaders: tracearrState.imageHeaders,
            body: [
              TextSpan(
                text: '${item.user?.username ?? 'Unknown'} • '
                    '${item.serverName ?? 'Unknown'}\n',
              ),
              TextSpan(
                text: item.state.value.toUpperCase(),
              ),
            ],
          ),
          LunaHeader(text: 'Metadata'),
          TracearrHistoryMetadataBlock(item: item),
          LunaHeader(text: 'Session'),
          TracearrHistorySessionBlock(item: item),
          LunaHeader(text: 'Player'),
          TracearrHistoryPlayerBlock(item: item),
        ],
      ),
    );
  }
}

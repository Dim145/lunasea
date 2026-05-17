import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/router/routes/tracearr.dart';

class TracearrStreamTile extends StatelessWidget {
  final TracearrStream stream;
  final bool disableOnTap;
  final Future<void> Function()? onRefresh;

  const TracearrStreamTile({
    Key? key,
    required this.stream,
    this.disableOnTap = false,
    this.onRefresh,
  }) : super(key: key);

  String get _title {
    if (stream.mediaType == TracearrMediaType.episode &&
        stream.showTitle != null) {
      final s = stream.seasonNumber;
      final e = stream.episodeNumber;
      final tag = (s != null && e != null)
          ? 'S${s.toString().padLeft(2, '0')}E${e.toString().padLeft(2, '0')}'
          : '';
      return '${stream.showTitle} $tag — ${stream.mediaTitle}';
    }
    if (stream.mediaType == TracearrMediaType.track &&
        stream.artistName != null) {
      return '${stream.artistName} — ${stream.mediaTitle}';
    }
    return stream.mediaTitle;
  }

  String get _subtitleLine1 {
    final parts = <String>[stream.username];
    parts.add(stream.serverName);
    if (stream.platform != null) parts.add(stream.platform!);
    return parts.join(' • ');
  }

  String get _subtitleLine2 {
    final parts = <String>[];
    final state = stream.state.value.toUpperCase();
    parts.add(state);
    if (stream.resolution != null) parts.add(stream.resolution!);
    if (stream.isTranscode == true) {
      parts.add('Transcode');
    } else if (stream.isTranscode == false) {
      parts.add('Direct Play');
    }
    if (stream.durationMs != null &&
        stream.durationMs! > 0 &&
        stream.progressMs != null) {
      final pct =
          ((stream.progressMs! / stream.durationMs!) * 100).clamp(0, 100);
      parts.add('${pct.toStringAsFixed(0)}%');
    }
    return parts.join(' • ');
  }

  double? get _progress {
    final duration = stream.durationMs;
    final progress = stream.progressMs;
    if (duration == null || duration <= 0 || progress == null) return null;
    return (progress / duration).clamp(0.0, 1.0);
  }

  Color get _stateColor {
    switch (stream.state) {
      case TracearrPlaybackState.playing:
        return LunaColours.accent;
      case TracearrPlaybackState.paused:
        return LunaColours.orange;
      case TracearrPlaybackState.stopped:
        return LunaColours.red;
      case TracearrPlaybackState.unknown:
        return Colors.grey;
    }
  }

  IconData get _stateIcon {
    switch (stream.state) {
      case TracearrPlaybackState.playing:
        return Icons.play_arrow_rounded;
      case TracearrPlaybackState.paused:
        return Icons.pause_rounded;
      case TracearrPlaybackState.stopped:
        return Icons.stop_rounded;
      case TracearrPlaybackState.unknown:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracearrState = context.read<TracearrState>();
    final poster = tracearrState.resolveImageUrl(stream.posterUrl);
    return LunaBlock(
      title: _title,
      posterUrl: poster,
      posterHeaders: tracearrState.imageHeaders,
      posterPlaceholderIcon: Icons.live_tv_rounded,
      backgroundUrl: poster,
      backgroundHeaders: tracearrState.imageHeaders,
      body: [
        TextSpan(text: _subtitleLine1),
        const TextSpan(text: '\n'),
        TextSpan(text: _subtitleLine2),
      ],
      bottom: _progress != null
          ? LinearProgressIndicator(
              value: _progress,
              color: _stateColor,
              backgroundColor: Colors.white12,
              minHeight: 3,
            )
          : null,
      bottomHeight: 3,
      trailing: LunaIconButton(
        icon: _stateIcon,
        color: _stateColor,
      ),
      onTap: disableOnTap
          ? null
          : () => TracearrRoutes.STREAM_DETAILS.go(
                params: {'id': stream.id},
                extra: stream,
              ),
    );
  }
}

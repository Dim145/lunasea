import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';

const _dash = LunaUI.TEXT_EMDASH;

String _formatDuration(int? ms) {
  if (ms == null || ms <= 0) return _dash;
  final s = (ms / 1000).round();
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  if (h > 0) {
    return '${h}h ${m.toString().padLeft(2, '0')}m ${sec.toString().padLeft(2, '0')}s';
  }
  if (m > 0) return '${m}m ${sec.toString().padLeft(2, '0')}s';
  return '${sec}s';
}

/// Splits an ISO datetime into a (date, time) pair in the device's local time.
({String date, String time}) _splitIso(String? iso) {
  if (iso == null || iso.isEmpty) return (date: _dash, time: _dash);
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return (date: iso, time: _dash);
  String two(int n) => n.toString().padLeft(2, '0');
  final date = '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  final time = '${two(dt.hour)}:${two(dt.minute)}';
  return (date: date, time: time);
}

class TracearrHistoryMetadataBlock extends StatelessWidget {
  final TracearrSessionHistory item;
  const TracearrHistoryMetadataBlock({Key? key, required this.item})
      : super(key: key);

  String get _title {
    final parts = <String>[];
    if (item.mediaTitle != null) parts.add(item.mediaTitle!);
    if (item.mediaType == TracearrMediaType.episode &&
        item.seasonNumber != null &&
        item.episodeNumber != null) {
      parts.add('Season ${item.seasonNumber} • Episode ${item.episodeNumber}');
    }
    if (item.showTitle != null) parts.add(item.showTitle!);
    if (item.artistName != null) parts.add(item.artistName!);
    if (item.albumName != null) parts.add(item.albumName!);
    return parts.isEmpty ? _dash : parts.join('\n');
  }

  String get _status {
    if (item.watched == true) return 'Completed';
    if (item.state == TracearrPlaybackState.stopped) return 'Stopped';
    if (item.state == TracearrPlaybackState.paused) return 'Paused';
    if (item.state == TracearrPlaybackState.playing) return 'In progress';
    return _dash;
  }

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'Status', body: _status),
        LunaTableContent(title: 'Title', body: _title),
        if (item.year != null)
          LunaTableContent(title: 'Year', body: '${item.year}'),
        LunaTableContent(title: 'Server', body: item.serverName ?? _dash),
        LunaTableContent(title: 'User', body: item.user?.username ?? _dash),
      ],
    );
  }
}

class TracearrHistorySessionBlock extends StatelessWidget {
  final TracearrSessionHistory item;
  const TracearrHistorySessionBlock({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final started = _splitIso(item.startedAt);
    final stopped = _splitIso(item.stoppedAt);
    final paused = (item.durationMs != null &&
            item.totalDurationMs != null &&
            item.totalDurationMs! > item.durationMs!)
        ? item.totalDurationMs! - item.durationMs!
        : null;
    final segmentCount = item.segmentCount;
    return LunaTableCard(
      content: [
        LunaTableContent(
          title: 'State',
          body: item.state.value.toUpperCase(),
        ),
        LunaTableContent(title: 'Date', body: started.date),
        LunaTableContent(title: 'Started', body: started.time),
        LunaTableContent(title: 'Stopped', body: stopped.time),
        LunaTableContent(
          title: 'Watch Time',
          body: _formatDuration(item.durationMs),
        ),
        if (item.totalDurationMs != null)
          LunaTableContent(
            title: 'Media Length',
            body: _formatDuration(item.totalDurationMs),
          ),
        if (paused != null)
          LunaTableContent(title: 'Paused', body: _formatDuration(paused)),
        if (segmentCount != null && segmentCount > 1)
          LunaTableContent(title: 'Segments', body: '$segmentCount'),
      ],
    );
  }
}

class TracearrHistoryPlayerBlock extends StatelessWidget {
  final TracearrSessionHistory item;
  const TracearrHistoryPlayerBlock({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'Platform', body: item.platform ?? _dash),
        LunaTableContent(title: 'Product', body: item.product ?? _dash),
        LunaTableContent(title: 'Player', body: item.player ?? _dash),
        LunaTableContent(title: 'Device', body: item.device ?? _dash),
        LunaTableContent(
          title: 'Stream',
          body: item.isTranscode == true
              ? 'Transcode'
              : item.isTranscode == false
                  ? 'Direct Play'
                  : _dash,
        ),
        LunaTableContent(title: 'Resolution', body: item.resolution ?? _dash),
      ],
    );
  }
}

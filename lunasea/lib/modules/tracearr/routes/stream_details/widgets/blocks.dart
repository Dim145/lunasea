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
  return '${m}m ${sec.toString().padLeft(2, '0')}s';
}

String _formatBitrate(int? kbps) {
  if (kbps == null || kbps <= 0) return _dash;
  if (kbps >= 1000) return '${(kbps / 1000).toStringAsFixed(1)} Mbps';
  return '$kbps kbps';
}

class TracearrStreamMetadataBlock extends StatelessWidget {
  final TracearrStream stream;
  const TracearrStreamMetadataBlock({Key? key, required this.stream})
      : super(key: key);

  String get _title {
    final parts = <String>[];
    parts.add(stream.mediaTitle);
    if (stream.mediaType == TracearrMediaType.episode &&
        stream.seasonNumber != null &&
        stream.episodeNumber != null) {
      parts.add(
        'Season ${stream.seasonNumber} • Episode ${stream.episodeNumber}',
      );
    }
    if (stream.showTitle != null) parts.add(stream.showTitle!);
    if (stream.artistName != null) parts.add(stream.artistName!);
    if (stream.albumName != null) parts.add(stream.albumName!);
    return parts.join('\n');
  }

  String get _duration {
    final dur = _formatDuration(stream.durationMs);
    final prog = _formatDuration(stream.progressMs);
    if (stream.durationMs != null && stream.durationMs! > 0 &&
        stream.progressMs != null) {
      final pct = ((stream.progressMs! / stream.durationMs!) * 100)
          .clamp(0, 100)
          .toStringAsFixed(0);
      return '$prog / $dur ($pct%)';
    }
    return dur;
  }

  String get _eta {
    if (stream.durationMs == null ||
        stream.progressMs == null ||
        stream.durationMs! <= stream.progressMs!) return _dash;
    return _formatDuration(stream.durationMs! - stream.progressMs!);
  }

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'Title', body: _title),
        if (stream.year != null)
          LunaTableContent(title: 'Year', body: '${stream.year}'),
        LunaTableContent(title: 'Duration', body: _duration),
        LunaTableContent(title: 'ETA', body: _eta),
        LunaTableContent(title: 'Server', body: stream.serverName),
        LunaTableContent(title: 'User', body: stream.username),
      ],
    );
  }
}

class TracearrStreamPlayerBlock extends StatelessWidget {
  final TracearrStream stream;
  const TracearrStreamPlayerBlock({Key? key, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'Platform', body: stream.platform ?? _dash),
        LunaTableContent(title: 'Product', body: stream.product ?? _dash),
        LunaTableContent(title: 'Player', body: stream.player ?? _dash),
        LunaTableContent(title: 'Device', body: stream.device ?? _dash),
        LunaTableContent(title: 'Quality', body: _formatBitrate(stream.bitrate)),
      ],
    );
  }
}

class TracearrStreamStreamBlock extends StatelessWidget {
  final TracearrStream stream;
  const TracearrStreamStreamBlock({Key? key, required this.stream})
      : super(key: key);

  String _decision() {
    if (stream.isTranscode == true) return 'Transcode';
    if (stream.isTranscode == false) return 'Direct Play';
    return _dash;
  }

  String _video() {
    final src = stream.sourceVideoCodecDisplay ?? stream.sourceVideoCodec;
    final dst = stream.streamVideoCodecDisplay ?? stream.streamVideoCodec;
    if (src == null && dst == null) return _dash;
    if (src == dst || dst == null) return 'Direct Play (${src ?? _dash}${stream.resolution != null ? ' ${stream.resolution}' : ''})';
    return '$src → $dst${stream.resolution != null ? ' ${stream.resolution}' : ''}';
  }

  String _audio() {
    final src = stream.sourceAudioCodecDisplay ?? stream.sourceAudioCodec;
    final dst = stream.streamAudioCodecDisplay ?? stream.streamAudioCodec;
    final channels = stream.audioChannelsDisplay ??
        (stream.sourceAudioChannels != null
            ? '${stream.sourceAudioChannels} ch'
            : null);
    if (src == null && dst == null) return _dash;
    final base = (src == dst || dst == null)
        ? 'Direct Play (${src ?? _dash})'
        : '$src → $dst';
    return channels != null ? '$base • $channels' : base;
  }

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'State', body: stream.state.value.toUpperCase()),
        LunaTableContent(title: 'Bandwidth', body: _formatBitrate(stream.bitrate)),
        LunaTableContent(title: 'Stream', body: _decision()),
        LunaTableContent(title: 'Video', body: _video()),
        LunaTableContent(title: 'Audio', body: _audio()),
      ],
    );
  }
}

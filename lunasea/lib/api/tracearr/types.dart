library tracearr_types;

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum TracearrServerType {
  plex('plex'),
  jellyfin('jellyfin'),
  emby('emby'),
  unknown('unknown');

  final String value;
  const TracearrServerType(this.value);

  static TracearrServerType from(String? value) {
    for (final v in TracearrServerType.values) {
      if (v.value == value) return v;
    }
    return TracearrServerType.unknown;
  }
}

@JsonEnum(valueField: 'value')
enum TracearrMediaType {
  movie('movie'),
  episode('episode'),
  track('track'),
  live('live'),
  photo('photo'),
  unknown('unknown');

  final String value;
  const TracearrMediaType(this.value);

  static TracearrMediaType from(String? value) {
    for (final v in TracearrMediaType.values) {
      if (v.value == value) return v;
    }
    return TracearrMediaType.unknown;
  }
}

@JsonEnum(valueField: 'value')
enum TracearrPlaybackState {
  playing('playing'),
  paused('paused'),
  stopped('stopped'),
  unknown('unknown');

  final String value;
  const TracearrPlaybackState(this.value);

  static TracearrPlaybackState from(String? value) {
    for (final v in TracearrPlaybackState.values) {
      if (v.value == value) return v;
    }
    return TracearrPlaybackState.unknown;
  }
}

@JsonEnum(valueField: 'value')
enum TracearrSeverity {
  low('low'),
  warning('warning'),
  high('high'),
  unknown('unknown');

  final String value;
  const TracearrSeverity(this.value);

  static TracearrSeverity from(String? value) {
    for (final v in TracearrSeverity.values) {
      if (v.value == value) return v;
    }
    return TracearrSeverity.unknown;
  }
}

@JsonEnum(valueField: 'value')
enum TracearrUserRole {
  owner('owner'),
  admin('admin'),
  viewer('viewer'),
  member('member'),
  disabled('disabled'),
  pending('pending'),
  unknown('unknown');

  final String value;
  const TracearrUserRole(this.value);

  static TracearrUserRole from(String? value) {
    for (final v in TracearrUserRole.values) {
      if (v.value == value) return v;
    }
    return TracearrUserRole.unknown;
  }
}

@JsonEnum(valueField: 'value')
enum TracearrTranscodeDecision {
  directplay('directplay'),
  copy('copy'),
  transcode('transcode'),
  unknown('unknown');

  final String value;
  const TracearrTranscodeDecision(this.value);

  static TracearrTranscodeDecision from(String? value) {
    for (final v in TracearrTranscodeDecision.values) {
      if (v.value == value) return v;
    }
    return TracearrTranscodeDecision.unknown;
  }
}

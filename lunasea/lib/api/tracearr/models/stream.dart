import 'package:json_annotation/json_annotation.dart';
import 'package:lunasea/api/tracearr/types.dart';
import 'package:lunasea/api/tracearr/utils/converters.dart';

part 'stream.g.dart';

@JsonSerializable()
class TracearrStream {
  final String id;
  final String serverId;
  final String serverName;

  // User
  final String username;
  final String? userThumb;
  final String? userAvatarUrl;

  // Media
  final String mediaTitle;
  @JsonKey(unknownEnumValue: TracearrMediaType.unknown)
  final TracearrMediaType mediaType;
  final String? showTitle;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? seasonNumber;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? episodeNumber;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? year;
  final String? artistName;
  final String? albumName;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? trackNumber;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? discNumber;
  final String? thumbPath;
  final String? posterUrl;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? durationMs;

  // Playback
  @JsonKey(unknownEnumValue: TracearrPlaybackState.unknown)
  final TracearrPlaybackState state;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? progressMs;
  final String startedAt;

  // Stream details
  final bool? isTranscode;
  @JsonKey(unknownEnumValue: TracearrTranscodeDecision.unknown)
  final TracearrTranscodeDecision? videoDecision;
  @JsonKey(unknownEnumValue: TracearrTranscodeDecision.unknown)
  final TracearrTranscodeDecision? audioDecision;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? bitrate;
  final String? sourceVideoCodec;
  final String? sourceAudioCodec;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? sourceAudioChannels;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? sourceVideoWidth;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? sourceVideoHeight;
  final String? streamVideoCodec;
  final String? streamAudioCodec;
  final Map<String, dynamic>? sourceVideoDetails;
  final Map<String, dynamic>? sourceAudioDetails;
  final Map<String, dynamic>? streamVideoDetails;
  final Map<String, dynamic>? streamAudioDetails;
  final Map<String, dynamic>? transcodeInfo;
  final Map<String, dynamic>? subtitleInfo;

  // Display values (server-computed)
  final String? resolution;
  final String? sourceVideoCodecDisplay;
  final String? sourceAudioCodecDisplay;
  final String? audioChannelsDisplay;
  final String? streamVideoCodecDisplay;
  final String? streamAudioCodecDisplay;

  // Device
  final String? device;
  final String? player;
  final String? product;
  final String? platform;

  const TracearrStream({
    required this.id,
    required this.serverId,
    required this.serverName,
    required this.username,
    this.userThumb,
    this.userAvatarUrl,
    required this.mediaTitle,
    required this.mediaType,
    this.showTitle,
    this.seasonNumber,
    this.episodeNumber,
    this.year,
    this.artistName,
    this.albumName,
    this.trackNumber,
    this.discNumber,
    this.thumbPath,
    this.posterUrl,
    this.durationMs,
    required this.state,
    this.progressMs,
    required this.startedAt,
    this.isTranscode,
    this.videoDecision,
    this.audioDecision,
    this.bitrate,
    this.sourceVideoCodec,
    this.sourceAudioCodec,
    this.sourceAudioChannels,
    this.sourceVideoWidth,
    this.sourceVideoHeight,
    this.streamVideoCodec,
    this.streamAudioCodec,
    this.sourceVideoDetails,
    this.sourceAudioDetails,
    this.streamVideoDetails,
    this.streamAudioDetails,
    this.transcodeInfo,
    this.subtitleInfo,
    this.resolution,
    this.sourceVideoCodecDisplay,
    this.sourceAudioCodecDisplay,
    this.audioChannelsDisplay,
    this.streamVideoCodecDisplay,
    this.streamAudioCodecDisplay,
    this.device,
    this.player,
    this.product,
    this.platform,
  });

  factory TracearrStream.fromJson(Map<String, dynamic> json) =>
      _$TracearrStreamFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrStreamToJson(this);
}

@JsonSerializable()
class TracearrServerStreamSummary {
  final String serverId;
  final String serverName;
  final int total;
  final int transcodes;
  final int directStreams;
  final int directPlays;
  final String totalBitrate;

  const TracearrServerStreamSummary({
    required this.serverId,
    required this.serverName,
    required this.total,
    required this.transcodes,
    required this.directStreams,
    required this.directPlays,
    required this.totalBitrate,
  });

  factory TracearrServerStreamSummary.fromJson(Map<String, dynamic> json) =>
      _$TracearrServerStreamSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrServerStreamSummaryToJson(this);
}

@JsonSerializable()
class TracearrStreamsSummary {
  final int total;
  final int transcodes;
  final int directStreams;
  final int directPlays;
  final String totalBitrate;
  final List<TracearrServerStreamSummary> byServer;

  const TracearrStreamsSummary({
    required this.total,
    required this.transcodes,
    required this.directStreams,
    required this.directPlays,
    required this.totalBitrate,
    required this.byServer,
  });

  factory TracearrStreamsSummary.fromJson(Map<String, dynamic> json) =>
      _$TracearrStreamsSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrStreamsSummaryToJson(this);
}

@JsonSerializable()
class TracearrStreamsResponse {
  final List<TracearrStream> data;
  final TracearrStreamsSummary summary;

  const TracearrStreamsResponse({
    required this.data,
    required this.summary,
  });

  factory TracearrStreamsResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrStreamsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrStreamsResponseToJson(this);
}

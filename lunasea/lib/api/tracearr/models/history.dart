import 'package:json_annotation/json_annotation.dart';
import 'package:lunasea/api/tracearr/types.dart';
import 'package:lunasea/api/tracearr/models/pagination.dart';
import 'package:lunasea/api/tracearr/models/user.dart';
import 'package:lunasea/api/tracearr/utils/converters.dart';

part 'history.g.dart';

@JsonSerializable()
class TracearrSessionHistory {
  final String? id;
  final String? serverId;
  final String? serverName;
  @JsonKey(unknownEnumValue: TracearrPlaybackState.unknown)
  final TracearrPlaybackState state;

  // Media
  final String? mediaTitle;
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
  final String? thumbPath;
  final String? posterUrl;

  // Timing (durations in ms can arrive as strings — large numbers)
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? durationMs;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? progressMs;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? totalDurationMs;
  final String? startedAt;
  final String? stoppedAt;
  final bool? watched;
  @JsonKey(fromJson: intFromJson, toJson: intToJson)
  final int? segmentCount;

  // Device
  final String? device;
  final String? player;
  final String? product;
  final String? platform;

  // Stream details (lightweight)
  final bool? isTranscode;
  final String? resolution;

  // User
  final TracearrUserInfo? user;

  const TracearrSessionHistory({
    this.id,
    this.serverId,
    this.serverName,
    required this.state,
    this.mediaTitle,
    required this.mediaType,
    this.showTitle,
    this.seasonNumber,
    this.episodeNumber,
    this.year,
    this.artistName,
    this.albumName,
    this.thumbPath,
    this.posterUrl,
    this.durationMs,
    this.progressMs,
    this.totalDurationMs,
    this.startedAt,
    this.stoppedAt,
    this.watched,
    this.segmentCount,
    this.device,
    this.player,
    this.product,
    this.platform,
    this.isTranscode,
    this.resolution,
    this.user,
  });

  factory TracearrSessionHistory.fromJson(Map<String, dynamic> json) =>
      _$TracearrSessionHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrSessionHistoryToJson(this);
}

@JsonSerializable()
class TracearrHistoryResponse {
  final List<TracearrSessionHistory> data;
  final TracearrPaginationMeta meta;

  const TracearrHistoryResponse({
    required this.data,
    required this.meta,
  });

  factory TracearrHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrHistoryResponseToJson(this);
}

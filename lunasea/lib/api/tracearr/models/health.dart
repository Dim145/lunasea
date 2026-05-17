import 'package:json_annotation/json_annotation.dart';
import 'package:lunasea/api/tracearr/types.dart';

part 'health.g.dart';

@JsonSerializable()
class TracearrServerStatus {
  final String id;
  final String name;
  @JsonKey(unknownEnumValue: TracearrServerType.unknown)
  final TracearrServerType type;
  final bool online;
  final int activeStreams;

  const TracearrServerStatus({
    required this.id,
    required this.name,
    required this.type,
    required this.online,
    required this.activeStreams,
  });

  factory TracearrServerStatus.fromJson(Map<String, dynamic> json) =>
      _$TracearrServerStatusFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrServerStatusToJson(this);
}

@JsonSerializable()
class TracearrHealthResponse {
  final String status;
  final String version;
  final String timestamp;
  final List<TracearrServerStatus> servers;

  const TracearrHealthResponse({
    required this.status,
    required this.version,
    required this.timestamp,
    required this.servers,
  });

  factory TracearrHealthResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrHealthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrHealthResponseToJson(this);
}

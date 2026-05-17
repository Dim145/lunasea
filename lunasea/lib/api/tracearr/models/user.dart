import 'package:json_annotation/json_annotation.dart';
import 'package:lunasea/api/tracearr/types.dart';
import 'package:lunasea/api/tracearr/models/pagination.dart';

part 'user.g.dart';

@JsonSerializable()
class TracearrUserInfo {
  final String id;
  final String username;
  final String? thumbUrl;
  final String? avatarUrl;

  const TracearrUserInfo({
    required this.id,
    required this.username,
    this.thumbUrl,
    this.avatarUrl,
  });

  factory TracearrUserInfo.fromJson(Map<String, dynamic> json) =>
      _$TracearrUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrUserInfoToJson(this);
}

@JsonSerializable()
class TracearrUser {
  final String id;
  final String username;
  final String displayName;
  final String? thumbUrl;
  final String? avatarUrl;
  @JsonKey(unknownEnumValue: TracearrUserRole.unknown)
  final TracearrUserRole role;
  final int trustScore;
  final int totalViolations;
  final String serverId;
  final String serverName;
  final String? lastActivityAt;
  final int sessionCount;
  final String createdAt;

  const TracearrUser({
    required this.id,
    required this.username,
    required this.displayName,
    this.thumbUrl,
    this.avatarUrl,
    required this.role,
    required this.trustScore,
    required this.totalViolations,
    required this.serverId,
    required this.serverName,
    this.lastActivityAt,
    required this.sessionCount,
    required this.createdAt,
  });

  factory TracearrUser.fromJson(Map<String, dynamic> json) =>
      _$TracearrUserFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrUserToJson(this);
}

@JsonSerializable()
class TracearrUsersResponse {
  final List<TracearrUser> data;
  final TracearrPaginationMeta meta;

  const TracearrUsersResponse({
    required this.data,
    required this.meta,
  });

  factory TracearrUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrUsersResponseToJson(this);
}

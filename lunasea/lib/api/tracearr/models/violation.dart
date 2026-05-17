import 'package:json_annotation/json_annotation.dart';
import 'package:lunasea/api/tracearr/types.dart';
import 'package:lunasea/api/tracearr/models/pagination.dart';
import 'package:lunasea/api/tracearr/models/user.dart';

part 'violation.g.dart';

@JsonSerializable()
class TracearrViolationRule {
  final String? id;
  final String? type;
  final String? name;

  const TracearrViolationRule({
    this.id,
    this.type,
    this.name,
  });

  factory TracearrViolationRule.fromJson(Map<String, dynamic> json) =>
      _$TracearrViolationRuleFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrViolationRuleToJson(this);
}

@JsonSerializable()
class TracearrViolation {
  final String? id;
  final String? serverId;
  final String? serverName;
  @JsonKey(unknownEnumValue: TracearrSeverity.unknown)
  final TracearrSeverity severity;
  final bool? acknowledged;
  final Map<String, dynamic>? data;
  final String? createdAt;
  final TracearrViolationRule? rule;
  final TracearrUserInfo? user;

  const TracearrViolation({
    this.id,
    this.serverId,
    this.serverName,
    required this.severity,
    this.acknowledged,
    this.data,
    this.createdAt,
    this.rule,
    this.user,
  });

  factory TracearrViolation.fromJson(Map<String, dynamic> json) =>
      _$TracearrViolationFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrViolationToJson(this);
}

@JsonSerializable()
class TracearrViolationsResponse {
  final List<TracearrViolation> data;
  final TracearrPaginationMeta meta;

  const TracearrViolationsResponse({
    required this.data,
    required this.meta,
  });

  factory TracearrViolationsResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrViolationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrViolationsResponseToJson(this);
}

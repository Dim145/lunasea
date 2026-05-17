import 'package:json_annotation/json_annotation.dart';

part 'terminate.g.dart';

@JsonSerializable()
class TracearrTerminateStreamBody {
  final String? reason;

  const TracearrTerminateStreamBody({this.reason});

  factory TracearrTerminateStreamBody.fromJson(Map<String, dynamic> json) =>
      _$TracearrTerminateStreamBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrTerminateStreamBodyToJson(this);
}

@JsonSerializable()
class TracearrTerminateStreamResponse {
  final bool success;
  final String? terminationLogId;
  final String? message;
  final String? error;

  const TracearrTerminateStreamResponse({
    required this.success,
    this.terminationLogId,
    this.message,
    this.error,
  });

  factory TracearrTerminateStreamResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrTerminateStreamResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrTerminateStreamResponseToJson(this);
}

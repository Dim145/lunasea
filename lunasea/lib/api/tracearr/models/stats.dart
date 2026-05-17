import 'package:json_annotation/json_annotation.dart';

part 'stats.g.dart';

@JsonSerializable()
class TracearrStatsResponse {
  final int activeStreams;
  final int totalUsers;
  final int totalSessions;
  final int recentViolations;
  final String timestamp;

  const TracearrStatsResponse({
    required this.activeStreams,
    required this.totalUsers,
    required this.totalSessions,
    required this.recentViolations,
    required this.timestamp,
  });

  factory TracearrStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrStatsResponseToJson(this);
}

@JsonSerializable()
class TracearrStatsTodayResponse {
  final int activeStreams;
  final int todayPlays;
  final double watchTimeHours;
  final int alertsLast24h;
  final int activeUsersToday;
  final String timestamp;

  const TracearrStatsTodayResponse({
    required this.activeStreams,
    required this.todayPlays,
    required this.watchTimeHours,
    required this.alertsLast24h,
    required this.activeUsersToday,
    required this.timestamp,
  });

  factory TracearrStatsTodayResponse.fromJson(Map<String, dynamic> json) =>
      _$TracearrStatsTodayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrStatsTodayResponseToJson(this);
}

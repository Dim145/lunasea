import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:lunasea/api/tracearr/models.dart';

part 'api.g.dart';

/// Retrofit client for Tracearr's public REST API.
///
/// All endpoints require a Bearer token (`trr_pub_<token>`) which is
/// injected via the Dio `Authorization` header by [TracearrAPI].
@RestApi()
abstract class TracearrService {
  factory TracearrService(Dio dio, {String baseUrl}) = _TracearrService;

  @GET('/health')
  Future<TracearrHealthResponse> health();

  @GET('/stats')
  Future<TracearrStatsResponse> stats({@Query('serverId') String? serverId});

  @GET('/stats/today')
  Future<TracearrStatsTodayResponse> statsToday({
    @Query('serverId') String? serverId,
    @Query('timezone') String? timezone,
  });

  @GET('/streams')
  Future<TracearrStreamsResponse> streams({
    @Query('serverId') String? serverId,
  });

  @POST('/streams/{id}/terminate')
  Future<TracearrTerminateStreamResponse> terminateStream(
    @Path('id') String id,
    @Body() TracearrTerminateStreamBody body,
  );

  @GET('/users')
  Future<TracearrUsersResponse> users({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('serverId') String? serverId,
  });

  @GET('/violations')
  Future<TracearrViolationsResponse> violations({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('serverId') String? serverId,
    @Query('severity') String? severity,
    @Query('acknowledged') bool? acknowledged,
  });

  @GET('/history')
  Future<TracearrHistoryResponse> history({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('serverId') String? serverId,
    @Query('state') String? state,
    @Query('mediaType') String? mediaType,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('timezone') String? timezone,
  });
}

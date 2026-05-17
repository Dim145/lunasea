/// Dart library for Tracearr's public REST API.
///
/// Tracearr (https://tracearr.com) is a unified monitoring platform for
/// Plex, Jellyfin and Emby. This library wraps its `/api/v1/public/*`
/// endpoints behind a small Retrofit interface.
library tracearr;

import 'package:dio/dio.dart';
import 'package:lunasea/api/tracearr/api.dart';

export 'package:lunasea/api/tracearr/api.dart';
export 'package:lunasea/api/tracearr/models.dart';
export 'package:lunasea/api/tracearr/types.dart';

/// Connection manager for a single Tracearr instance.
///
/// Creates a configured [Dio] client with Bearer auth and a [TracearrService]
/// (Retrofit-generated client). Use `.service` to make calls.
class TracearrAPI {
  TracearrAPI._internal({
    required this.httpClient,
    required this.service,
  });

  /// Build a [TracearrAPI] for the given host + API token.
  ///
  /// - `host`: protocol + host (and optional base path), e.g.
  ///   `https://tracearr.example.com`. Trailing slash is normalized.
  /// - `apiKey`: a `trr_pub_<token>` token generated in Settings > General.
  /// - `headers`: extra headers attached to every request (forwarded from
  ///   the user's per-profile config).
  factory TracearrAPI({
    required String host,
    required String apiKey,
    Map<String, dynamic>? headers,
    bool followRedirects = true,
    int maxRedirects = 5,
  }) {
    final cleanHost = host.endsWith('/') ? host.substring(0, host.length - 1) : host;
    final baseUrl = '$cleanHost/api/v1/public';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        headers: {
          ...?headers,
          if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
        },
      ),
    );

    return TracearrAPI._internal(
      httpClient: dio,
      service: TracearrService(dio),
    );
  }

  /// Build a [TracearrAPI] from a pre-configured [Dio] client. The caller
  /// is responsible for setting `baseUrl` to `<host>/api/v1/public` and
  /// injecting the `Authorization: Bearer <token>` header.
  factory TracearrAPI.from({required Dio client}) {
    return TracearrAPI._internal(
      httpClient: client,
      service: TracearrService(client),
    );
  }

  /// The underlying Dio HTTP client.
  final Dio httpClient;

  /// Retrofit-generated service exposing all Tracearr public endpoints.
  final TracearrService service;
}

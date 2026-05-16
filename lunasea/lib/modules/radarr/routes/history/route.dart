import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class HistoryRoute extends StatefulWidget {
  const HistoryRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryRoute> createState() => _State();
}

class _State extends State<HistoryRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late final PagingController<int, RadarrHistoryRecord> _pagingController =
      PagingController<int, RadarrHistoryRecord>(
    getNextPageKey: (state) {
      if (state.keys == null) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.isEmpty) return null;
      if (lastPage.length < RadarrDatabase.CONTENT_PAGE_SIZE.read()) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) => _fetchPage(pageKey),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<RadarrHistoryRecord>> _fetchPage(int pageKey) async {
    try {
      final data = await context.read<RadarrState>().api!.history.get(
            page: pageKey,
            pageSize: RadarrDatabase.CONTENT_PAGE_SIZE.read(),
            sortKey: RadarrHistorySortKey.DATE,
            sortDirection: RadarrSortDirection.DESCENDING,
          );
      return data.records ?? <RadarrHistoryRecord>[];
    } catch (error, stack) {
      LunaLogger().error(
        'Unable to fetch Radarr history page: $pageKey',
        error,
        stack,
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      title: 'radarr.History'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: context.watch<RadarrState>().movies,
      builder: (context, AsyncSnapshot<List<RadarrMovie>> snapshot) {
        if (snapshot.hasError) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            LunaLogger().error(
              'Unable to fetch Radarr movies for history list',
              snapshot.error,
              snapshot.stackTrace,
            );
          }
          return LunaMessage.error(
            onTap: () => Future.sync(_pagingController.refresh),
          );
        }
        if (snapshot.hasData) return _paginatedList(snapshot.data);
        return const LunaLoader();
      },
    );
  }

  Widget _paginatedList(List<RadarrMovie>? movies) {
    return LunaPagedListView<RadarrHistoryRecord>(
      refreshKey: _refreshKey,
      pagingController: _pagingController,
      scrollController: scrollController,
      noItemsFoundMessage: 'radarr.NoHistoryFound'.tr(),
      itemBuilder: (context, history, index) {
        RadarrMovie? _movie = movies!.firstWhereOrNull(
          (movie) => movie.id == history.movieId,
        );
        return RadarrHistoryTile(
          history: history,
          title: _movie!.title!,
        );
      },
    );
  }
}

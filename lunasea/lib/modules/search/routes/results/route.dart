import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/search.dart';
import 'package:lunasea/router/routes/search.dart';
import 'package:lunasea/widgets/sheets/download_client/button.dart';

class ResultsRoute extends StatefulWidget {
  const ResultsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ResultsRoute> createState() => _State();
}

class _State extends State<ResultsRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late final PagingController<int, NewznabResultData> _pagingController =
      PagingController<int, NewznabResultData>(
    getNextPageKey: (state) {
      if (state.keys == null) return 0;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.isEmpty) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) => _fetchPage(pageKey),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<NewznabResultData>> _fetchPage(int pageKey) async {
    try {
      NewznabCategoryData? category =
          context.read<SearchState>().activeCategory;
      NewznabSubcategoryData? subcategory =
          context.read<SearchState>().activeSubcategory;
      return await context.read<SearchState>().api.getResults(
            categoryId: subcategory?.id ?? category?.id,
            offset: pageKey,
          );
    } catch (error, stack) {
      LunaLogger().error(
        'Unable to fetch search results page: $pageKey',
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
    String? title = 'search.Results'.tr();
    NewznabCategoryData? category = context.read<SearchState>().activeCategory;
    NewznabSubcategoryData? subcategory =
        context.read<SearchState>().activeSubcategory;
    if (category != null) title = category.name;
    if (category != null && subcategory != null) {
      title = '$title > ${subcategory.name ?? 'lunasea.Unknown'.tr()}';
    }
    return LunaAppBar(
      title: title!,
      actions: [
        const DownloadClientButton(),
        LunaIconButton(
          icon: Icons.search_rounded,
          onPressed: () => SearchRoutes.SEARCH.go(),
        ),
      ],
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaPagedListView<NewznabResultData>(
      refreshKey: _refreshKey,
      pagingController: _pagingController,
      scrollController: scrollController,
      noItemsFoundMessage: 'search.NoResultsFound'.tr(),
      itemBuilder: (context, result, index) => SearchResultTile(data: result),
    );
  }
}

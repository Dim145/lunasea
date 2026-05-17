import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/database/models/profile.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/history/route.dart';
import 'package:lunasea/modules/tracearr/routes/home/widgets/navigation_bar.dart';
import 'package:lunasea/modules/tracearr/routes/streams/route.dart';
import 'package:lunasea/modules/tracearr/routes/users/route.dart';
import 'package:lunasea/modules/tracearr/routes/violations/route.dart';

class TracearrRoute extends StatefulWidget {
  const TracearrRoute({Key? key}) : super(key: key);

  @override
  State<TracearrRoute> createState() => _State();
}

class _State extends State<TracearrRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: TracearrDatabase.NAVIGATION_INDEX.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.TRACEARR,
      drawer: LunaDrawer(page: LunaModule.TRACEARR.key),
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  Widget? _bottomNavigationBar() {
    if (!context.read<TracearrState>().enabled) return null;
    return TracearrNavigationBar(pageController: _pageController);
  }

  PreferredSizeWidget _appBar() {
    final profiles = LunaBox.profiles.keys.fold<List<String>>([], (acc, key) {
      if (LunaBox.profiles.read(key)?.tracearrEnabled ?? false) {
        acc.add(key as String);
      }
      return acc;
    });
    return LunaAppBar.dropdown(
      title: LunaModule.TRACEARR.title,
      useDrawer: true,
      profiles: profiles,
      pageController: _pageController,
      scrollControllers: TracearrNavigationBar.scrollControllers,
    );
  }

  Widget _body() {
    return Selector<TracearrState, bool>(
      selector: (_, state) => state.enabled,
      builder: (context, enabled, _) {
        if (!enabled) {
          return LunaMessage.moduleNotEnabled(
            context: context,
            module: LunaModule.TRACEARR.title,
          );
        }
        return LunaPageView(
          controller: _pageController,
          children: const [
            TracearrStreamsRoute(),
            TracearrHistoryRoute(),
            TracearrUsersRoute(),
            TracearrViolationsRoute(),
          ],
        );
      },
    );
  }
}

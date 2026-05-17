import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';

class TracearrNavigationBar extends StatefulWidget {
  final PageController? pageController;

  /// One scroll controller per tab. Shared with the parent app bar so the
  /// "scroll to top" affordance hits the right list when the user taps the
  /// app bar.
  static List<ScrollController> scrollControllers =
      List.generate(icons.length, (_) => ScrollController());

  /// Tabs are: Streams (default, index 0), History, Users, Violations.
  static const List<IconData> icons = [
    Icons.play_arrow_rounded,
    Icons.history_rounded,
    Icons.people_rounded,
    Icons.warning_amber_rounded,
  ];

  static List<String> get titles => [
        'tracearr.Streams'.tr(),
        'tracearr.History'.tr(),
        'tracearr.Users'.tr(),
        'tracearr.Violations'.tr(),
      ];

  const TracearrNavigationBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<TracearrNavigationBar> createState() => _State();
}

class _State extends State<TracearrNavigationBar> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.pageController?.initialPage ?? 0;
    widget.pageController?.addListener(_pageControllerListener);
  }

  @override
  void dispose() {
    widget.pageController?.removeListener(_pageControllerListener);
    super.dispose();
  }

  void _pageControllerListener() {
    final next = widget.pageController?.page?.round() ?? _index;
    if (next == _index) return;
    setState(() => _index = next);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TracearrState>();
    final count = state.activeStreamCount;
    return LunaBottomNavigationBar(
      pageController: widget.pageController,
      scrollControllers: TracearrNavigationBar.scrollControllers,
      icons: TracearrNavigationBar.icons,
      titles: TracearrNavigationBar.titles,
      leadingOnTab: [
        LunaNavigationBarBadge(
          text: count.toString(),
          icon: TracearrNavigationBar.icons[0],
          isActive: _index == 0,
          showBadge: state.enabled && _index != 0 && count > 0,
        ),
        null,
        null,
        null,
      ],
    );
  }
}

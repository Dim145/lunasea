import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/user_details/widgets/blocks.dart';

class TracearrUserDetailsRoute extends StatefulWidget {
  final TracearrUser user;

  const TracearrUserDetailsRoute({Key? key, required this.user})
      : super(key: key);

  @override
  State<TracearrUserDetailsRoute> createState() => _State();
}

class _State extends State<TracearrUserDetailsRoute>
    with LunaScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final tracearrState = context.read<TracearrState>();
    final title = user.displayName.isEmpty ? user.username : user.displayName;
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: LunaAppBar(
        title: 'User Details',
        scrollControllers: [scrollController],
      ),
      body: LunaListView(
        controller: scrollController,
        children: [
          LunaBlock(
            title: title,
            posterUrl: tracearrState.resolveImageUrl(user.avatarUrl),
            posterHeaders: tracearrState.imageHeaders,
            posterPlaceholderIcon: Icons.person_rounded,
            posterIsSquare: true,
            body: [
              TextSpan(
                text: '${user.serverName} • ${user.role.value}\n',
              ),
              TextSpan(
                text: '${user.sessionCount} sessions • '
                    'Trust ${user.trustScore} • '
                    '${user.totalViolations} violations',
              ),
            ],
          ),
          LunaHeader(text: 'Profile'),
          TracearrUserProfileBlock(user: user),
          LunaHeader(text: 'Stats'),
          TracearrUserStatsBlock(user: user),
        ],
      ),
    );
  }
}

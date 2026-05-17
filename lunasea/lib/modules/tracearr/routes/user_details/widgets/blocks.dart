import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';

const _dash = LunaUI.TEXT_EMDASH;

String _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return _dash;
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
}

String _relativeAgo(String? iso) {
  if (iso == null || iso.isEmpty) return _dash;
  final dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  final delta = DateTime.now().difference(dt);
  if (delta.inDays >= 365) return '${(delta.inDays / 365).floor()} year(s) ago';
  if (delta.inDays >= 30) return '${(delta.inDays / 30).floor()} month(s) ago';
  if (delta.inDays >= 1) return '${delta.inDays} day(s) ago';
  if (delta.inHours >= 1) return '${delta.inHours} hour(s) ago';
  if (delta.inMinutes >= 1) return '${delta.inMinutes} minute(s) ago';
  return 'Just now';
}

class TracearrUserProfileBlock extends StatelessWidget {
  final TracearrUser user;
  const TracearrUserProfileBlock({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(
          title: 'Username',
          body: user.username,
        ),
        if (user.displayName.isNotEmpty && user.displayName != user.username)
          LunaTableContent(title: 'Display Name', body: user.displayName),
        LunaTableContent(title: 'Role', body: user.role.value.toUpperCase()),
        LunaTableContent(title: 'Server', body: user.serverName),
        LunaTableContent(title: 'Member Since', body: _formatDate(user.createdAt)),
        LunaTableContent(
          title: 'Last Active',
          body: _relativeAgo(user.lastActivityAt),
        ),
      ],
    );
  }
}

class TracearrUserStatsBlock extends StatelessWidget {
  final TracearrUser user;
  const TracearrUserStatsBlock({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(
          title: 'Sessions',
          body: '${user.sessionCount}',
        ),
        LunaTableContent(
          title: 'Trust Score',
          body: '${user.trustScore} / 100',
        ),
        LunaTableContent(
          title: 'Violations',
          body: '${user.totalViolations}',
        ),
      ],
    );
  }
}

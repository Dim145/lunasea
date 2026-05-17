import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';
import 'package:lunasea/modules/tracearr.dart';
import 'package:lunasea/modules/tracearr/routes/home/widgets/navigation_bar.dart';

class TracearrViolationsRoute extends StatefulWidget {
  const TracearrViolationsRoute({Key? key}) : super(key: key);

  @override
  State<TracearrViolationsRoute> createState() => _State();
}

class _State extends State<TracearrViolationsRoute>
    with AutomaticKeepAliveClientMixin, LunaLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<TracearrViolationsResponse>? _future;

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    await _reload();
  }

  Future<void> _reload() async {
    final api = context.read<TracearrState>().api;
    if (api == null) return;
    setState(() => _future = api.service.violations(page: 1, pageSize: 50));
    await _future;
  }

  Color _severityColor(TracearrSeverity severity) {
    switch (severity) {
      case TracearrSeverity.high:
        return LunaColours.red;
      case TracearrSeverity.warning:
        return LunaColours.orange;
      case TracearrSeverity.low:
        return LunaColours.blue;
      case TracearrSeverity.unknown:
        return Colors.grey;
    }
  }

  IconData _severityIcon(TracearrSeverity severity) {
    switch (severity) {
      case TracearrSeverity.high:
        return Icons.error_rounded;
      case TracearrSeverity.warning:
        return Icons.warning_amber_rounded;
      case TracearrSeverity.low:
        return Icons.info_outline_rounded;
      case TracearrSeverity.unknown:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      module: LunaModule.TRACEARR,
      body: LunaRefreshIndicator(
        context: context,
        key: _refreshKey,
        onRefresh: _reload,
        child: FutureBuilder<TracearrViolationsResponse>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                LunaLogger().error(
                  'Unable to fetch Tracearr violations',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return LunaMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (!snapshot.hasData) return const LunaLoader();
            if (snapshot.data!.data.isEmpty) {
              return LunaMessage(
                text: 'tracearr.NoViolationsFound'.tr(),
                buttonText: 'lunasea.Refresh'.tr(),
                onTap: _refreshKey.currentState!.show,
              );
            }
            return LunaListView(
              controller: TracearrNavigationBar.scrollControllers[3],
              children: snapshot.data!.data.map(_tile).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _tile(TracearrViolation v) {
    final ruleName = v.rule?.name ?? 'Unknown rule';
    final ruleType = v.rule?.type ?? '';
    final username = v.user?.username ?? 'Unknown user';
    final serverName = v.serverName ?? 'All servers';
    return LunaBlock(
      title: ruleName,
      body: [
        TextSpan(text: '$username • $serverName\n'),
        TextSpan(
          text: '${v.severity.value.toUpperCase()}${ruleType.isEmpty ? '' : ' • $ruleType'}',
        ),
        if (v.acknowledged == true) const TextSpan(text: ' • Acknowledged'),
      ],
      trailing: LunaIconButton(
        icon: _severityIcon(v.severity),
        color: _severityColor(v.severity),
      ),
    );
  }
}

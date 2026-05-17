import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lunasea/core.dart';
import 'package:lunasea/system/webhooks.dart';

class ConfigurationNotificationsRoute extends StatefulWidget {
  const ConfigurationNotificationsRoute({Key? key}) : super(key: key);

  @override
  State<ConfigurationNotificationsRoute> createState() => _State();
}

class _State extends State<ConfigurationNotificationsRoute>
    with LunaScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'Notifications',
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaBox.lunasea.listenableBuilder(
      selectItems: [
        LunaSeaDatabase.NOTIFICATIONS_SERVICE_URL,
        LunaSeaDatabase.NOTIFICATIONS_TOPIC,
        LunaSeaDatabase.NOTIFICATIONS_TOKEN,
      ],
      builder: (context, _) => LunaListView(
        controller: scrollController,
        children: [
          LunaHeader(text: 'Service'),
          _serviceUrlTile(),
          _topicTile(),
          _tokenTile(),
          LunaHeader(text: 'Webhook URLs'),
          ..._urlsList(),
        ],
      ),
    );
  }

  Widget _serviceUrlTile() {
    const db = LunaSeaDatabase.NOTIFICATIONS_SERVICE_URL;
    final value = db.read();
    return LunaBlock(
      title: 'Service URL',
      body: [
        TextSpan(
          text: value.isEmpty
              ? 'Tap to configure (e.g. https://notifications.example.com)'
              : value,
        ),
      ],
      trailing: const LunaIconButton(icon: Icons.dns_rounded),
      onTap: () async {
        final result = await LunaDialogs().editText(
          context,
          'Service URL',
          prefill: value,
        );
        if (result.item1) db.update(result.item2.trim());
      },
    );
  }

  Widget _topicTile() {
    const db = LunaSeaDatabase.NOTIFICATIONS_TOPIC;
    final value = db.read();
    return LunaBlock(
      title: 'Topic',
      body: [
        TextSpan(
          text: value.isEmpty ? 'Tap to configure (e.g. lunasea-myname-7f3c)' : value,
        ),
      ],
      trailing: const LunaIconButton(icon: Icons.tag_rounded),
      onTap: () async {
        final result = await LunaDialogs().editText(
          context,
          'Topic',
          prefill: value,
        );
        if (result.item1) db.update(result.item2.trim());
      },
    );
  }

  Widget _tokenTile() {
    const db = LunaSeaDatabase.NOTIFICATIONS_TOKEN;
    final value = db.read();
    return LunaBlock(
      title: 'Webhook Token (optional)',
      body: [
        TextSpan(
          text: value.isEmpty
              ? 'Tap to set (matches WEBHOOK_TOKEN on the service)'
              : '*' * value.length.clamp(0, 24),
        ),
      ],
      trailing: const LunaIconButton(icon: Icons.key_rounded),
      onTap: () async {
        final result = await LunaDialogs().editText(
          context,
          'Webhook Token',
          prefill: value,
        );
        if (result.item1) db.update(result.item2.trim());
      },
    );
  }

  List<Widget> _urlsList() {
    final modules = LunaWebhooks.supportedModules.toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    return modules.map(_urlTile).toList();
  }

  Widget _urlTile(LunaModule module) {
    final url = LunaWebhooks.buildTopicURL(module);
    return LunaBlock(
      title: module.title,
      body: [
        TextSpan(text: url ?? 'Configure Service URL and Topic above first'),
      ],
      trailing: LunaIconButton(
        icon: url == null ? Icons.warning_rounded : Icons.copy_rounded,
        color: url == null ? LunaColours.orange : LunaColours.accent,
      ),
      onTap: url == null
          ? null
          : () async {
              await Clipboard.setData(ClipboardData(text: url));
              showLunaSuccessSnackBar(
                title: 'Copied',
                message: '${module.title} webhook URL copied to clipboard',
              );
            },
    );
  }
}

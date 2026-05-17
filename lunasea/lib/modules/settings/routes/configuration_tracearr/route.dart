import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';

class ConfigurationTracearrRoute extends StatefulWidget {
  const ConfigurationTracearrRoute({Key? key}) : super(key: key);

  @override
  State<ConfigurationTracearrRoute> createState() => _State();
}

class _State extends State<ConfigurationTracearrRoute>
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
      title: LunaModule.TRACEARR.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        LunaModule.TRACEARR.informationBanner(),
        _enabledToggle(),
        _hostTile(),
        _apiKeyTile(),
      ],
    );
  }

  Widget _enabledToggle() {
    return LunaBox.profiles.listenableBuilder(
      builder: (context, _) => LunaBlock(
        title: 'settings.EnableModule'.tr(args: [LunaModule.TRACEARR.title]),
        trailing: LunaSwitch(
          value: LunaProfile.current.tracearrEnabled,
          onChanged: (value) {
            LunaProfile.current.tracearrEnabled = value;
            LunaProfile.current.save();
            context.read<TracearrState>().reset();
          },
        ),
      ),
    );
  }

  Widget _hostTile() {
    return LunaBox.profiles.listenableBuilder(
      builder: (context, _) {
        final host = LunaProfile.current.tracearrHost;
        return LunaBlock(
          title: 'Host',
          body: [
            TextSpan(text: host.isEmpty ? 'lunasea.NotSet'.tr() : host),
          ],
          trailing: const LunaIconButton(icon: Icons.dns_rounded),
          onTap: () async {
            final result = await LunaDialogs().editText(
              context,
              'Host',
              prefill: host,
            );
            if (result.item1) {
              LunaProfile.current.tracearrHost = result.item2.trim();
              LunaProfile.current.save();
              context.read<TracearrState>().reset();
            }
          },
        );
      },
    );
  }

  Widget _apiKeyTile() {
    return LunaBox.profiles.listenableBuilder(
      builder: (context, _) {
        final key = LunaProfile.current.tracearrKey;
        return LunaBlock(
          title: 'API Key',
          body: [
            TextSpan(text: key.isEmpty ? 'lunasea.NotSet'.tr() : '*' * key.length.clamp(0, 24)),
          ],
          trailing: const LunaIconButton(icon: Icons.key_rounded),
          onTap: () async {
            final result = await LunaDialogs().editText(
              context,
              'API Key',
              prefill: key,
            );
            if (result.item1) {
              LunaProfile.current.tracearrKey = result.item2.trim();
              LunaProfile.current.save();
              context.read<TracearrState>().reset();
            }
          },
        );
      },
    );
  }
}

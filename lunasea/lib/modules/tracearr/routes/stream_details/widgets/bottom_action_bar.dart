import 'package:flutter/material.dart';
import 'package:lunasea/api/tracearr/tracearr.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tracearr.dart';

class TracearrStreamDetailsBottomActionBar extends StatelessWidget {
  final TracearrStream stream;
  final VoidCallback? onTerminated;

  const TracearrStreamDetailsBottomActionBar({
    Key? key,
    required this.stream,
    this.onTerminated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBottomActionBar(
      actions: [
        LunaButton.text(
          text: 'Terminate Session',
          icon: Icons.close_rounded,
          color: LunaColours.red,
          onTap: () => _confirm(context),
        ),
      ],
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final api = context.read<TracearrState>().api;
    if (api == null) return;

    final result = await LunaDialogs().editText(
      context,
      'Terminate "${stream.mediaTitle}"?',
      prefill: '',
      extraText: const [
        TextSpan(text: 'Optional message to show the user before terminating.'),
      ],
    );
    if (!result.item1) return;

    try {
      final response = await api.service.terminateStream(
        stream.id,
        TracearrTerminateStreamBody(
          reason: result.item2.isEmpty ? null : result.item2,
        ),
      );
      if (response.success) {
        showLunaSuccessSnackBar(
          title: 'Stream terminated',
          message: stream.mediaTitle,
        );
        onTerminated?.call();
        if (context.mounted) Navigator.of(context).pop();
      } else {
        showLunaErrorSnackBar(
          title: 'Termination failed',
          message: response.error ?? 'Unknown error',
        );
      }
    } catch (error, stack) {
      LunaLogger().error('Failed to terminate Tracearr stream', error, stack);
      showLunaErrorSnackBar(
        title: 'Termination failed',
        error: error,
      );
    }
  }
}

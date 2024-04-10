import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

/// Shows a basic error dialog.
Future<void> showBasicErrorDialog(final BuildContext context,
    final String errorMessage) async {
  await showDialog(
    context: context,
    builder: (final context) => AlertDialog(
      title: const Text('Alert'),
      content: Text(
        errorMessage,
        style: TextStyle(
          color: mainTheme.colorScheme.error
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

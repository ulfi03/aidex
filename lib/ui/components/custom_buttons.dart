import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

/// A custom cancel button.
class CancelButton extends TextButton {
  /// Creates a new cancel button.
  CancelButton(
      {required final VoidCallback onPressed, super.key = cancelButtonKey})
      : super(
          onPressed: onPressed,
          child: const Text('Cancel'),
          style: mainTheme.textButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.transparent,
            ),
          ),
        );

  /// The key for the cancel button.
  static const Key cancelButtonKey = Key('cancel_button');
}

/// A custom ok button.
class OkButton extends TextButton {
  /// Creates a new ok button.
  const OkButton(
      {required final VoidCallback onPressed, super.key = okButtonKey})
      : super(
          onPressed: onPressed,
          child: const Text('Ok'),
        );

  /// The key for the ok button.
  static const Key okButtonKey = Key('ok_button');
}

/// A custom delete button.
class DeleteButton extends TextButton {
  /// Creates a new delete button.
  DeleteButton(
      {required final VoidCallback onPressed, super.key = deleteButtonKey})
      : super(
          onPressed: onPressed,
          child: const Text('Delete'),
          style: mainTheme.textButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.transparent,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              mainTheme.colorScheme.error,
            ),
          ),
        );

  /// The key for the delete button.
  static const Key deleteButtonKey = Key('delete_button');
}

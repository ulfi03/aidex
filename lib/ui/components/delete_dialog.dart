import 'package:aidex/ui/components/custom_buttons.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

/// A dialog that asks the user, if they want to
/// delete a [deleteSubject], from [objectCategory].
abstract class DeleteDialog extends StatelessWidget {
  /// Creates a new delete dialog.
  const DeleteDialog(
      {required this.objectCategory,
      required this.deleteMessage,
      required this.deleteSubject,
      super.key});

  /// The function to be called when the widget is tapped.
  void onDelete(final BuildContext context);

  /// The function to be called when the widget is tapped.
  void Function<T extends Object?>(BuildContext context) get onCancel =>
      Navigator.pop;

  ///What king of Item is going to be deleted
  final String objectCategory;

  ///The message that will be displayed in the dialog
  final String deleteMessage;

  ///What specific item is going to be deleted
  final String deleteSubject;

  /// The key to find the dialogs delete button
  static const dialogDeleteButtonKey = Key('dialog_delete_button');

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Text(
          'Delete $objectCategory',
          style: mainTheme.textTheme.titleMedium,
        ),
        content: RichText(
          text: TextSpan(
            style: mainTheme.textTheme.bodyMedium,
            children: [
              TextSpan(text: deleteMessage),
              TextSpan(
                text: deleteSubject,
                style: TextStyle(
                  color: mainTheme.colorScheme.primary,
                ),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          DeleteButton(
              key: dialogDeleteButtonKey, onPressed: () => onDelete(context)),
          CancelButton(onPressed: () => onCancel(context)),
        ],
        backgroundColor: mainTheme.colorScheme.background,
      );
}

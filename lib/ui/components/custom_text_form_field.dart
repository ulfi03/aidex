import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

/// A widget that represents a text form field.
class CustomTextFormField extends TextFormField {
  /// Creates a new text form field widget.
  CustomTextFormField(
      {super.key,
      super.controller,
      super.validator,
      super.maxLength,
      final String? hintText})
      : super(
          autovalidateMode: AutovalidateMode.always,
          cursorColor: mainTheme.colorScheme.primary,
          style: mainTheme.textTheme.bodySmall,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: mainTheme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: mainTheme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: mainTheme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
}

import 'package:flutter/material.dart';

/// Returns the text color that should be used based on the background color.
Color getColorFromBackground(final Color backgroundColor) {
  if (backgroundColor.computeLuminance() > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

/// The result of a validation.
class ValidationResult {
  /// Constructor for the [ValidationResult].
  ValidationResult.error(this.message) : isValid = false;

  /// Constructor for the [ValidationResult].
  ValidationResult.success()
      : isValid = true,
        message = '';

  ///  Whether the validation is valid.
  final bool isValid;

  /// The message of the validation.
  final String message;
}

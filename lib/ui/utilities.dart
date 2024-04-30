import 'package:flutter/material.dart';

/// Returns the text color that should be used based on the background color.
Color getColorFromBackground(final Color backgroundColor) {
  if (backgroundColor.computeLuminance() > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

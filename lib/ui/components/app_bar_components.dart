import 'package:flutter/material.dart';

/// The bottom widget of the app bar displaying a colored line
class AppBarBottomWidget extends PreferredSize {
  /// Constructs the app bar bottom widget
  AppBarBottomWidget({required final color, super.key})
      : super(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              thickness: 3,
              color: color,
              height: 1,
            ));
}

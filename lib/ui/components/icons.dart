import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

/// A widget that displays the AIDex logo.
class AIDexLogo extends StatelessWidget {
  /// Creates a new AIDex logo widget.
  const AIDexLogo(
      {required final double width, required final double height, super.key})
      : _height = height,
        _width = width;

  final double _width;

  final double _height;

  @override
  Widget build(final BuildContext context) => SvgPicture.asset(
        'assets/icon/aidex-logo.svg',
        semanticsLabel: 'AIDex Logo',
        height: _width,
        width: _height,
      );
}

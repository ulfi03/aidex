import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:aidex/ui/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Custom color picker widget.
class CustomColorPicker extends StatefulWidget {
  /// Constructor for the [CustomColorPicker].
  const CustomColorPicker({
    required final initialPickerColor,
    required this.onColorChanged,
    required this.label,
    super.key,
  }) : _initialPickerColor = initialPickerColor;

  /// The available colors for the color picker.
  static List<Color> get availableColors => const [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.pink,
        Colors.teal,
        Colors.cyan,
        Colors.indigo,
        Colors.brown,
        Colors.grey,
        Colors.black,
        Colors.white,
      ];

  /// The key for the color picker button.
  static const Key colorPickerButtonKey = Key('ColorPickerButton');

  /// Widget Title of color picker.
  static const Key pickColorTextKey = Key('PickColorText');

  /// Button to select a color from the color picker.
  static const Key colorPickerSelectButtonKey = Key('ColorPickerSelectButton');

  ///(Key to) Button text for the button to select a color the created deck.
  static const Key selectColorTextKey = Key('SelectColorText');

  /// The initial color of the color picker.
  final Color _initialPickerColor;

  /// The callback that is called when the color is changed.
  final void Function(Color) onColorChanged;

  /// The label of the color picker.
  final String label;

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late Color pickerColor;

  @override
  void initState() {
    super.initState();
    pickerColor = widget._initialPickerColor;
  }

  @override
  Widget build(final BuildContext context) => TextButton(
      key: CustomColorPicker.colorPickerButtonKey,
      onPressed: () {
        showDialog(
          context: context,
          builder: (final context) => AlertDialog(
            title: Text(
                key: CustomColorPicker.pickColorTextKey,
                'Pick a color',
                style: mainTheme.textTheme.titleMedium),
            backgroundColor: mainTheme.colorScheme.background,
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: pickerColor,
                availableColors: CustomColorPicker.availableColors,
                onColorChanged: (final color) {
                  setState(() => pickerColor = color);
                  widget.onColorChanged(color);
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                key: CustomColorPicker.colorPickerSelectButtonKey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Select'),
              ),
            ],
          ),
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: pickerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
          key: CustomColorPicker.selectColorTextKey,
          widget.label,
          style: mainTheme.textTheme.bodySmall
              ?.copyWith(color: getColorFromBackground(pickerColor))));
}

import 'package:flutter/material.dart';

/// This widget is used to display an error message.
class ErrorDisplayWidget extends StatelessWidget {

  /// Constructor for the [ErrorDisplayWidget].
  const ErrorDisplayWidget({required this.errorMessage, super.key});

  ///  The error message.
  final String errorMessage;

  @override
  Widget build(final BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error,
            size: 50,
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
}

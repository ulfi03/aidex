import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';

/// A widget used to display an index card item.
///
/// [IndexCardViewWidget] requires an [indexCard].
///
/// The [key] is used to identify the widget in the widget tree.
class IndexCardViewWidget extends StatelessWidget {
  /// Constructor for the [IndexCardViewWidget].
  const IndexCardViewWidget({required this.indexCard, super.key});

  /// The index card to be displayed.
  final IndexCard indexCard;

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(indexCard.question),
        ),
        body: Center(
          child: Text('''
              Question: ${indexCard.question} \n
              Answer: ${indexCard.answer}
              ''', style: mainTheme.textTheme.displayLarge),
        ),
      );
}

// Dart imports
// Local imports
import 'package:aidex/bloc/learning_function_bloc.dart';
import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:aidex/ui/components/custom_flip_card.dart';
import 'package:aidex/ui/components/error_display_widget.dart';
import 'package:aidex/ui/theme/aidex_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that displays the learning function of the application.
class LearningFunctionPage extends StatelessWidget {
  /// Creates a new instance of LearningFunctionPage.
  const LearningFunctionPage({
    required final Deck deck,
    super.key,
  }) : _deck = deck;

  final Deck _deck;

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) => LearningFunctionBloc(
          context.read<IndexCardRepository>(), _deck.deckId!),
      child: LearningFunction(deck: _deck));
}

/// A stateless widget that represents the learning function of the application
class LearningFunction extends StatelessWidget {
  // Declare the repository

  /// Creates a new instance of LearningFunction.
  const LearningFunction({
    required final Deck deck,
    super.key,
  }) : _deck = deck;

  final Deck _deck;

  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(_deck.name)),
      body: _buildBody(context));

  Widget _buildBody(final BuildContext context) =>
      BlocBuilder<LearningFunctionBloc, LearningFunctionState>(
        builder: (final context, final state) {
          if (state is IndexCardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IndexCardLoaded) {
            return _buildFlipCard(context, state);
          } else if (state is IndexCardError) {
            return ErrorDisplayWidget(errorMessage: state.message);
          } else {
            return const SizedBox.shrink();
          }
        },
      );

  Widget _buildFlipCard(
          final BuildContext context, final IndexCardLoaded state) =>
      Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: CustomFlipCard(card: state.indexCard),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ColoredBox(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: state.currentIndex > 0
                              ? mainTheme.colorScheme.primary
                              : mainTheme.colorScheme.surfaceVariant,
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: state.currentIndex > 0
                            ? mainTheme.colorScheme.primary
                            : mainTheme.colorScheme.surfaceVariant,
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: state.currentIndex > 0
                          ? () => BlocProvider.of<LearningFunctionBloc>(context)
                              .add(const PreviousIndexCardEvent())
                          : null,
                      child: const Text('Back'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: state.currentIndex < state.cardsCount - 1
                              ? mainTheme.colorScheme.primary
                              : mainTheme.colorScheme.surfaceVariant,
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            state.currentIndex < state.cardsCount - 1
                                ? mainTheme.colorScheme.primary
                                : mainTheme.colorScheme.surfaceVariant,
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: state.currentIndex < state.cardsCount - 1
                          ? () => BlocProvider.of<LearningFunctionBloc>(context)
                              .add(const NextIndexCardEvent())
                          : null,
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

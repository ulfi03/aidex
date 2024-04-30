import 'dart:convert';
import 'dart:core';

import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/data/repo/deck_repository.dart';
import 'package:aidex/data/repo/index_card_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

/// The business logic component of the CreateDeckDialogOnAi feature.
class CreateDeckDialogOnAiBloc
    extends Bloc<CreateDeckDialogOnAiEvent, CreateDeckDialogOnAiState> {
  /// Constructor for the [CreateDeckDialogOnAiBloc].
  CreateDeckDialogOnAiBloc(
      {required final DeckRepository deckRepository,
      required final IndexCardRepository indexCardRepository})
      : _deckRepository = deckRepository,
        _indexCardRepository = indexCardRepository,
        super(CreateDeckDialogOnAiInitial()) {
    /// Event handlers
    on<CreateDeckWithAi>((final event, final emit) async {
      emit(CreateDeckDialogOnAiLoading());
      // get the deck id from the deck we just created
      final Deck createdDeck = await _deckRepository.addDeck(event.deck);
      if (createdDeck.deckId == null || createdDeck.deckId! <= 0) {
        emit(CreateDeckDialogOnAiFailure(message: 'Failed to save new deck!'));
      } else {
        final int deckId = createdDeck.deckId!;
        if (kDebugMode) {
          print('created deckId: $deckId');
        }
        final Map<String, dynamic> serverResponse =
            await requestIndexCardsFromServer(event.filepath);
        final serverErrorBoolean = serverResponse['error'];
        if (serverErrorBoolean) {
          emit(CreateDeckDialogOnAiFailure(
              message: serverResponse['error_message']));
        } else if (await processIndexCardsFromServer(serverResponse, deckId)) {
          emit(CreateDeckDialogOnAiSuccess());
        } else {
          emit(CreateDeckDialogOnAiFailure(
              message: 'Failed to save new index cards!'));
        }
      }
    });
  }

  final DeckRepository _deckRepository;
  final IndexCardRepository _indexCardRepository;

  /// Request index cards from the server.
  Future<Map<String, dynamic>> requestIndexCardsFromServer(
      final String filepath) async {
    // start of server inquiry
    if (kDebugMode) {
      print('Now making server request');
    }
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://aidex-server.onrender.com/create_index_cards_from_files'),
    );
    request.fields['user_uuid'] = '1234';
    request.fields['openai_api_key'] =
        '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';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      filepath,
    ));
    final response = await request.send();
    //server response handling
    final jsonResponse = await response.stream.bytesToString();
    if (kDebugMode) {
      print(jsonResponse);
    }
    final Map<String, dynamic> serverResponse = jsonDecode(jsonResponse);
    return serverResponse;
  }

  /// Process the index cards from the server.
  Future<bool> processIndexCardsFromServer(
      final Map<String, dynamic> serverResponse, final int deckId) async {
    final serverAusgabe = serverResponse['ausgabe'];
    final ausgabe = jsonDecode(serverAusgabe.toString());

    final List<String> questions = <String>[];
    final List<String> answers = <String>[];

    for (final item in ausgabe) {
      final Map<String, dynamic> itemMap = item;
      final String frage = itemMap['Frage'] as String;
      final String antwort = itemMap['Antwort'] as String;

      questions.add(frage);
      answers.add(antwort);
      if (kDebugMode) {
        print('Frage: $frage');
      }
      if (kDebugMode) {
        print('Antwort: $antwort');
      }
    }

    for (int i = 0; i < questions.length; i++) {
      final IndexCard indexCard = IndexCard(
        deckId: deckId,
        question: questions[i],
        answer: '[{"insert":"${answers[i]}\\n"}]',
      );
      final IndexCard createdCard =
          await _indexCardRepository.addIndexCard(indexCard);
      if (createdCard.indexCardId == null || createdCard.indexCardId! <= 0) {
        return false;
      }
    }
    return true;
  }
}

// ################################################################# Events

/// The events that can be emitted by the CreateDeckDialogOnAiBloc.
abstract class CreateDeckDialogOnAiEvent {}

/// An event to create a deck with AI.
class CreateDeckWithAi extends CreateDeckDialogOnAiEvent {
  /// Constructor for the [CreateDeckWithAi].
  CreateDeckWithAi({required this.deck, required this.filepath});

  /// The deck to be created.
  final Deck deck;

  /// The filepath of the file containing information used for generation of
  /// index cards.
  final String filepath;
}

// ################################################################# States
/// The states that can be emitted by the CreateDeckDialogOnAiBloc.
abstract class CreateDeckDialogOnAiState {}

/// The create deck dialog on AI initial state.
class CreateDeckDialogOnAiInitial extends CreateDeckDialogOnAiState {}

/// The create deck dialog on AI loading state.
class CreateDeckDialogOnAiLoading extends CreateDeckDialogOnAiState {}

/// The create deck dialog on AI success state.
class CreateDeckDialogOnAiSuccess extends CreateDeckDialogOnAiState {}

/// The create deck dialog on AI failure state.
class CreateDeckDialogOnAiFailure extends CreateDeckDialogOnAiState {
  /// Constructor for the [CreateDeckDialogOnAiFailure].
  CreateDeckDialogOnAiFailure({required this.message});

  /// The error message.
  final String message;
}

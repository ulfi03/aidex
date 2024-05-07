# AIDex

<img src="assets/icon/aidex-logo.svg" width="100px" alt="Project Banner">

[![Flutter Version](https://img.shields.io/badge/flutter-3.19.3-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/dart-3.3.1-blue.svg)](https://dart.dev/)
[![BLoC](https://img.shields.io/badge/BLoC-State_Management-blue.svg)](https://bloclibrary.dev/#/)
[![OpenAI](https://img.shields.io/badge/OpenAI-ChatGPT-blue.svg)](https://openai.com/)

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Screenshots](#screenshots)
4. [Getting Started](#getting-started)
5. [Project Structure](#project-structure)
6. [Bloc Architecture - Example](#bloc-architecture-example)
7. [Code Example](#code-example)
8. [Dependencies](#dependencies)
9. [License](#license)
10. [Contact](#contact)

## Introduction

AIDex is a mobile application designed to facilitate the generation of index cards. It leverages the power of OpenAI's
ChatGPT to generate content for the index cards, making it an ideal tool for students, researchers, and anyone in need
of a quick and efficient way to create and manage index cards.

## Features

- User-friendly interface for creating, managing, and sorting index cards.
- Integration with ChatGPT for efficient content generation.
- BLoC architecture pattern for clean, manageable codebase.

## Screenshots

Include screenshots to showcase the UI and important features.
<table>
  <tr>
    <td><img src="doc/screenshots/deck-overview.jpg" alt="Deck Overview" width="250px"></td>
    <td><img src="doc/screenshots/create-deck_modal-bottom-sheet.jpg" alt="Create Deck Modal Bottom Sheet" width="250px"></td>
    <td><img src="doc/screenshots/create-deck_dialog.jpg" alt="Create Deck Dialog" width="250px"></td>
  </tr>
  <tr>
    <td><img src="doc/screenshots/create-deck_dialog_with-ai.jpg" alt="Create Deck Dialog with AI" width="250px"></td>
    <td><img src="doc/screenshots/index-card-overview.jpg" alt="Index Card Overview" width="250px"></td>
    <td></td>
  </tr>
  <tr>
    <td><img src="doc/screenshots/select-IndexCards.png" alt="Select IndexCards (for deletion)" width="250px"></td>
    <td><img src="doc/screenshots/indexCard_delete_dialog.png" alt="Create Deck Dialog with AI" width="250px"></td>
    <td></td>
  </tr>

</table>

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Xcode for mobile app development

### Installation

1. Clone the repository.
   ```bash
   git clone https://github.com/ulfi03/aidex.git

2. Change into the project directory.
   ```bash
   cd aidex
   ```
3. Install dependencies.
   ```bash
   flutter pub get

### Running the App

1. Ensure a device or emulator is available.
2. Use the following command to run the app.
   ```bash
   flutter run
   ```

## Project Structure

The project structure is as follows:

```
aidex/
│── android/ # Android specific files
│── assets/
│ └── icon/ # App icons
│── doc/ # Documentation files
│ ├── mockups/ # Mockups for the app
│ ├── product-vision/ # Product vision documents
│ ├── retrospectives/ # Retrospective documents
│ └── screenshots/ # Screenshots of the app
│── integration_test/ # Integration tests
│── lib/
│ ├── bloc/ # BLoC related files
│ ├── data/ # Data related files
│ ├── ui/ # UI related files
│ └── main.dart # Entry point for the app
│── test/ # Unit and widget tests
│── pubspec.yaml # Flutter project configuration
└── README.md # This README file
```

## Dependencies

- [Flutter](https://flutter.dev/) - Framework for building the app.
- [BLoC](https://bloclibrary.dev/#/) - State management.
- [OpenAI](https://openai.com/) - AI services.

## BLoC Architecture

BLoC stands for "Business Logic Component" and is a popular architecture pattern in Flutter. It helps you separate
business logic from the user interface, allowing you to maintain a clean structure in your apps. BLoC relies on the
concept of streams, where data flows in one direction. You have two primary components: the BLoC itself and the UI (user
interface). The BLoC is where you handle all the business logic, while the UI listens for updates from the BLoC.

An important addition to the pattern is the data component, which encompasses the source of truth for your application's
data. This component might include services, repositories, or data storage, and is responsible for fetching, storing,
and updating data from various sources like APIs, local databases, or files. In the BLoC architecture, the BLoC acts as
a bridge between the UI and the data component. It receives events from the UI, retrieves or manipulates data via the
data component, and then streams the resulting states back to the UI.

<img src="doc/screenshots/bLoC-architecture-illustration.png" alt="Illustration of BLoC Architecture functionality" height="150">

### Benfits

| Benefit                  | Description                                                                                                             |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------|
| Separation of Concerns   | BLoC architecture separates business logic from UI, which makes the codebase cleaner and easier to maintain.            |
| Testability              | Since the business logic is separated from the UI, it's easier to write unit tests for the business logic.              |
| Reusability              | BLoC components can be reused across different parts of the app or even across different apps.                          |
| Predictability           | BLoC architecture follows a predictable data flow, which makes it easier to understand how the state changes over time. |
| Consistency              | BLoC enforces a consistent way of managing state and handling business logic across the entire app.                     |
| Scalability              | BLoC architecture is highly scalable. It works equally well for small and large projects.                               |
| Integration with Flutter | BLoC architecture works seamlessly with Flutter's reactive model.                                                       |

### Example

#### Select IndexCards and delete them

The [index_card_item_widget.dart](.\lib\ui\deck-view\index_card_item_widget.dart) file contains
the [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart)
class, which is a widget used to display an
index card item in [index_cards_overview_widget.dart](.\lib\ui\deck-view\index_cards_overview_widget.dart). These
widgets use the BLoC  (Business Logic
Component) Architecture [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) to select `indexCards`.

The following table shows all the states, events, and their attributes used
in [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart):

| Events                     | Attributes                        | Description                                         | States                 | Attributes                                                        | Description                                                    |
|----------------------------|-----------------------------------|-----------------------------------------------------|------------------------|-------------------------------------------------------------------|----------------------------------------------------------------|
| FetchIndexCards            |                                   | Fetches index cards from the data source.           | IndexCardInitial       |                                                                   | The initial state of the index card.                           |
| UpdateSelectedIndexCards   | `List<int> indexCardIds`          | Updates the list of selected index cards.           | IndexCardsLoading      | `String query`                                                    | Represents the loading state when fetching index cards.        |
| ExitIndexCardSelectionMode |                                   | Exits the index card selection mode.                | IndexCardsLoaded       | `List<IndexCard> indexCards`, <br/>`String query`                 | Represents the state when index cards are successfully loaded. |
| RemoveIndexCardsById       | `List<int> selectedIndexCardsIds` | Removes selected index cards by their IDs.          | IndexCardSelectionMode | `List<int> indexCardIds`, `List<IndexCard> indexCards`            | Represents the state when an index card is selected.           |
| AddIndexCard               | `IndexCard indexCard`             | Adds a new index card.                              |                        | `function`: <br/>`bool isThisCardSelected(final int indexCardId)` |                                                                |
| SearchIndexCards           | `String query`                    | Searches for index cards based on a query.          | IndexCardsError        | `String message`                                                  | Represents the state when an error occurs.                     |
| SortIndexCards             | `bool sortAsc`                    | Sorts index cards in ascending or descending order. |                        |                                                                   |                                                                |

One of the key functionalities of the BLoC architecture is that if you read the state of the BLoC in your UI, then you
can access the
attributes of this state. Reading the values of the attributes the UI changes its display accordingly. The UI itself can
trigger Events which are captured by the BLoC. Given an Event you can access the attributes of the Events when they are
triggered. The business logic is then able to do its logic with these values triggering a certain state with different
attributes and the cycle repeats.

For selecting and deleting index cards the cycle is as follows:

The [`updateSelection(context)`](.\lib\ui\deck-view\index_card_item_widget.dart) method triggers the
Event [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart).

[`updateSelection(context)`](.\lib\ui\deck-view\index_card_item_widget.dart) itself is triggered given two scenarios:

1. If the BLoCs state is not in [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart):  
   Long-pressing the [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart) will trigger
   the [`updateSelection(context)`](.\lib\ui\deck-view\index_card_item_widget.dart) method handled in
   the `onLongPress` parameter
   of `GestureDetector`. This will select the
   long-pressed [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart) in
   the [`IndexCardOverview`](lib/ui/deck-view/index_cards_overview_widget.dart) as
   follows.


2. If the BLoCs state is already in [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart)):  
   Tapping on [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart) will trigger
   the [`updateSelection(context)`](.\lib\ui\deck-view\index_card_item_widget.dart) method handled in the `onTap`
   parameter
   of the `GestureDetector` widget.
   This selects the tapped [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart) in
   the [`IndexCardOverview`](lib/ui/deck-view/index_cards_overview_widget.dart) or deselects if it was already selected.

The [`updateSelection(context)`](.\lib\ui\deck-view\index_card_item_widget.dart) method is a crucial part of
the [`IndexCardItemWidgets`](.\lib\ui\deck-view\index_card_item_widget.dart) interaction with the BLoC
architecture. This method is responsible for managing the selection of the index card. It adds an index card to the
selected index cards
list if it isn't selected, or removes the index card from the selected index cards list if it was selected. After one of
these operations on the selected index cards list, it updates the selected index cards list in the bloc.

[`updateSelection(context)`](.\lib\ui\deck-view\index_card_item_widget.dart) is called with the current `BuildContext`
as an argument. This
context is used to access the [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) and add
the [`UpdateSelectedIndexCards`](lib/bloc/index_cards_overview_bloc.dart) event to it with the
updated list of selected index cards.

This interaction between the [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart) and
the [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) is a typical example of the BLoC
architecture, where the UI components (widgets) dispatch events to the BLoC, and the BLoC updates the state based on
these events. The widgets then rebuild based on the new state.

##### IndexCardItemWidget

```dart
void updateSelection(final BuildContext context) {
  final List<int> selectedIndexCardIds =
  (_state is IndexCardSelectionMode) ? _state.indexCardIds : [];
  if (!selectedIndexCardIds.contains(indexCard.indexCardId)) {
    selectedIndexCardIds.add(indexCard.indexCardId!);
  } else {
    selectedIndexCardIds.remove(indexCard.indexCardId);
  }
  context.read<IndexCardOverviewBloc>().add(
    UpdateSelectedIndexCards(indexCardIds: selectedIndexCardIds),
  );
}
```

The following line checks if the current state of the BLoC
is [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart). If it is, it assigns the list of
currently selected
index card IDs (which is the attribute ```List<int> indexCardIds``` which it gets from the
state [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart)) to `selectedIndexCardIds`. If it's not
in [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart),
then [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart) is about to be initiated, therefore it assigns
an empty list
to `selectedIndexCardIds`.

<!-- @formatter:off-->
```dart
  final List<int> selectedIndexCardIds =
  (_state is IndexCardSelectionMode) ? _state.indexCardIds : [];
```
<!-- @formatter:on-->

The following code-block checks if the current index card ID is in the `selectedIndexCardIds` list. If it's not, it
adds
the current
index card ID to the list. If it is, it removes the current index card ID from the list. This is how the selection and
deselection of index cards are handled.

<!-- @formatter:off-->
```dart
  if (!selectedIndexCardIds.contains(indexCard.indexCardId) {
    selectedIndexCardIds.add(indexCard.indexCardId!);
  } else {
    selectedIndexCardIds.remove(indexCard.indexCardId);
  }
```
<!-- @formatter:on-->

The following line dispatches an [`UpdateSelectedIndexCards`](lib/bloc/index_cards_overview_bloc.dart) event to
the [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) with the
updated list of selected`selectedIndexCardIds` list. This is how the BLoC is notified about the changes in the
selection of index cards

<!-- @formatter:off-->
```dart
  context.read<IndexCardOverviewBloc>()
        .add(UpdateSelectedIndexCards(indexCardIds: selectedIndexCardIds),);
```
<!-- @formatter:on-->

##### IndexCardOverviewBloc

This is how [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) catches the dispatched event.

<!-- @formatter:off-->
```dart
on<UpdateSelectedIndexCards>((final event, final emit) async {
  emit(IndexCardSelectionMode(indexCardIds: event.indexCardIds, indexCards: _indexCards));
});
```
<!-- @formatter:on-->
As stated before, the BLoC is able to access the attributes of the dispatched event. In this case, it accesses the
`indexCardIds` attribute of the [`UpdateSelectedIndexCards`](lib/bloc/index_cards_overview_bloc.dart) event. It then
emits a new state with the updated
list of
selected index card IDs (`indexCardIds`). IndexCardSelectionMode is further in need of all the `indexCards` in
the list but those are not
dependent on the Event, therefore they stay the same.

##### BlocBuilder ([`IndexCardOverview`](lib/ui/deck-view/index_cards_overview_widget.dart))

The [`IndexCardOverview`](lib/ui/deck-view/index_cards_overview_widget.dart) uses the `BlocBuilder` to rebuild the UI
based on the state of
the [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart). `BlocBuilder` listens to the state
of [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) and rebuilds
the UI based on whether the state itself has changed or if any attributes of the current state were changed.

To recognize the change in a states attribute the state itself has to override the props method of the EquatableMixin
class (
like overwriting the equals method in Java). Like IndexCardsError does in the following example

<!-- @formatter:off-->
```dart
/// The index card error state.
class IndexCardsError extends IndexCardState with EquatableMixin {
  /// Creates a new index card error state.
  const IndexCardsError({required this.message});

  /// The error message.
  final String message;

  @override
  List<Object> get props => [message];
}
```
<!-- @formatter:on-->

[`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart) does not override the props method because it is
expected to trigger a rebuild everytime the
state is
emitted.

The following code-block shows how BlocBuilder is implemented
in [`IndexCardOverview`](lib/ui/deck-view/index_cards_overview_widget.dart).

There are many BlocBuilder which control different parts of
the [`IndexCardOverview`](lib/ui/deck-view/index_cards_overview_widget.dart) widgets UI. But I will only focus on
one given that they all work similar.

<!-- @formatter:off-->
```dart
BlocBuilder<IndexCardOverviewBloc, IndexCardState>(
   builder: (final context, final state) {
      if (state is IndexCardsLoading) {
         return Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
            mainTheme.colorScheme.primary,
            )),
         );
      } else if (state is IndexCardSelectionMode) {
        return IndexCardsContainer(state: state, deck: deck);
      } else if (state is IndexCardsLoaded) {
         return IndexCardsContainer(
            state: state,
            deck: deck,
            );
      } else if (state is IndexCardsError) {
        return ErrorDisplayWidget(errorMessage: state.message);
      } else {
        return const ErrorDisplayWidget(errorMessage: 'Something went wrong!');
      }
   }
);
```
<!-- @formatter:on-->

This BlocBuilder manages how the UI part that contains the list of Index cards (red) is displayed
One can see that the UI changes based on the current state that BlocBuilder receives
from [`IndexCardOverviewBloc`](lib/bloc/index_cards_overview_bloc.dart) and
that 4 cases are distinguished.

<table>
   <tr>
    <th><p>IndexCardsLoading</p></th>
    <th><p>IndexCardSelectionMode</p></th>
    <th><p>IndexCardsLoaded</p></th>
    <th><p>IndexCardsError</p></th>
  </tr>
  <tr>
    <td><p style="color: red">Circle corresponding part red</p><img src="doc/screenshots/deck-overview.jpg" alt="Deck Overview" width="250px"></td>
    <td><p style="color: red">Circle corresponding part red</p><img src="doc/screenshots/select-IndexCards.png" alt="Select IndexCards (for deletion)" width="250px"></td>
    <td><p style="color: red">Circle corresponding part red</p><img src="doc/screenshots/index-card-overview.jpg" alt="Index Card Overview" width="250px"></td>
    <td><p style="color: red">Circle corresponding part red</p><img src="doc/screenshots/indexCard_delete_dialog.png" alt="Create Deck Dialog with AI" width="250px"></td>
  </tr>
</table>

For [`IndexCardSelectionMode`](lib/bloc/index_cards_overview_bloc.dart)
and [`IndexCardsLoaded`](lib/bloc/index_cards_overview_bloc.dart) the, state is passed down
to [`IndexCardsContainer`](lib/ui/deck-view/index_cards_overview_widget.dart). This class is
responsible for building the list of indexCards, having access to
each `indexCard` -[`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart) itself.
Whether a single IndexCardItemWidget is selected (showing the check-icon + appearing grey) or not is determined inside
the [`IndexCardItemWidget`](.\lib\ui\deck-view\index_card_item_widget.dart).

## Code Example

[Beispielcode für das Verständnis der Project-Structure, complexer Funktionalitäten.]

### AIDEX Server

Overview of the AIDEX server, its functionalities, and key components.

---

### Table of Contents

1. [Introduction](#introduction)
2. [Project Structure](#project-structure)
3. [Endpoints](#endpoints)
    - [1. `/create_index_cards_from_files`](#create_index_cards_from_files)
    - [2. `/create_index_cards_from_text`](#create_index_cards_from_text)
4. [Functions](#functions)
    - [1. `extract_text`](#extract_text)
    - [2. `schedule_chatgpt_requests`](#schedule_chatgpt_requests)
    - [3. `ClientResponse`](#clientresponse)
    - [4. `validate_response`](#validate_response)
    - [5. `validate_index_card`](#validate_index_card)
    - [6. `ai_create_index_cards_from_plain_text`](#ai_create_index_cards_from_plain_text)
5. [Constants](#constants)

---

### 1. Introduction <a name="introduction"></a>

AIDEX Server is a Flask-based web application designed to generate index cards from various file types such as PDFs, DOCX files, and plain text. It leverages OpenAI's GPT-3.5 model to extract relevant information and format it into index card structures. The server is hosted on [https://aidex-server.onrender.com](https://aidex-server.onrender.com).

### 2. Project Structure <a name="project-structure"></a>

The project structure is hosted on GitHub at [risky-dev-11/aidex_server](https://github.com/risky-dev-11/aidex_server). It comprises the following two key components:

- `app.py`: Main application file containing Flask routes and server setup.
- `requirements.txt`: Lists dependencies required by the application.

### 3. Endpoints <a name="endpoints"></a>

#### 1. `/create_index_cards_from_files` <a name="create_index_cards_from_files"></a>

- **Method:** POST
- **Description:** Accepts files uploaded by the user along with an OpenAI API key and user UUID. It extracts text from the files, splits it into chunks, and schedules requests to the OpenAI API for index card generation. Currently supported file formats are PDF, DOCX, and TXT.
- **Parameters:**
    - `file`: File object containing the document to be processed.
    - `openai_api_key`: OpenAI API key for accessing the GPT-3.5 model.
    - `user_uuid`: Unique identifier for the user. // This variable is currently not used for any functionality
- **Response:** JSON object containing generated index cards or error information.

#### 2. `/create_index_cards_from_text` <a name="create_index_cards_from_text"></a>

// This functionality is currently not implemented!

- **Method:** POST
- **Description:** Placeholder endpoint for future functionality to generate index cards directly from text input.
- **Parameters:** None
- **Response:** JSON object with a "Hello World!" response.

### 4. Functions <a name="functions"></a>

#### 1. `extract_text` <a name="extract_text"></a>

This function retrieves the text from the file, send by the user.
```python
def extract_text(file: FileStorage):
    text = ""
    if file.filename.endswith('.txt'):
        text = file.read().decode('utf-8')
    else:
        # Extracting text from other file formats
    return text
```
#### 2. schedule_chatgpt_requests <a name="schedule_chatgpt_requests"></a>

This function is one of the core elements of the server.

The `schedule_chatgpt_requests` function is designed to process a list of strings concurrently using the OpenAI API. Here's a detailed breakdown of how it works:

```python
def schedule_chatgpt_requests(str_array, openai_api_key):
```

This function accepts two parameters:

- `str_array`: An array of strings that you want to process.
- `openai_api_key`: Your OpenAI API key.

The function begins by creating a pool of worker threads using `concurrent.futures.ThreadPoolExecutor`. Each thread is responsible for processing one element from `str_array` by calling the `ai_create_index_cards_from_plain_text` function.

```python
with concurrent.futures.ThreadPoolExecutor() as executor:
    futures = []
    for element in str_array:
        future = executor.submit(ai_create_index_cards_from_plain_text, element, openai_api_key)
        futures.append(future)
```

The `concurrent.futures.as_completed` function is used to iterate over the `Future` instances as they complete (i.e., as the results become available). If an error occurs during the processing of an element, an exception is raised.

```python
for future in concurrent.futures.as_completed(futures):
    ai_response, error = future.result()
    if error:
        raise Exception(ai_response)
```

The function then validates each response using the `validate_response` function. If the response is valid, it is added to the `responses` string.

```python
if validate_response(ai_response):
    responses += ai_response + "#"
```

Finally, the function splits the `responses` string into an array of strings, removes any empty strings, and returns the array of formatted responses.

```python
responses_split = responses.split("#")

formatted_responses = []
for response in responses_split:
    formatted_response = response.strip()
    if formatted_response != "":
        formatted_responses.append(response.strip())

return formatted_responses
```

Python's `concurrent.futures` module significantly improves the response time of our webserver.
#### 3. ClientResponse <a name="clientresponse"></a>
This is the `ClientResponse` class used to define a general scheme for the client response.
```python
class ClientResponse:
    def __init__(self, index_cards=None, error=False, error_message=''):
        # Constructor implementation

    def to_dict(self):
        # Method implementation
        return {
            'index-cards': self.index_cards,
            'error': self.error,
            'error_message': self.error_message
        }
```
#### 4. validate_response <a name="validate_response"></a>
This function validates the chatbots response.
```python
def validate_response(response):
```
#### 5. validate_index_card <a name="validate_index_card"></a>
This function validates each index card and removes them, if a check fails.
```python
def validate_index_card(json_data):
```
#### 6. ai_create_index_cards_from_plain_text <a name="ai_create_index_cards_from_plain_text"></a>
This functionality is currently not implemented!
```python
def ai_create_index_cards_from_plain_text(plain_text, api_key): 
    return generated_index_cards or error_message
```
#### 5. Constants <a name="constants"></a>

##### QUESTION_LABEL: Constant string representing the label for the question part of an index card.     
##### ANSWER_LABEL: Constant string representing the label for the answer part of an index card.

## License

This project is currently not licensed.

## Contact

- Project Owner: [Marius Ulfers](https://github.com/ulfi03)

---

Thank you for using our project! If you have any suggestions or feedback, please feel free to reach out.

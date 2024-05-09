# AIDex

<img src="assets/icon/aidex-logo.svg" width="100px" alt="Project Banner">

[![Flutter Version](https://img.shields.io/badge/flutter-3.19.3-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/dart-3.3.1-blue.svg)](https://dart.dev/)
[![BLoC](https://img.shields.io/badge/BLoC-State_Management-blue.svg)](https://bloclibrary.dev/#/)
[![OpenAI](https://img.shields.io/badge/OpenAI-ChatGPT-blue.svg)](https://openai.com/)

---

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Screenshots](#screenshots)
4. [Getting Started](#getting-started)
5. [Project Structure](#project-structure)
10. [Dependencies](#dependencies)
11. [License](#license)
12. [Contact](#contact)

## Understanding the Project and its Components

- [Basic Concepts](doc/README/BASIC_CONCEPTS.md)
- [Code Example](doc/README/EXAMPLE.md)
- [AIDex Server](doc/README/AIDEX_SERVER.md)

---

## Introduction

AIDex is a mobile application designed to facilitate the generation of index cards. It leverages the power of OpenAI's
ChatGPT to generate content for the index cards, making it an ideal tool for students, researchers, and anyone in need
of a quick and efficient way to create and manage index cards.

<img src="doc/README/images/AIDex-System-Overview.drawio.svg" width="800px" alt="AIDex-System-overview">

## Features

- User-friendly interface for creating, managing, and searching index cards.
- Learning function to help users memorize the content of the index cards.
- Integration with ChatGPT for efficient content generation.
- BLoC architecture pattern for clean, manageable codebase.

## Screenshots

Include screenshots to showcase the UI and important features.
<table>
   <tr>
      <td><img src="doc/screenshots/deck-overview/deck-overview.jpg" alt="Deck Overview" width="250px"></td>
      <td><img src="doc/screenshots/deck-overview/deck-overview_create-deck-modal-bottom-sheet.jpg" alt="Create Deck Modal Bottom Sheet" width="250px"></td>
      <td><img src="doc/screenshots/deck-overview/deck-overview_create-deck-with-ai.jpg" alt="Create Deck Dialog with AI" width="250px"></td>
   </tr>
   <tr>
      <td><img src="doc/screenshots/index-card-overview/index-card-overview_loaded.jpg" alt="Index Card Overview loaded" width="250px"></td>
      <td><img src="doc/screenshots/index-card-overview/index-card-overview_one-selected.jpg" alt="One index card selected" width="250px"></td>
      <td><img src="doc/screenshots/learning-function.jpg" alt="Learning Function" width="250px"></td>
   </tr>
   <tr>
      <td><img src="doc/screenshots/index-card-view/index-card-create-edit_BLoC.jpg" alt="Create/Edit index card" width="250px"></td>
      <td><img src="doc/screenshots/index-card-view/index-card-view_question.jpg" alt="View index card question" width="250px"></td>
      <td><img src="doc/screenshots/index-card-view/index-card-view_rotation.jpg" alt="View index card answer" width="250px"></td>
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

## License

This project is currently not licensed.

## Contact

- Project Owner: [Marius Ulfers](https://github.com/ulfi03)

---

Thank you for using our project! If you have any suggestions or feedback, please feel free to reach out.

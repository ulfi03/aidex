/// This file contains the validators for the deck name
const int deckNameMaxLength = 30;

/// validator for deck name
String? deckNameValidator(final String? value) {
  if (value == null || value.isEmpty) {
    return 'Cannot be empty';
  }
  if (value.length > deckNameMaxLength) {
    return 'must be at most $deckNameMaxLength characters';
  }
  if (value.startsWith(' ')) {
    return 'cannot start with a space';
  }
  if (value.endsWith(' ')) {
    return 'cannot end with a space';
  }
  return null;
}

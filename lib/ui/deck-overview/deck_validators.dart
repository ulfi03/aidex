/// validator for deck name
String? deckNameValidator(final String? value) {
  if (value == null || value.isEmpty) {
    return 'Cannot be empty';
  }
  if (value.length > 30) {
    return 'must be less than 30 characters';
  }
  if (value.startsWith(' ')) {
    return 'cannot start with a space';
  }
  if (value.endsWith(' ')) {
    return 'cannot end with a space';
  }
  return null;
}

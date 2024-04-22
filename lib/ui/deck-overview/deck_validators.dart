/// validator for deck name
String? deckNameValidator(final String? value) {
  if (value == null || value.isEmpty) {
    return 'Cannot be empty';
  }
  if (value.length > 21) {
    return 'must be less than 21 characters';
  }
  if (value.startsWith(' ')) {
    return 'cannot start with a space';
  }
  if (value.endsWith(' ')) {
    return 'cannot end with a space';
  }
  if (!RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(value)) {
    return 'Only a-z, A-Z, 0-9\nand spaces allowed';
  }
  return null;
}

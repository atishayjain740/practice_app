String getMinLengthErrorString({int minLength = 3}) {
  return 'Name must be at least $minLength characters long.';
}

String getMaxLengthErrorString({int maxLength = 50}) {
  return 'Name must not exceed $maxLength characters.';
}

String getInvalidCharErrorString() {
  return 'Name can only contain letters and spaces.';
}

String? validateName(String name, {int minLength = 3, int maxLength = 50}) {
  // Trim spaces
  name = name.trim();

  // Check length constraints
  if (name.length < minLength) {
    return getMinLengthErrorString(minLength: minLength);
  }
  if (name.length > maxLength) {
    return getMaxLengthErrorString(maxLength: maxLength);
  }

  // Ensure name contains only letters and spaces
  final nameRegExp = RegExp(r"^[a-zA-Z\s]+$");
  if (!nameRegExp.hasMatch(name)) {
    return getInvalidCharErrorString();
  }

  return null; // Valid name
}
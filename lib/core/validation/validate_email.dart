String emailErrorString = 'Please enter a valid email address';

String? validateEmail(String email) {
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  if (email.isEmpty) {
    return emailErrorString;
  } else if (!emailRegex.hasMatch(email)) {
    return emailErrorString;
  }
  
  return null;
}
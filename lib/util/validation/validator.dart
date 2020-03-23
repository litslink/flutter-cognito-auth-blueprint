mixin Validator {
  bool validate(String input);
}

class EmailValidator implements Validator {
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  bool validate(String input) => _emailRegExp.hasMatch(input);
}

class PasswordValidator implements Validator {
  final RegExp _passwordRegExp = RegExp(
    r'.{8,}$',
  );

  @override
  bool validate(String input) => _passwordRegExp.hasMatch(input);
}

class ConfirmationCodeValidator implements Validator {
  final RegExp _confirmationCodeRegExp = RegExp(
    r'.{6,}$',
  );

  @override
  bool validate(String input) => _confirmationCodeRegExp.hasMatch(input);
}

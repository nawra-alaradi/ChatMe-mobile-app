extension ExtString on String {
  bool get isValidUsername {
    final nameRegExp = RegExp(r"^[A-Za-z]{1,}[0-9]{1,}$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp =
        RegExp(r'.{6,20}$'); // match any character including special character
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
    return nameRegex.hasMatch(this);
  }
}

class SignUpValidator {

  bool _showClearButton = false;
  bool _hasFocus = false;

  int _selectedIndex = -1;

  String? _nicknameError;
  String? _ageError;



  bool _isUnderAge(String yearStr) {
    int? birthYear = int.tryParse(yearStr);
    int currentYear = DateTime
        .now()
        .year;

    if (yearStr.length != 4) return false;
    if (birthYear == null) return false;
    int age = currentYear - birthYear;
    return age < 15;
  }



}
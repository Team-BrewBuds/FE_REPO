class SignUp {
  String nickname;
  String birth_year;
  String gender;
  List<String>? coffee_life;
  bool is_certificated;
  Map<String, dynamic>? preferred_bean_taste;

  SignUp({
    this.nickname = '',
    this.birth_year = '',
    this.gender = '',
    this.coffee_life,
    this.is_certificated = false,
    this.preferred_bean_taste
});


  // JSON으로 변환하는 메소드
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'birth_year': birth_year,
      'gender': gender,
      'coffee_life': coffee_life,
      'is_certificated': is_certificated,
      'preferred_bean_taste': preferred_bean_taste,
    };
  }

  String? validationEmail(String email){
    return "success";
  }
}

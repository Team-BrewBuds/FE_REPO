/*  회원가입 json 형식
{
    "nickname": "명찬의닉네임12",         // 2~12자의 한글 또는 숫자
    "birth_year": "1992",                  // 4자리 숫자로 된 출생 연도
    "gender": "남",                          // 성별 ('남' 또는 '여')
    "coffee_life": ["cafe_tour", "coffee_study"],      // 중복 선택 가능한 커피 생활 (6개 중에서 선택)
    "is_certificated": true,               // 커피 자격증 여부 (있다: true, 없다: false)
    "preferred_bean_taste": {          // 선호하는 원두 맛
        "body": 4,                        // 바디감 (1~5)
        "acidity": 3,                      // 산미 (1~5)
        "bitterness": 2,                  // 쓴맛 (1~5)
        "sweetness": 5                     // 단맛 (1~5)
    }
}


 */

import 'dart:convert';

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

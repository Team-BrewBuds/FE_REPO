class SignUpLists {
  //첫 로그인 이미지
  final List<String> images = [
    'assets/images/cafe.png',
    'assets/images/coffeeEnjoy.png',
    'assets/images/maker.png',
  ];

  // 첫 로그인 멘트
  List<String> title_data = ["시음 기록", "원두 검색", "원두 추천",];

  List<String> content_data = ["오늘 경함한 원두의 맛을 기록해 보세요.",
    "오늘 경험할 원두를 필터로 검색해 보세요.",
    "내 커피 취향에 맞는 원두 추천을 받아보세요."
  ];

  //회원가입 선택사항 리스트
  final List<String> categories = ['바디감', '산미', '쓴맛', '단맛'];

  //회원가입 선택사항 리스트 #2
  final List<List<String>> labels = [
    ['가벼운', '약간 가벼운', '보통', '약간 무거운', '무거운'],
    ['약한', '약간 약한', '보통', '약간 강한', '강한'],
    ['약한', '약간 약한', '보통', '약간 강한', '강한'],
    ['약한', '약간 약한', '보통', '약간 강한', '강한'],
  ];

//회원가입 선택사항 리스트 #3
  final List<String> categories_en = [
    'body',
    'acidity',
    'bitterness',
    'sweetness'
  ];

//회원가입 선택사항 리스트 #4
  final List<double> strength = [1, 2, 3, 4, 5];

  // 커피생활 리스트
  final List<Map<String, String>> enjoyItems = [
    {
      "title": "커피 투어",
      "description": "내 취향의 원두를 찾기 위해서 커피 투어를 해요",
      "png": "coffeeEnjoy",
      "choice": "cafe_tour"
    },
    {
      "title": "커피 추출",
      "description": "집이나 회사에서 직접 추출한 커피를 마셔요",
      "png": "coffeeMaker",
      "choice": "coffee_extraction"
    },
    {
      "title": "커피 공부",
      "description": "커피 관련 지식을 쌓고 자격증취득을 위해 공부해요",
      "png": "cup",
      "choice": "coffee_study"
    },
    {
      "title": "커피 알바",
      "description": "본업은 있지만 커피를 좋아해서 커피 알바를 해요",
      "png": "partTime",
      "choice": "cafe_alba"
    },
    {
      "title": "커피 근무",
      "description": "커피 전문가가 되기 위해서 바리스타로 근무해요",
      "png": "maker",
      "choice": "cafe_work"
    },
    {
      "title": "커피 운영",
      "description": "커피 문화를 전달하기 위해서 카페를 직접 운영해요",
      "png": "cafe",
      "choice": "cafe_operation"
    },
  ];
}

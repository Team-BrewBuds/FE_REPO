import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpEnjoy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CoffeeLifestylePage(),
    );
  }
}

class CoffeeLifestylePage extends StatefulWidget {
  @override
  State<CoffeeLifestylePage> createState() => _CoffeeLifestylePageState();
}

class _CoffeeLifestylePageState extends State<CoffeeLifestylePage> {
  final List<Map<String, String>> items = [
    {
      "title": "커피 투어",
      "description": "내 취향의 원두를 찾기 위해서 커피 투어를 해요",
      "png": "coffeeEnjoy"
    },
    {
      "title": "커피 추출",
      "description": "집이나 회사에서 직접 추출한 커피를 마셔요",
      "png": "coffeeMaker"
    },
    {
      "title": "커피 공부",
      "description": "커피 관련 지식을 쌓고 자격증취득을 위해 공부해요",
      "png": "cup"
    },
    {
      "title": "커피 알바",
      "description": "본업은 있지만 커피를 좋아해서 커피 알바를 해요",
      "png": "partTime"
    },
    {
      "title": "커피 근무",
      "description": "커피 전문가가 되기 위해서 바리스타로 근무해요",
      "png": "maker"
    },
    {
      "title": "커피 운영",
      "description": "커피 문화를 전달하기 위해서 카페를 직접 운영해요",
      "png": "cafe"
    },
  ];

  List<bool> selectedItems = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(),),
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Container(
                      width: 84.25,
                      height: 2,
                      decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                    ),
                  ),Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Container(
                      width: 84.25,
                      height: 2,
                      decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                    ),
                  ),Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Container(
                      width: 84.25,
                      height: 2,
                      decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                    ),
                  ),Container(
                    width: 84.25,
                    height: 2,
                    decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '커피 생활을 어떻게 즐기세요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('최대 6개까지 선택할 수 있어요.'),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedItems[index] = !selectedItems[index];
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedItems[index]
                              ? Colors.red
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      color: selectedItems[index] ? Color(0xFFFFF7F5) : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              "assets/images/${items[index]['png']}.png"),
                          SizedBox(height: 10),
                          Text(
                            items[index]['title']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              items[index]['description']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 46.0, left: 16, right: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('다음'),
            onPressed: () {
              context.push("/signup/cert");
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/features/signup/models/signup_lists.dart';
import 'package:brew_buds/features/signup/provider/SignUpProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  final SignUpLists lists = SignUpLists();

  List<bool> selectedItems = List.generate(6, (_) => false);
  List<String> selectedChoices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text('회원가입'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: Container(
                        width: 84.25,
                        height: 2,
                        decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 2),
                      child: Container(
                        width: 84.25,
                        height: 2,
                        decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                      ),
                    ),
                    Container(
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
                itemCount: lists.enjoyItems.length,
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
                        // 선택된 아이템을 업데이트
                        if (selectedItems[index]) {
                          selectedChoices.add(lists.enjoyItems[index]['choice']!);
                        } else {
                          selectedChoices.remove(lists.enjoyItems[index]['choice']!);
                        }

                        print(selectedChoices);
                      });
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedItems[index]
                              ? Colors.red
                              : ColorStyles.gray30,
                          width: 2,
                        ),
                      ),
                      color: selectedItems[index] ? Color(0xFFFFF7F5) : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              "assets/images/${lists.enjoyItems[index]['png']}.png"),
                          SizedBox(height: 10),
                          Text(
                            lists.enjoyItems[index]['title']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              lists.enjoyItems[index]['description']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 46.0, left: 16, right: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('다음'),
            onPressed: selectedChoices.isNotEmpty ? () {
              context.read<SignUpProvider>().getCoffeeLife(selectedChoices);
              context.push("/signup/cert");
            } : null, // 선택된 아이템이 없으면 비활성화
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: selectedChoices.isNotEmpty ? Colors.black : ColorStyles.gray30,
                foregroundColor: ColorStyles.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ),
    );
  }
}

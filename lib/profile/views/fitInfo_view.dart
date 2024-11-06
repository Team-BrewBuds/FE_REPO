import 'package:brew_buds/features/signup/views/signup_cert_page.dart';
import 'package:brew_buds/features/signup/views/signup_page_enjoy.dart';
import 'package:brew_buds/features/signup/views/signup_select_page.dart';
import 'package:flutter/material.dart';

import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../../features/signup/models/signup_lists.dart';

class FitInfoView extends StatefulWidget {
  const FitInfoView({super.key});

  @override
  State<FitInfoView> createState() => _FitInfoViewState();
}

class _FitInfoViewState extends State<FitInfoView> {

  final SignUpLists lists = SignUpLists();
  List<bool> selectedItems = List.generate(6, (_) => false);
  List<String> selectedChoices = [];
  bool? hasCertificate;
  List<int?> selectedIndices = List.filled(4, null);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65.0), // 제목 왼쪽 여백 추가
          child: Text('맞춤 정보'),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                '저장',
                style: TextStyle(color: ColorStyles.red, fontSize: 20),
              )),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            // 커피 생활 선택
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '커피 생활을 어떻게 즐기세요?',
                            style: TextStyles.title04SemiBold,
                          ),
                          Text(
                            '최대 6개까지 선택할 수 있어요.', style: TextStyles.textlightRegular,
                          ),
                        ],
                      ),
                    )
                  ]
              ),
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
                        color: selectedItems[index] ? Colors.red : ColorStyles.gray30,
                        width: 2,
                      ),
                    ),
                    color: selectedItems[index] ? Color(0xFFFFF7F5) : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/${lists.enjoyItems[index]['png']}.png"),
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

            // 자격증 여부
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '커피 관련 자격증이 있으세요?',
                            style: TextStyles.title04SemiBold,
                          ),
                          const Text(
                            '현재, 취득한 자격증이 있는지 알려주세요..', style: TextStyles.textlightRegular,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(
                                          () {
                                        hasCertificate = true;
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hasCertificate == true ? Colors.red : Colors.white,
                                    side: BorderSide(color: hasCertificate == true ? Colors.red : Colors.grey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child:  Text(
                                    '있어요',
                                    style: TextStyle(color: hasCertificate == true ? Colors.white : Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(
                                          () {
                                        hasCertificate = false;
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hasCertificate == false ? Colors.red : Colors.white,
                                    side: BorderSide(
                                      color: hasCertificate == false ? Colors.red : Colors.grey,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    '없어요',
                                    style: TextStyle(color: hasCertificate == false ? Colors.white : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]
              ),
            ),

            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '평소에 어떤 커피를 즐기세요?',
                            style: TextStyles.title04SemiBold,
                          ),
                          const Text(
                            '버디 님의 커피 취향에 꼭 맞는 원두를 맞나보세요', style: TextStyles.textlightRegular,
                          ),

                        ],
                      ),
                    )
                  ]
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(lists.categories.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(lists.categories[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      buildSelector(index)
              
                    ],
                  );
                }),
              ),
            ),








            // 커피 취향도 선택

          ],
        ),
      ));



  }


  Widget buildSelector(int categoryIndex) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                if (index == 4 || index == 0) return SizedBox(width: 20);
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              bool isSelected = selectedIndices[categoryIndex] == index;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndices[categoryIndex] = index;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: isSelected
                          ? BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? ColorStyles.gray : Colors.grey),
                      )
                          : null,
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? ColorStyles.gray : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    lists.labels[categoryIndex][index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? ColorStyles.gray : Colors.black,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }


}


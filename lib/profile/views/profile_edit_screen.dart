import 'dart:convert';

import 'package:brew_buds/common/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/text_styles.dart';
import '../../features/signup/models/signup_lists.dart';


class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}



class _ProfileEditScreenState extends State<ProfileEditScreen> {

  final SignUpLists lists = SignUpLists();

  List<bool> selectedItems = List.generate(6, (_) => false);
  List<String> selectedChoices = [];

  String _imagePath = '';

  Future<void> _pickProfileImage() async {
   // final ImagePicker picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65.0), // 제목 왼쪽 여백 추가
          child: Text('프로필 편집'),
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset('assets/images/maker.png',width: 100.0,height: 100.0,
                        fit: BoxFit.cover,
                      ), // child: Image.
                    ), GestureDetector(
                      // onTap: _pickImage, // 카메라 클릭 시 이미지 선택
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // 아이콘 배경 색상
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(8.0), // 아이콘 여백
                        child: Icon(
                          Icons.camera_alt, // 카메라 아이콘
                          color: Colors.black, // 아이콘 색상
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('닉네임', style: TextStyles.title03SemiBold),
              const SizedBox(height: 5,),
              TextFormField(
                  cursorColor: ColorStyles.gray40,
                decoration: _TextFormFieldStyles.getInputDecoration(
                )
              ),
              const SizedBox(height: 10,),
              const Text('닉네임은 14일 동안 최대 2번까지 변경할 수 있어요', style: TextStyle(
                fontSize: 13, color: ColorStyles.gray50
              ),),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('소개', style: TextStyles.title03SemiBold),
                ],
              ),

              const SizedBox(height: 5,),

                SizedBox(
                  height: 100,
                  child: TextFormField(
                     cursorColor: ColorStyles.gray40,
                      decoration: _TextFormFieldStyles.getInputDecoration(
                        hintText: '버디님을 자유롭게 소개해 주세요.',
                      ),
                    maxLength: 150,
                    maxLines: 5,
                  ),
                ),

              const SizedBox(height: 20,),
              const Text('링크', style: TextStyles.title03SemiBold),
              const SizedBox(height: 5,),
              TextFormField(
                  cursorColor: ColorStyles.gray40,
                  decoration: _TextFormFieldStyles.getInputDecoration(
                    hintText: 'URL을 입력해 주세요.'
                  )
              ),
              const SizedBox(height: 20,),
              const Text('커피 생활', style: TextStyles.title03SemiBold),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Expanded(
                    flex: 2,
                    child: TextFormField(
                        cursorColor: ColorStyles.gray40,
                        decoration: _TextFormFieldStyles.getInputDecoration(
                          hintText: '커피 생활을 어떻게 즐기는지 알려주세요.'
                        )
                    ),
                  ),
                  SizedBox(width: 8,),
                  Container(
                    height: 55.0,
                    child: Expanded(
                        flex: 1,
                        child: ElevatedButton(onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context){
                                return SingleChildScrollView(
                                  child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(16),
                                    // height: 750,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: 45,),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  '커피 생활',
                                                  style: TextStyle(color: ColorStyles.black, fontSize: 17),
                                                ),
                                              ),
                                            ),
                                           IconButton(onPressed: (){
                                             Navigator.pop(context);
                                           }, icon: const Icon(CupertinoIcons.xmark))
                                          ]
                                        ),
                                        const Divider(),
                                  
                                  
                                  
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
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                  child: ElevatedButton(onPressed: (){

                                                  }, child: Text('초기화'),

                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorStyles.gray30,
                                                    foregroundColor: ColorStyles.black,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                                                    ),
                                                  ))),
                                              SizedBox(width: 5,),
                                              Expanded(
                                                  flex: 3,
                                                  child: ElevatedButton(onPressed: (){

                                                  }, child: Text('적용하기'),
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: selectedChoices.length > 0  ? ColorStyles.gray20 : ColorStyles.gray30 ,
                                                          foregroundColor: ColorStyles.black,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0)
                                                        )
                                                        
                                                        
                                                        
                                                        
                                                  ))),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              side: BorderSide(
                                color: ColorStyles.gray30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                              ),
                              backgroundColor: ColorStyles.gray30,
                              foregroundColor: ColorStyles.black,
                            ),
                            child: Text('정보 설정', style: TextStyles.title02SemiBold,))),
                  )
                ],
              ),

              const SizedBox(height: 10,),
              const Text('간단한 정보 설정으로 내 커피 생활을 알릴 수 있어요.', style: TextStyle(
                  fontSize: 13, color: ColorStyles.gray50
              ),),
            ],
          ),
        ),
      ),
    );
  }


}

class _TextFormFieldStyles {

  static InputDecoration getInputDecoration({
    EdgeInsets ?  padding,
    String ? hintText

  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: ColorStyles.gray40,
        fontSize: 13
      ),
      contentPadding: padding,
      border: OutlineInputBorder(
        borderSide: BorderSide(// 테두리 색상
          width: 2.0, // 테두리 두께
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey, // 포커스 시 테두리 색상
          width: 2.0,
        ),
      ),

    );
  }


}



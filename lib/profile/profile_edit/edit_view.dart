import 'dart:developer';
import 'dart:io';

import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/profile/profile_edit/edit_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import '../../common/text_styles.dart';
import '../../features/signup/models/signup_lists.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {


  final TextEditingController _nickNameTextController = TextEditingController( );
  final TextEditingController _infoTextController = TextEditingController();
  final TextEditingController _linkTextController = TextEditingController();
  late List<TextEditingController> _coffeLifeTextController = [];

  // 프로필 이미지 변경
  final ImagePicker _picker = ImagePicker();
  File? _profileFile;



  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (pickedFile != null) {
      setState(() {
        _profileFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Consumer<ProfileEditPresenter>(
        builder: (BuildContext context, ProfileEditPresenter provider,
            Widget? child) {
          return SingleChildScrollView(
            child: Container(
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
                              child: _profileFile != null
                                  ? Image.file(
                                      _profileFile!,
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.cover,
                                    )
                                  : const Text('') // child: Image.
                              ),
                          GestureDetector(
                            onTap: _pickImage, // 카메라 클릭 시 이미지 선택
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
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                        controller: _nickNameTextController,

                        cursorColor: ColorStyles.gray40,
                        decoration: _TextFormFieldStyles.getInputDecoration()),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '닉네임은 14일 동안 최대 2번까지 변경할 수 있어요',
                      style: TextStyle(fontSize: 13, color: ColorStyles.gray50),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('소개', style: TextStyles.title03SemiBold),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        controller: _infoTextController,
                        cursorColor: ColorStyles.gray40,
                        decoration: _TextFormFieldStyles.getInputDecoration(
                          hintText: '버디님을 자유롭게 소개해 주세요.',
                        ),
                        maxLength: 150,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('링크', style: TextStyles.title03SemiBold),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                        controller: _linkTextController,
                        cursorColor: ColorStyles.gray40,
                        decoration: _TextFormFieldStyles.getInputDecoration(
                            hintText: 'URL을 입력해 주세요.')),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('커피 생활', style: TextStyles.title03SemiBold),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                              height: 25.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: provider.selectedChoices.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      child: ButtonFactory.buildOvalButton(
                                          onTapped: () {},
                                          text: provider.selectedChoices[index],
                                          style: OvalButtonStyle.fill(
                                            color: ColorStyles.black,
                                            textColor: ColorStyles.white,
                                            size: OvalButtonSize.medium,
                                          )),
                                    );
                                  })),
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          child: IconButton(
                              onPressed: provider.clearChoices,
                              icon: SvgPicture.asset('assets/icons/x_round.svg')),
                        ),

                        // 정보 설정 버튼
                        SizedBox(
                          height: 55.0,
                          width: 100.0, // 버튼의 너비를 고정
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                            setState) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.all(16),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(width: 45),
                                                  Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        '커피 생활',
                                                        style: TextStyle(
                                                          color:
                                                              ColorStyles.black,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(
                                                        CupertinoIcons.xmark),
                                                  ),
                                                ],
                                              ),
                                              // card ui
                                              const Divider(),
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.all(16),
                                                itemCount: provider
                                                    .lists.enjoyItems.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.8,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        provider
                                                            .cardChoices(index);
                                                      });
                                                    },
                                                    child: Card(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        side: BorderSide(
                                                          color:
                                                              provider.selectedItems[
                                                                      index]
                                                                  ? Colors.red
                                                                  : ColorStyles
                                                                      .gray30,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      color: provider
                                                                  .selectedItems[
                                                              index]
                                                          ? Color(0xFFFFF7F5)
                                                          : Colors.white,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              "assets/images/${provider.lists.enjoyItems[index]['png']}.png"),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            provider.lists
                                                                    .enjoyItems[
                                                                index]['title']!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              provider.lists
                                                                          .enjoyItems[
                                                                      index][
                                                                  'description']!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          provider
                                                              .clearChoices();
                                                        });
                                                      },
                                                      child: Text('초기화'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            ColorStyles.gray30,
                                                        foregroundColor:
                                                            ColorStyles.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 3,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('적용하기'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: provider
                                                                .selectedChoices
                                                                .isEmpty
                                                            ? ColorStyles.gray20
                                                            : ColorStyles
                                                                .gray30,
                                                        foregroundColor: provider
                                                                .selectedChoices
                                                                .isEmpty
                                                            ? ColorStyles.gray30
                                                            : ColorStyles.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              side: BorderSide(
                                color: ColorStyles.gray30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: ColorStyles.gray30,
                              foregroundColor: ColorStyles.black,
                            ),
                            child: Text(
                              '정보 설정',
                              style: TextStyles.bodyRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '간단한 정보 설정으로 내 커피 생활을 알릴 수 있어요.',
                      style: TextStyle(fontSize: 13, color: ColorStyles.gray50),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TextFormFieldStyles {
  static InputDecoration getInputDecoration(
      {EdgeInsets? padding, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: ColorStyles.gray40, fontSize: 13),
      contentPadding: padding,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          // 테두리 색상
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

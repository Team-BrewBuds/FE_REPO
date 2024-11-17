import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/home/all/home_all_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/text_styles.dart';

class AccountOutView extends StatefulWidget {
  const AccountOutView({super.key});

  @override
  State<AccountOutView> createState() => _AccountOutViewState();
}

class _AccountOutViewState extends State<AccountOutView> {
  bool _check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원 탈퇴',
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '버디님, 브루버즈와 함께하며\n내 커피 취향을 찾으셨나요?',
              style: TextStyles.title05Bold,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '만약,버디님이 아직 내 커피 취향을 못찾았다면\n브루버즈와 다시 함께해봐요!',
              style: TextStyles.title02SemiBold,
            ),
            SizedBox(
              height: 100,
            ),
            Text.rich(
              TextSpan(
                text: '버디님 탈퇴하기 전 아래 내용을 확인해주세요.\n\n'
                    '버디님의 모든 활동 정보는 다른 회원이 식별 할 수 없도록 바로 삭제되며, 삭제된 데이터는 복구 할 수 없어요. '
                    '(닉네임, 프로필 사진, 작성한 커피노트, 찜한 원두, 저장한 커피노트, 취향 리포트, 팔로워, 팔로잉, 댓글, 좋아요 내역 등)\n'
                    '탈퇴 후 ',
                style: TextStyles.captionMediumRegular,
                children: [
                  TextSpan(
                    text: '30일 동안 ', // '30' 부분만 굵게
                    style: TextStyles.captionMediumRegular
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '브루버즈에 다시 가입할 수 없어요.',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _check = !_check;
                        print(_check);
                      });
                    },
                    icon: _check
                        ? Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: Colors.red,
                          )
                        : Icon(CupertinoIcons.circle)),
                Text('안내 사항을 확인하였으며, 이에 동의합니다.'),
              ],
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _check
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => step_1()))
                      : null;
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: _check ? Colors.black : ColorStyles.gray30,
                  foregroundColor: ColorStyles.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class step_1 extends StatefulWidget {
  const step_1({super.key});

  @override
  State<step_1> createState() => _step_1State();
}

class _step_1State extends State<step_1> {
  List<String> _reasons = [
    '시음 기록 과정이 복잡해요.',
    '원두 정보가 부족해요.',
    '원두 추천이 만족스럽지 못해요.',
    '렉이 걸리고 속도가 느려서 불편해요.',
    '사용 도중에 오류가 많아서 불편해요.',
    '원하는 기능이 없거나 이용이 불편해요.',
    '대체할 만한 다른 서비스가 있어요.',
    '비매너 버디를 만났어요',
    '운영 정책에 아쉬운 부분이 있어요.'
  ];

  int? _selectedIndex;
  List<bool> _checks = [];

  @override
  void initState() {
    // TODO: implement initState
    _checks = List<bool>.filled(_reasons.length, false);
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정말 탈퇴 하시겠어요?',style: TextStyles.title02SemiBold,
          textAlign: TextAlign.center
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },

                ),
                TextButton(
                  child: const Text('탈퇴하기'),
                  onPressed: () {
                    //탈퇴하기  로직 구현 예정.
                  },
                ),
              ],
            )


          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원 탈퇴',
        ),
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '탈퇴하시려는 이유를 선택해 주세요.',
                  style: TextStyles.title04SemiBold,
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _reasons.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(_selectedIndex == index){
                                    } else {
                                      _selectedIndex = index;
                                    }

                                  });
                                },
                                icon: _selectedIndex == index
                                    ? Icon(
                                  CupertinoIcons.check_mark_circled_solid,
                                  color: Colors.red,
                                )
                                    : Icon(CupertinoIcons.circle)),
                            Text(_reasons[index]),
                          ],
                        );
                      }),
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        context.go('/home/all');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAllView()));
                      },
                      child: Text(
                        '브루버즈와 다시 함께할래요',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: ColorStyles.gray50,
                            color: ColorStyles.gray50),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showMyDialog();


                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: _selectedIndex != null ? ColorStyles.black : ColorStyles.gray30 ,
                      foregroundColor: ColorStyles.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('회원 탈퇴하기'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


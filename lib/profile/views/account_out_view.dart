import 'package:brew_buds/di/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: Text('회원 탈퇴',),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 30,horizontal: 15),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('버디님, 브루버즈와 함께하며\n내 커피 취향을 찾으셨나요?', style: TextStyles.title05Bold,),
            SizedBox(height: 30,),
            Text('만약,버디님이 아직 내 커피 취향을 못찾았다면\n브루버즈와 다시 함께해봐요!', style: TextStyles.title02SemiBold,),
            SizedBox(height: 100,),
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
                    style: TextStyles.captionMediumRegular.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '브루버즈에 다시 가입할 수 없어요.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 250,),
            Row(
              children: [
                IconButton(onPressed: (){
                  setState(() {
                    _check =! _check;
                    print(_check);
                  });
                }, icon: _check ?  Icon(CupertinoIcons.check_mark_circled_solid,color: Colors.red,): Icon(CupertinoIcons.circle) ),
                Text('안내 사항을 확인하였으며, 이에 동의합니다.'),

              ],
            ),
            ElevatedButton(onPressed: (){
              if(_check)
              Navigator.push(context, MaterialPageRoute(builder: (context) => step_1()));
            }, child: Text('다음'))
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 탈퇴',),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 30,horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('탈퇴하시려는 이유를 선택해 주세요.', style: TextStyles.title04SemiBold,),
          ],
        ),
      ),
    );
  }
}


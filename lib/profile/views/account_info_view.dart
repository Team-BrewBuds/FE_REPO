import 'package:animations/animations.dart';
import 'package:brew_buds/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../../data/repository/profile_repository.dart';

class ProfileAccountInfoView extends StatefulWidget {
  const ProfileAccountInfoView({super.key});



  @override
  State<ProfileAccountInfoView> createState() => _ProfileAccountInfoViewState();

}

class _ProfileAccountInfoViewState extends State<ProfileAccountInfoView> {
  List<String> title = ['가입일', '로그인 유형', '성별', '태어난 연도'];
  List<String> user = ['2024년 11월 6일', '카카오', '남성', '1999'];
  final ProfileRepository _repository = ProfileRepository();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('계정 정보'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Divider(),
          ListView.separated(
            shrinkWrap: true,
            itemCount: title.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            children: [
                              Text(
                                title[index],

                              ),
                              index == 2 || index == 3
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        "assets/icons/i_state.svg",
                                        width: 15,
                                        color: ColorStyles.gray70,
                                      ),
                                    )
                                  : Container(
                              )
                            ]),
                        Text(
                          user[index],
                        )
                      ]));
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          ),
        ]),
      ),
    );
  }
}

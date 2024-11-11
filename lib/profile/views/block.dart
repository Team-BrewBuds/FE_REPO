import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/profile/presenter/edit_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/text_styles.dart';
import '../../model/recommended_user.dart';
import '../../model/user.dart';

class BlockView extends StatefulWidget {
  const BlockView({super.key});

  @override
  State<BlockView> createState() => _BlockViewState();
}

class _BlockViewState extends State<BlockView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('버디 계정'),
        ),
        body: Consumer<ProfileEditPresenter>(
          builder: (BuildContext context, ProfileEditPresenter provider,
              Widget? child) {
            return provider.dummyRecommendedUsers == null
                ? Center(
                    child: Text('차단한 버디가 없어요.', style: TextStyles.textlightRegular,),
                  )
                : Container(
                    child: ListView.builder(
                        itemCount: provider.dummyRecommendedUsers.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 15.0, left: 10.0,right: 10.0),
                                child: ClipOval(
                                          child: Image.network(
                                            provider.dummyRecommendedUsers[index]
                                                .user.profileImageUri,
                                            height: 50.0,
                                            width:50.0,
                                            fit: BoxFit.cover
                                            ,
                                          ),

                                    ),
                              ),
                              Expanded(
                                  child: Text(provider
                                      .dummyRecommendedUsers[index]
                                      .user
                                      .nickname,
                                  textAlign: TextAlign.start)),

                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                  child: ElevatedButton(onPressed: (){

                                     //  차단 해제 로직 api


                                  },
                                      child: Text('차단 해제'),
                                   style: ElevatedButton.styleFrom(
                                     backgroundColor: Colors.black,
                                     foregroundColor: Colors.white

                                   ),)

                              )
                            ],
                          );
                        }),
                  );
          },
        ));
  }
}

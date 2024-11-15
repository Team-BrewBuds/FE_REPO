import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/profile/presenter/edit_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../../model/recommended_user.dart';
import '../../model/user.dart';

class BlockView extends StatefulWidget {
  const BlockView({super.key});

  @override
  State<BlockView> createState() => _BlockViewState();
}

class _BlockViewState extends State<BlockView> {
  bool _isContainerVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: ColorStyles.gray90,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '차단하게 되면 차단한 버디의 계정, 커피 노트,\n반응이 노출되지 않아요. 상대방에게는 차단했다는 정보를 알리지 않아요.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('버디 계정'),
        ),
        body: Consumer<ProfileEditPresenter>(
          builder: (BuildContext context, ProfileEditPresenter provider,
              Widget? child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.0,horizontal: 10.0),
                  child: Container(
                      color: Colors.black,
                      child: _isContainerVisible
                          ? Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '차단하게 되면 차단한 버디의 계정, 커피 노트,\n반응이 노출되지 않아요. 상대방에게는 차단했다는 정보를 알리지 않아요.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 8.0,
                                  top: 8.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isContainerVisible =
                                            !_isContainerVisible;
                                      });
                                    },
                                    child: Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          : Container()),
                ),
                provider.dummyRecommendedUsers == null
                    ? Center(
                        child: Text(
                          '차단한 버디가 없어요.',
                          style: TextStyles.textlightRegular,
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: ListView.builder(
                              itemCount: provider.dummyRecommendedUsers.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: 15.0,
                                          left: 10.0,
                                          right: 10.0),
                                      child: ClipOval(
                                        child: Image.network(
                                          provider.dummyRecommendedUsers[index]
                                              .user.profileImageUri,
                                          height: 50.0,
                                          width: 50.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                            provider
                                                .dummyRecommendedUsers[index]
                                                .user
                                                .nickname,
                                            textAlign: TextAlign.start)),
                                    Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            //  차단 해제 로직 api
                                          },
                                          child: Text('차단 해제'),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              foregroundColor: Colors.white),
                                        ))
                                  ],
                                );
                              }),
                        ),
                      )
              ],
            );
          },
        ));
  }
}

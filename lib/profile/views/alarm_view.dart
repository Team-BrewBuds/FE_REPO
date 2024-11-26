import 'dart:developer';

import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/profile/presenter/alarm_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/text_styles.dart';

class AlarmView extends StatefulWidget {

   AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {

  late Future<bool> _status;

  @override
  void initState() {
    // TODO: implement initState
    _status = AlarmPresenter().NotificationPermissionCheck();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 설정'),
      ),
      body: FutureBuilder(future: _status,
          builder: (context, AsyncSnapshot<bool> snapshot) {

                  if(snapshot.hasData){
                    bool isPermissionGranted = snapshot.data!;
                    return Consumer<AlarmPresenter>(
                      builder: (context,AlarmPresenter _presenter,Widget? child){
                        return isPermissionGranted ? _PermissionAgree(_presenter) : _PermissionDeny(_presenter);
                      },
                    );
                  }else {
                    return Center(child: Text("알림 권한을 확인해주세요"));
                  }


      })
    );
  }

  Widget _PermissionDeny(AlarmPresenter _presenter){
    return  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 0.5,),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(_presenter.title[0]),
                    subtitle: Text(_presenter.content[0],style: TextStyles.textlightSmall,),
                    trailing: CupertinoSwitch(value: _presenter.list[0],
                        activeColor: ColorStyles.red,
                        onChanged :(value){
                          setState(() {
                            _presenter.saveSetting(0, value,_presenter.list);
                          });
                        }),
                  ),
                  SizedBox(height: 50.0,),
                  ListTile(
                    title: Text('마케팅'),),
                  Divider(thickness: 0.5,),
                  ListTile(
                    title: Text(_presenter.title[1]),
                    subtitle: Text(_presenter.content[1],style: TextStyles.textlightSmall,),
                    trailing: CupertinoSwitch(value: _presenter.list[1],
                        activeColor: ColorStyles.red,
                        onChanged :(value){
                          setState(() {
                            _presenter.saveSetting(1, value, _presenter.list);

                          });
                        }),
                  ),

                ],
              ),
            )
          ],
        )
    );
  }


  Widget _PermissionAgree(AlarmPresenter _presenter){
    return  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 0.5,),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(_presenter.title2[0]),
                    subtitle: Text(_presenter.content2[0],style: TextStyles.textlightSmall,),
                    trailing: CupertinoSwitch(value: _presenter.list2[0],
                        activeColor: ColorStyles.red,
                        onChanged :(value){
                          setState(() {
                            _presenter.saveSetting(0, value,_presenter.list2);
                          });
                        }),
                  ),
                  SizedBox(height: 50.0,),
                  ListTile(
                    title: Text('팔로우'),),
                  Divider(thickness: 0.5,),
                  ListTile(
                    title: Text(_presenter.title2[1]),
                    subtitle: Text(_presenter.content2[1],style: TextStyles.textlightSmall,),
                    trailing: CupertinoSwitch(value: _presenter.list2[1],
                        activeColor: ColorStyles.red,
                        onChanged :(value){
                          setState(() {
                            _presenter.saveSetting(1, value,_presenter.list2);

                          });
                        }),
                  ),
                  ListTile(
                    title: Text(_presenter.title2[2]),
                    subtitle: Text(_presenter.content2[2],style: TextStyles.textlightSmall,),
                    trailing: CupertinoSwitch(value: _presenter.list2[2],
                        activeColor: ColorStyles.red,
                        onChanged :(value){
                          setState(() {
                            _presenter.saveSetting(2, value,_presenter.list2);

                          });
                        }),
                  ),
                  ListTile(
                    title: Text('마케팅'),),
                  ListTile(
                    title: Text(_presenter.title2[3]),
                    subtitle: Text(_presenter.content2[3],style: TextStyles.textlightSmall,),
                    trailing: CupertinoSwitch(value: _presenter.list2[3],
                        activeColor: ColorStyles.red,
                        onChanged :(value){
                          setState(() {
                            _presenter.saveSetting(3, value,_presenter.list2);

                          });
                        }),
                  ),


                ],
              ),
            )
          ],
        )
    );
  }



}


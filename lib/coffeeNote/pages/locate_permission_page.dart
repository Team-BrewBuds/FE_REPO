import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/styles/text_styles.dart';
import '../../common/widget/CustomIconTextRow.dart';

class LocatePermissionPage extends StatefulWidget {
  const LocatePermissionPage({super.key});

  @override
  State<LocatePermissionPage> createState() => _LocatePermissionPageState();
}

class _LocatePermissionPageState extends State<LocatePermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0), // 오른쪽 여백 설정
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/x.svg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                'Brewbuds에서 회원님의 위치에 \n접근하도록 허용',
                style: TextStyles.title05Bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 48,
              ),
              CustomIconTextRow(
                iconPath: 'assets/icons/permission1.svg',
                title: '위치 서비스를 사용하는 방법',
                content:
                    '기기 위치를 설정하면 커피로그에 시음 장소를\n입력하는 등의 경우에 근처 장소를 둘러볼 수 있습니다.',
                iconWidth: 30,
                iconHeight: 30,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              CustomIconTextRow(
                iconPath: 'assets/icons/permission2.svg',
                title: '이 정보가 사용되는 방식',
                content: '기기 위치를 기반으로 근처 장소를 표시합니다.',
                iconWidth: 30,
                iconHeight: 30,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              CustomIconTextRow(
                iconPath: 'assets/icons/permission3.svg',
                title: '이 권한 관리 방법',
                content: '기기 설정에서 언제든지 변경할 수 있습니다.',
                iconWidth: 30,
                iconHeight: 30,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 46, top: 24, right: 16, left: 16),
            child: ButtonFactory.buildRoundedButton(
                onTapped: () {
                  _getLocation();
                  _checkLocation();
                },
                text: '다음',
                style: RoundedButtonStyle.fill(
                    size: RoundedButtonSize.xLarge, color: Colors.black))));
  }

  Future<void> _getLocation() async {
    // 권한 요청
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always) {
      // 권한이 영구적으로 거부된 경우
      print('위치 권한이 거부되었습니다. 앱에서 권한 설정을 변경해야 합니다.');
    } else if (permission == LocationPermission.denied) {
      // 권한이 거부된 경우
      print('위치 권한이 필요합니다.');
    } else {
      // 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('위치: ${position.latitude}, ${position.longitude}');
    }
  }

  Future<bool> _checkLocation() async{
    LocationPermission permission = await Geolocator.requestPermission();

    print(permission);

    return true;
  }
}

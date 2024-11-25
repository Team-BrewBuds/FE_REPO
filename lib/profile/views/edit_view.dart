import 'dart:developer';
import 'dart:io';

import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/data/profile/profile_api.dart';
import 'package:brew_buds/data/profile/profile_repository.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/model/profile.dart';
import 'package:brew_buds/profile/presenter/edit_presenter.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../common/text_styles.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileRepository _repository = ProfileRepository();
  late TextEditingController _nickNameTextController = TextEditingController();
  final TextEditingController _infoTextController = TextEditingController();
  final TextEditingController _linkTextController = TextEditingController();
  late List<TextEditingController> _coffeLifeTextController = [];

  // 프로필 이미지 변경
  final ImagePicker _picker = ImagePicker();
  File? _profileFile;

// 프로필 이미지 선택
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (pickedFile != null) {
      setState(() {
        _profileFile = File(pickedFile.path);
      });
    }
  }



// 프로필 정보 가져오기
  Future<void> getProfile() async {
    Profile ? profile =  await _repository.fetchProfile();

    setState(() {
      _nickNameTextController.text = profile!.nickname;
      _infoTextController.text = profile.introduction!;
      _linkTextController.text = profile.profile_link!;

    });
  }


  @override
  void initState() {
    super.initState();
    getProfile();
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
              onPressed: () {
              },
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
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                      width: 0.5, color: ColorStyles.black),
                                ),
                                child: Container()),
                          ),
                          GestureDetector(
                            onTap:  (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => pickImage()),
                              );//
                            },
                            child: Container(
                              width: 30, height: 30,
                              decoration: BoxDecoration(
                                  color: ColorStyles.gray40, // 아이콘 배경 색상
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 0.5)),
                              // padding: EdgeInsets.all(10.0), // 아이콘 여백
                              child: Icon(
                                size: 20.0,
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
                        decoration: _TextFormFieldStyles.getInputDecoration(
                            hintText: _nickNameTextController.text
                            // labelText: _nickNameTextController.text,
                            )),
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
                              height: 50.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorStyles.gray80, width: 0.5)),
                              child: Row(

                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: provider.selectedChoices.length,
                                        padding: EdgeInsets.all(8.0),
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
                                        }),
                                  ),
                                  SizedBox(
                                    child: IconButton(
                                        onPressed: provider.clearChoices,
                                        icon: SvgPicture.asset(
                                            'assets/icons/x_round.svg')),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(width: 5),

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




class pickImage extends StatefulWidget {
  const pickImage({Key? key}) : super(key: key);

  @override
  State<pickImage> createState() => _pickImageState();
}

// 프로필 사진
class _pickImageState extends State<pickImage> {

  //앨범에서 이미지 가져오기
  List<AssetEntity> _imageAssets = [];
  List<File?> _imageFiles = [];
  bool _tap = false;



  // 카메라
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _cameraInitialized = false;





  @override
  void initState() {
    super.initState();
    _fetchImages();
    _initializeCamera();

  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController.initialize();
    _cameraInitialized = true;
  }



  Future<void> _fetchImages() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> images = await albums[0].getAssetListPaged(page: 0, size: 10);

      List<File?> files = await Future.wait(images.map((image) => image.file).toList());

      setState(() {
        _imageAssets = images;
        _imageFiles = files; // 파일 리스트 저장
      });
    } else {
      PhotoManager.openSetting();
    }
  }


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('프로필 사진', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.xmark, color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white70,
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            child: Text('다음'),
          ),
        ],
      ),
      body:  _cameraInitialized ?  FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            return
        _imageAssets.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [



                    // Positioned.fill(child: Image.asset('assets/images/coffee.jpeg', fit: BoxFit.cover,))

                  ],
                ),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(400),
                //   child: Container(
                //     color: Colors.white,
                //   ),
                // ),


              ),
              SizedBox(
                height: 35,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      TextButton(onPressed: (){}, child: Text('최근 항목', style: TextStyle(color: Colors.white),)),
                      Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white,)
                    ]
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0
                  ),
                  itemCount: _imageFiles.length ,
                  itemBuilder: (context, index) {
                    final file ;
                    if(index == 0){ // 카메라 삽입
                      file = _imageFiles[index + 1];
                      return GestureDetector(
                        onTap: () async{
                            try {
                              await _initializeControllerFuture;
                              final image = await _cameraController.takePicture();

                            } catch (e) {
                              print(e);
                            }
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 1,horizontal: 1),
                            color: ColorStyles.gray70,
                            child: SvgPicture.asset('assets/icons/camera.svg', color: Colors.white,

                              fit: BoxFit.scaleDown,)
                        ),
                      );
                    } else  {
                      file = _imageFiles[index -1];
                      return file != null

                          ? Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          GestureDetector(
                            onTap : (){
                              setState(() {

                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 1),
                              height: 100,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.circle))

                        ],

                      )
                          : Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        // height: 100,
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                  },
                ),
              ),
            ],
          ),
        );
      }) :
      Center(child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
      ),)


    );
  }
}



class _TextFormFieldStyles {
  static InputDecoration getInputDecoration(
      {EdgeInsets? padding, String? hintText, String? labelText}) {
    return InputDecoration(
      labelText: labelText,
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

import 'dart:io';
import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/profile/model/profile.dart';
import 'package:brew_buds/profile/presenter/edit_presenter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../common/styles/text_styles.dart';
import '../../features/signup/models/coffee_life.dart';

class ProfileEditScreen extends StatefulWidget {

  const ProfileEditScreen({super.key,});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nickNameTextController = TextEditingController();
  late TextEditingController _infoTextController = TextEditingController();
  late TextEditingController _linkTextController = TextEditingController();
  late List<CoffeeLife> _coffeLifes = [];

  // 프로필 이미지 변경
  final ImagePicker _picker = ImagePicker();
  File? _profileFile;

  late dynamic coffeeLife = '';
  List<CoffeeLife> selectedCoffeeLives = [];

  @override
  void initState() {
    super.initState();
  }

  void clearCoffeeLives() {
    setState(() {
      _coffeLifes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          '프로필 편집',
          style: TextStyles.title02SemiBold,
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                '저장',
                style:
                TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              )),
        ],
      ),
      body: Consumer<ProfileEditPresenter>(
        builder: (BuildContext context, ProfileEditPresenter provider,
            Widget? child) {
          return FutureBuilder<Profile>(
            future: provider.getProfile(),
            builder:(context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Loading indicator
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Error handling
              } else if (!snapshot.hasData) {
                return Center(child: Text('No Profile Found')); // Handle empty state
              } else {
                Profile profile = snapshot.data!;
                _nickNameTextController = TextEditingController(text: profile.nickname);
                _infoTextController = TextEditingController(text: profile.detail.introduction);
                _linkTextController = TextEditingController(text: profile.detail.profileLink);
                _coffeLifes = profile.detail.coffeeLife!;

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
                                      ),
                                      child: Image.network(profile.profileImageURI)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => pickImage()),
                                    ); //
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

                          // 닉네임
                          const Text('닉네임', style: TextStyles.title01SemiBold),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              controller: _nickNameTextController,
                              cursorColor: ColorStyles.gray40,
                              decoration: _TextFormFieldStyles.getInputDecoration(
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

                          //소개
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('소개', style: TextStyles.title01SemiBold),
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

                          //링크
                          const Text('링크', style: TextStyles.title01SemiBold),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              controller: _linkTextController,
                              cursorColor: ColorStyles.gray40,
                              decoration: _TextFormFieldStyles.getInputDecoration(
                                  hintText: profile.detail.profileLink ?? 'URL을 입력해 주세요.',
                            )),
                          const SizedBox(
                            height: 20,
                          ),

                          //커피 생활
                          const Text('커피 생활', style: TextStyles.title01SemiBold),
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
                                            child:ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: _coffeLifes.length,
                                                padding: EdgeInsets.all(8.0),
                                                itemBuilder: (context, index) {
                                                  print(_coffeLifes[index].title);
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                    child: ButtonFactory
                                                        .buildOvalButton(
                                                        onTapped: () {},
                                                        text: _coffeLifes[index].title,
                                                        style: OvalButtonStyle
                                                            .fill(
                                                          color: ColorStyles
                                                              .black,
                                                          textColor:
                                                          ColorStyles
                                                              .white,
                                                          size: OvalButtonSize
                                                              .medium,
                                                        )),
                                                  );
                                                })

                              ),
                                        SizedBox(
                                          child: IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  clearCoffeeLives();
                                                });

                                              },
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
                                                      itemCount:
                                                      CoffeeLife.values.length,
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
                                                                // isSelected
                                                                //     ? Colors.red
                                                                //     :
                                                                ColorStyles
                                                                    .gray30,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            color:
                                                            // isSelected
                                                            //     ? Color(0xFFFFF7F5)
                                                            //     :
                                                            Colors.white,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Image.asset(
                                                                    "${CoffeeLife
                                                                        .values[index]
                                                                        .imagePath}"),
                                                                SizedBox(height: 10),
                                                                Text(
                                                                  CoffeeLife
                                                                      .values[index]
                                                                      .title,
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
                                                                    CoffeeLife
                                                                        .values[index]
                                                                        .description,
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
                                                              backgroundColor:
                                                              // provider
                                                              //     .selectedCoffeeLives
                                                              //     .isEmpty
                                                              //     ? ColorStyles.gray20
                                                              //     :
                                                              ColorStyles
                                                                  .gray30,
                                                              foregroundColor:
                                                              // provider
                                                              //     .selectedCoffeeLives
                                                              //     .isEmpty
                                                              //     ?
                                                              //
                                                              // ColorStyles.gray30
                                                              //     :
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
              }

            },
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
    final PermissionState permission =
    await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> images =
      await albums[0].getAssetListPaged(page: 0, size: 10);

      List<File?> files =
      await Future.wait(images.map((image) => image.file).toList());

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
        body: _cameraInitialized
            ? FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              return _imageAssets.isEmpty
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
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  '최근 항목',
                                  style:
                                  TextStyle(color: Colors.white),
                                )),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Colors.white,
                            )
                          ]),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0),
                        itemCount: _imageFiles.length,
                        itemBuilder: (context, index) {
                          final file;
                          if (index == 0) {
                            // 카메라 삽입
                            file = _imageFiles[index + 1];
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  await _initializeControllerFuture;
                                  final image =
                                  await _cameraController
                                      .takePicture();
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 1),
                                  color: ColorStyles.gray70,
                                  child: SvgPicture.asset(
                                    'assets/icons/camera.svg',
                                    color: Colors.white,
                                    fit: BoxFit.scaleDown,
                                  )),
                            );
                          } else {
                            file = _imageFiles[index - 1];
                            return file != null
                                ? Stack(
                              alignment:
                              AlignmentDirectional.topEnd,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin:
                                    EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 1),
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
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                        CupertinoIcons.circle))
                              ],
                            )
                                : Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              // height: 100,
                              color: Colors.grey[300],
                              child: Center(
                                  child:
                                  CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            })
            : Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
        ));
  }
}

class _TextFormFieldStyles {
  static InputDecoration getInputDecoration({
    EdgeInsets? padding,
    String? hintText,
    String? labelText,
  }) {
    return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: ColorStyles.gray40, fontSize: 13),
        filled: true,
        fillColor: ColorStyles.gray10,
        contentPadding: padding,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0, // 테두리 두께
            color: ColorStyles.red,
          ),
          borderRadius: BorderRadius.zero, // borderRadius를 0으로 설정하여 직각 테두리로 만듬
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            // color: Colors.grey, // 포커스 시 테두리 색상
            width: 1.0,
            color: ColorStyles.gray50,
          ),
          borderRadius: BorderRadius.zero, // 포커스 시에도 직각 테두리로 유지
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            // color: Colors.grey, // 포커스 시 테두리 색상
            width: 1.0,
            color: ColorStyles.gray50,
          ),
          borderRadius: BorderRadius.zero, // 포커스 시에도 직각 테두리로 유지
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            // color: Colors.grey, // 포커스 시 테두리 색상
            width: 1.0,
            color: ColorStyles.gray50,
          ),
        ));
  }
}

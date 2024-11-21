import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../common/color_styles.dart';

class ProfileImageEdit extends StatefulWidget {
  const ProfileImageEdit({Key? key}) : super(key: key);

  @override
  State<ProfileImageEdit> createState() => _ProfileImageEditState();
}

// 프로필 사진
class _ProfileImageEditState extends State<ProfileImageEdit> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImagePath;



  //앨범에서 이미지 가져오기
  List<AssetEntity> _imageAssets = [];
  List<File?> _imageFiles = [];
  bool _tap = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  // 카메라
  CameraController? _cameraController;

  Future<void>? _initializeControllerFuture;
  bool _cameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    }
    await _cameraController?.initialize();

    if (mounted) {
      setState(() {});
    }
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
    _cameraController?.dispose();
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
        body: _cameraController == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  return _imageAssets.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : _pickImageWidget();
                }));
  }

  //카메라 및 앨범
  Widget _pickImageWidget() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. 프로필 이미지
                  Container(
                    width: 500, // 원하는 크기
                    height: 500, // 원하는 크기
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300], // 기본 배경색
                      image: _profileImagePath != null
                          ? DecorationImage(
                        image: FileImage(File(_profileImagePath!)),
                        fit: BoxFit.cover,
                      )
                          : DecorationImage(
                        image: AssetImage('assets/default_profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 2. 동그란 수정 아이콘
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded(
          //  child: Container(
          //    child: _cameraController == null || !_cameraController!.value.isInitialized ? Center(child: CircularProgressIndicator(),) :
          //        CameraPreview(_cameraController)
          //  )
          // ),
          SizedBox(
            height: 35,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '최근 항목',
                    style: TextStyle(color: Colors.white),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0),
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                final file;
                //1열 1행  카메라 삽입
                if (index == 0) {
                  file = _imageFiles[index + 1];
                  return GestureDetector(
                    onTap: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _cameraController?.takePicture();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 1),
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
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 1),
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
                                icon: Icon(CupertinoIcons.circle))
                          ],
                        )
                      : Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
  }
}

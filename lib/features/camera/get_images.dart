import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../common/color_styles.dart';
import 'image_presenter.dart';

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
    // final image_provider = Provider.of<ImagePresenter>(context);


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
                                    setState(() {

                                    });
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
                                    onPressed: () {

                                    },
                                    icon: Icon(CupertinoIcons.circle))
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

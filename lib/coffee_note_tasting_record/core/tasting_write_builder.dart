import 'package:brew_buds/camera/camera_screen.dart';
import 'package:brew_buds/coffee_note_tasting_record/tasting_write_first_screen.dart';
import 'package:brew_buds/coffee_note_tasting_record/tasting_write_presenter.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/photo/check_selected_images_screen.dart';
import 'package:brew_buds/photo/view/photo_grid_view_with_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

showTastingWriteScreen(BuildContext context) {
  showCupertinoModalPopup(
    barrierColor: ColorStyles.white,
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return _buildTastingWriteScreen(context);
    },
  );
}

Widget _buildTastingWriteScreen(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TastingWritePresenter()),
    ],
    child: MaterialApp(
      title: 'Brew Buds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        useMaterial3: true,
      ),
      home: GridPhotoViewWithPreview.build(
        permissionStatus: PermissionRepository.instance.photos,
        onDone: (context, images) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckSelectedImagesScreen(
                image: images,
                onNext: (context, imageDataList) {
                  context.read<TastingWritePresenter>().setImageData(imageDataList);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const TastingWriteFirstScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          );
        },
        onTapCamera: (context) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CameraScreen(
                previewShape: BoxShape.circle,
                onDone: (context, imageData) {
                  context.read<TastingWritePresenter>().setImageData([imageData]);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const TastingWriteFirstScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          );
        },
      ),
    ),
  );
}

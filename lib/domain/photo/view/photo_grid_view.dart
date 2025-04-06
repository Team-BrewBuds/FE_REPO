import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/domain/camera/camera_screen.dart';
import 'package:brew_buds/domain/photo/core/photo_grid_mixin.dart';
import 'package:brew_buds/domain/photo/presenter/photo_presenter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PhotoGridView extends StatefulWidget {
  final PermissionStatus _permissionStatus;
  final Function(BuildContext context, List<Uint8List> selectedImages) onDone;

  const PhotoGridView({
    super.key,
    required PermissionStatus permissionStatus,
    required this.onDone,
  }) : _permissionStatus = permissionStatus;

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();

  static Widget build({
    required PermissionStatus permissionStatus,
    required Function(BuildContext context, List<Uint8List> selectedImages) onDone,
  }) {
    return ChangeNotifierProvider<PhotoPresenter>(
      create: (context) => PhotoPresenter(permissionStatus: permissionStatus),
      child: PhotoGridView(
        permissionStatus: permissionStatus,
        onDone: onDone,
      ),
    );
  }
}

class _PhotoGridViewState extends State<PhotoGridView> with PhotoGridMixin<PhotoGridView, PhotoPresenter> {
  @override
  Color get backgroundColor => ColorStyles.white;

  @override
  PermissionStatus get permissionStatus => widget._permissionStatus;

  @override
  BoxShape get previewShape => BoxShape.rectangle;

  @override
  Function(BuildContext context, List<Uint8List> selectedImages) get onDone => widget.onDone;

  @override
  bool get showTitle => true;

  @override
  Function(BuildContext context) get onTapCameraButton => (context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          previewShape: BoxShape.rectangle,
          onDone: (context, imageData) {
            widget.onDone.call(context, [imageData]);
          },
          onTapAlbum: (context) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    PhotoGridView.build(permissionStatus: permissionStatus, onDone: onDone),
              ),
            );
          },
        ),
      ),
    );
  };

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        if (widget._permissionStatus == PermissionStatus.limited) ...[
          buildManagementButton(context),
          const SizedBox(height: 1),
        ],
        Expanded(
          child: Selector<PhotoPresenter, ImageViewState>(
            selector: (context, presenter) => presenter.imageViewState,
            builder: (context, imageViewState, child) {
              return _buildImages(
                context,
                images: imageViewState.images,
                selectedImages: imageViewState.selectedImages,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImages(
    BuildContext context, {
    required List<AssetEntity> images,
    required List<AssetEntity> selectedImages,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
          context.read<PhotoPresenter>().fetchPhotos();
        }
        return false;
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildCameraButton();
          } else {
            return buildImage(
              image: images[index - 1],
              selectedImages: selectedImages,
            );
          }
        },
      ),
    );
  }
}

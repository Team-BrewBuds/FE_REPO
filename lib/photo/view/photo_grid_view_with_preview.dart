import 'dart:typed_data';
import 'package:brew_buds/photo/check_selected_images_screen.dart';
import 'package:brew_buds/photo/core/photo_grid_mixin.dart';
import 'package:brew_buds/photo/model/album.dart';
import 'package:brew_buds/photo/presenter/photo_presenter.dart';
import 'package:brew_buds/photo/view/album_list_view.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class GridPhotoViewWithPreview extends StatefulWidget {
  final PermissionStatus _permissionStatus;
  final BoxShape _previewShape;
  final Function(BuildContext context) onCancel;
  final Function(BuildContext context, List<Uint8List> images) onDone;
  final Function(BuildContext context) onCancelCamera;
  final Function(BuildContext context, Uint8List? imageData) onDoneCamera;

  @override
  State<GridPhotoViewWithPreview> createState() => _GridPhotoViewWithPreviewState();

  const GridPhotoViewWithPreview({
    super.key,
    required PermissionStatus permissionStatus,
    BoxShape previewShape = BoxShape.rectangle,
    required this.onCancel,
    required this.onDone,
    required this.onCancelCamera,
    required this.onDoneCamera,
  })  : _permissionStatus = permissionStatus,
        _previewShape = previewShape;

  static Widget build({
    required PermissionStatus permissionStatus,
    required Function(BuildContext context) onCancel,
    required Function(BuildContext context, List<Uint8List> images) onDone,
    required Function(BuildContext context) onCancelCamera,
    required Function(BuildContext context, Uint8List? imageData) onDoneCamera,
    BoxShape previewShape = BoxShape.rectangle,
    bool canMultiSelect = true,
  }) {
    return ChangeNotifierProvider<PhotoPresenter>(
      create: (context) => PhotoPresenter(permissionStatus: permissionStatus, canMultiSelect: canMultiSelect),
      child: GridPhotoViewWithPreview(
        permissionStatus: permissionStatus,
        previewShape: previewShape,
        onCancel: onCancel,
        onDone: onDone,
        onCancelCamera: onCancelCamera,
        onDoneCamera: onDoneCamera,
      ),
    );
  }
}

class _GridPhotoViewWithPreviewState extends State<GridPhotoViewWithPreview>
    with PhotoGridMixin<GridPhotoViewWithPreview, PhotoPresenter> {
  @override
  PermissionStatus get permissionStatus => widget._permissionStatus;

  @override
  Color get backgroundColor => ColorStyles.black;

  @override
  BoxShape get previewShape => widget._previewShape;

  @override
  Function(BuildContext context) get onCancel => widget.onCancel;

  @override
  Function(BuildContext context, List<AssetEntity> selectedImages) get onDone =>
          (context, selectedImages) async {
        final List<Uint8List> imageDataList = [];
        for (final selectedImage in selectedImages) {
          final imageData = await selectedImage.originBytes;
          if (imageData != null) {
            imageDataList.add(imageData);
          }
        }

        if (context.mounted) {
          final result = await Navigator.of(context).push<List<Uint8List>>(
            MaterialPageRoute(
              builder: (context) =>
                  CheckSelectedImagesScreen(
                    shape: widget._previewShape,
                    image: imageDataList,
                  ),
            ),
          );
          if (context.mounted && result != null) {
            widget.onDone.call(context, result);
          }
        }
      };

  @override
  Function(BuildContext context) get onCancelCamera => widget.onCancelCamera;

  @override
  Function(BuildContext context, Uint8List? imageData) get onDoneCamera => widget.onDoneCamera;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Selector<PhotoPresenter, AssetEntity?>(
          selector: (context, presenter) => presenter.preview,
          builder: (context, preview, child) {
            return _buildPreview(preview);
          },
        ),
        Selector<PhotoPresenter, AlbumTitleState>(
          selector: (context, presenter) => presenter.albumTitleState,
          builder: (context, albumTitleState, child) {
            return _buildAlbumTitle(
              context,
              albumList: albumTitleState.albumList,
              albumTitle: albumTitleState.currentAlbum?.name ?? '',
            );
          },
        ),
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

  Widget _buildPreview(AssetEntity? preview) {
    return AspectRatio(
      aspectRatio: 1,
      child: preview != null
          ? widget._previewShape == BoxShape.rectangle
              ? AssetEntityImage(preview, fit: BoxFit.cover)
              : Stack(
                  children: [
                    Positioned.fill(child: AssetEntityImage(preview, fit: BoxFit.cover)),
                    Positioned.fill(child: CustomPaint(painter: _CircleCropOverlayPainter())),
                  ],
                )
          : Container(color: ColorStyles.gray50),
    );
  }

  Widget _buildAlbumTitle(BuildContext context, {required List<Album> albumList, required String albumTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: albumList.isNotEmpty && albumTitle.isNotEmpty
          ? Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumListView(albumList: albumList),
                      ),
                    );
                    if (result != null && context.mounted) {
                      context.read<PhotoPresenter>().onChangeAlbum(result);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(albumTitle, style: TextStyles.title01SemiBold.copyWith(color: Colors.white)),
                      SvgPicture.asset(
                        'assets/icons/down.svg',
                        height: 18,
                        width: 18,
                        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
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
          crossAxisCount: 4,
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

class _CircleCropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.7);
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 원형 크롭 영역 만들기
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width * 0.49, // 원 크기 조절
    ));

    path.fillType = PathFillType.evenOdd; // 내부 원을 투명하게 만듦
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

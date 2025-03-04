import 'package:brew_buds/camera/camera_screen.dart';
import 'package:brew_buds/photo/check_selected_images_screen.dart';
import 'package:brew_buds/photo/presenter/photo_presenter.dart';
import 'package:brew_buds/photo/view/album_list_view.dart';
import 'package:brew_buds/photo/widget/management_bottom_sheet.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/permission/permission_denied_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class GridPhotoViewWithPreview extends StatefulWidget {
  final PermissionStatus _permissionStatus;
  final BoxShape _previewShape;

  const GridPhotoViewWithPreview({
    super.key,
    required PermissionStatus permissionStatus,
    BoxShape previewShape = BoxShape.rectangle,
  })  : _permissionStatus = permissionStatus,
        _previewShape = previewShape;

  @override
  State<GridPhotoViewWithPreview> createState() => _GridPhotoViewWithPreviewState();
}

class _GridPhotoViewWithPreviewState extends State<GridPhotoViewWithPreview> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PhotoPresenter>().initState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._permissionStatus) {
      case PermissionStatus.granted || PermissionStatus.limited:
        return Scaffold(
          backgroundColor: ColorStyles.black,
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: Column(
              children: [
                _buildPreview(),
                _buildAlbumTitle(),
                if (widget._permissionStatus == PermissionStatus.limited) ...[
                  _buildManagementButton(context),
                  const SizedBox(height: 1),
                ],
                Expanded(child: _buildImages(context)),
              ],
            ),
          ),
        );
      default:
        return PermissionDeniedView.photo();
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      centerTitle: false,
      backgroundColor: ColorStyles.black,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
              ),
            ),
            const Spacer(),
            Selector<PhotoPresenter, List<AssetEntity>>(
              selector: (context, presenter) => presenter.selectedImages,
              builder: (context, selectedImages, child) {
                final hasSelectedItem = selectedImages.isNotEmpty;
                return AbsorbPointer(
                  absorbing: !hasSelectedItem,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return CheckSelectedImagesScreen(image: List.from(selectedImages));
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: hasSelectedItem ? ColorStyles.red : ColorStyles.gray20,
                      ),
                      child: Text(
                        '다음',
                        style: TextStyles.labelSmallMedium.copyWith(
                          color: hasSelectedItem ? ColorStyles.white : ColorStyles.gray40,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Selector<PhotoPresenter, AssetEntity?>(
      selector: (context, presenter) => presenter.preview,
      builder: (context, preview, child) {
        final image = preview;
        return AspectRatio(
          aspectRatio: 1,
          child: image != null
              ? widget._previewShape == BoxShape.rectangle
                  ? AssetEntityImage(image, fit: BoxFit.cover)
                  : Stack(
                      children: [
                        Positioned.fill(child: AssetEntityImage(image, fit: BoxFit.cover)),
                        Positioned.fill(child: CustomPaint(painter: _CircleCropOverlayPainter())),
                      ],
                    )
              : Container(color: ColorStyles.gray50),
        );
      },
    );
  }

  Widget _buildAlbumTitle() {
    return Selector<PhotoPresenter, AlbumTitleState>(
      selector: (context, presenter) => presenter.albumTitleState,
      builder: (context, albumTitleState, child) {
        final currentAlbum = albumTitleState.currentAlbum;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: albumTitleState.albumList.isNotEmpty && currentAlbum != null
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumListView(albumList: albumTitleState.albumList),
                          ),
                        );
                        if (result != null && context.mounted) {
                          context.read<PhotoPresenter>().onChangeAlbum(result);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentAlbum.name, style: TextStyles.title01SemiBold.copyWith(color: Colors.white)),
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
      },
    );
  }

  Widget _buildManagementButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ColorStyles.gray90,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '선택한 일부 사진과 동영상에만 엑세스할 수 있는 권한을 Brewbuds 앱에 부여했습니다.',
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
          const SizedBox(width: 64),
          GestureDetector(
            onTap: () {
              showManagementBottomSheet(context);
            },
            child: Text(
              '관리',
              style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
          context.read<PhotoPresenter>().fetchPhotos();
        }
        return false;
      },
      child: Selector<PhotoPresenter, ImageViewState>(
        selector: (context, presenter) => presenter.imageViewState,
        builder: (context, imageViewState, child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: imageViewState.images.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCameraButton();
              } else {
                return _buildImageGrid(
                  image: imageViewState.images[index - 1],
                  index: index - 1,
                  selectedIndexList: imageViewState.selectedIndexList,
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildImageGrid({
    required AssetEntity image,
    required int index,
    required List<int> selectedIndexList,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          context.read<PhotoPresenter>().onSelectedImage(index);
        },
        child: Stack(
          children: [
            AssetEntityImage(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              image,
              isOriginal: false,
              fit: BoxFit.cover,
            ),
            if (selectedIndexList.contains(index)) // 선택된 사진 음영표시
              Container(color: Colors.black.withOpacity(0.3)),
            Positioned(
              // 선택된 사진 순번표시
              top: 8,
              right: 8,
              child: selectedIndexList.contains(index)
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorStyles.white, width: 1),
                        color: ColorStyles.red,
                      ),
                      width: 20,
                      height: 20,
                      child: Center(
                        child: selectedIndexList.length == 1
                            ? SvgPicture.asset(
                                'assets/icons/check_red_filled.svg',
                                height: 20,
                                width: 20,
                              )
                            : Text(
                                (selectedIndexList.indexOf(index) + 1).toString(),
                                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.white),
                              ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorStyles.white.withOpacity(0.5), width: 1),
                        color: ColorStyles.black.withOpacity(0.5),
                      ),
                      width: 20,
                      height: 20,
                    ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        );
      },
      child: Container(
        color: ColorStyles.gray70,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/camera.svg',
            height: 32,
            width: 32,
            colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  showManagementBottomSheet(BuildContext context) async {
    final result = await showGeneralDialog<ManagementBottomSheetResult>(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) => const ManagementBottomSheet(),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
    switch (result) {
      case ManagementBottomSheetResult.management:
        context.read<PhotoPresenter>().reselectedImage();
      case ManagementBottomSheetResult.openSetting:
        openAppSettings();
        break;
      case null:
        return;
    }
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

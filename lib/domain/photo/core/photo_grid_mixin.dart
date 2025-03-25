import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/permission/permission_denied_view.dart';
import 'package:brew_buds/domain/photo/presenter/photo_presenter.dart';
import 'package:brew_buds/domain/photo/view/album_list_view.dart';
import 'package:brew_buds/domain/photo/view/photo_first_time_view.dart';
import 'package:brew_buds/domain/photo/widget/management_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

mixin PhotoGridMixin<T extends StatefulWidget, Presenter extends PhotoPresenter> on State<T> {
  late final ValueNotifier<bool> isFirstNotifier;

  PermissionStatus get permissionStatus;

  BoxShape get previewShape;

  Function(BuildContext context, List<Uint8List> selectedImages) get onDone;

  Function(BuildContext context) get onTapCameraButton;

  Color get backgroundColor;

  @override
  void initState() {
    isFirstNotifier = ValueNotifier(SharedPreferencesRepository.instance.isFirstTimeAlbum);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Presenter>().initState();
    });
    super.initState();
  }

  @override
  void dispose() {
    isFirstNotifier.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isFirstNotifier,
      builder: (context, isFirst, _) {
        if (isFirst) {
          return PhotoFirstTimeView(
            onNext: () async {
              await SharedPreferencesRepository.instance.useAlbum();
              isFirstNotifier.value = false;
            },
          );
        } else {
          switch (permissionStatus) {
            case PermissionStatus.granted || PermissionStatus.limited:
              return Scaffold(
                backgroundColor: backgroundColor,
                appBar: buildAppBar(context),
                body: SafeArea(
                  child: buildBody(context),
                ),
              );
            default:
              return PermissionDeniedView.photo();
          }
        }
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      centerTitle: false,
      backgroundColor: backgroundColor,
      toolbarHeight: 52,
      title: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/x.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    backgroundColor == ColorStyles.white ? ColorStyles.black : ColorStyles.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Selector<Presenter, AlbumTitleState>(
              selector: (context, presenter) => presenter.albumTitleState,
              builder: (context, albumTitleState, child) {
                final currentAlbum = albumTitleState.currentAlbum;
                return albumTitleState.albumList.isNotEmpty && currentAlbum != null
                    ? GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumListView(albumList: albumTitleState.albumList),
                            ),
                          );
                          if (result != null && context.mounted) {
                            context.read<Presenter>().onChangeAlbum(result);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(currentAlbum.name, style: TextStyles.title01SemiBold),
                            SvgPicture.asset('assets/icons/down.svg', height: 18, width: 18),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            Positioned(
              right: 0,
              child: Selector<Presenter, List<Uint8List>>(
                selector: (context, presenter) => presenter.selectedImagesData,
                builder: (context, selectedImages, child) {
                  final hasSelectedItem = selectedImages.isNotEmpty;
                  return AbsorbPointer(
                    absorbing: !hasSelectedItem,
                    child: GestureDetector(
                      onTap: () {
                        onDone(context, selectedImages);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage({
    required AssetEntity image,
    required List<AssetEntity> selectedImages,
  }) {
    final isSelected = selectedImages.contains(image);
    return GestureDetector(
      onTap: () {
        context.read<Presenter>().onSelectedImage(image);
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: AssetEntityImage(image, fit: BoxFit.cover),
          ),
          if (isSelected) // 선택된 사진 음영표시
            Container(color: Colors.black.withOpacity(0.3)),
          Positioned(
            // 선택된 사진 순번표시
            top: 8,
            right: 8,
            child: isSelected
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorStyles.white, width: 1),
                      color: ColorStyles.red,
                    ),
                    width: 20,
                    height: 20,
                    child: Center(
                      child: selectedImages.length == 1
                          ? SvgPicture.asset(
                              'assets/icons/check_red_filled.svg',
                              height: 20,
                              width: 20,
                            )
                          : Text(
                              (selectedImages.indexOf(image) + 1).toString(),
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
  }

  Widget buildCameraButton() {
    return GestureDetector(
      onTap: () async {
        onTapCameraButton(context);
      },
      child: Container(
        color: ColorStyles.gray50,
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

  Widget buildManagementButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ColorStyles.gray60,
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

    if (context.mounted) {
      switch (result) {
        case ManagementBottomSheetResult.management:
          context.read<Presenter>().reselectedImage();
        case ManagementBottomSheetResult.openSetting:
          openAppSettings();
          break;
        case null:
          return;
      }
    }
  }
}

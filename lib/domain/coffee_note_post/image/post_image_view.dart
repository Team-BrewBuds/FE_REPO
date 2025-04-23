import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/permission/permission_denied_view.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:brew_buds/domain/photo/photo_first_time_view.dart';
import 'package:brew_buds/domain/coffee_note_post/image/post_image_presenter.dart';
import 'package:brew_buds/domain/photo/widget/asset_album_list_view.dart';
import 'package:brew_buds/domain/photo/widget/management_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class PostImageView extends StatefulWidget {
  final Function(List<Uint8List> selectedImages) onDone;
  final Function() onTapCamera;

  const PostImageView({super.key, required this.onDone, required this.onTapCamera});

  @override
  State<PostImageView> createState() => _PostImageViewState();

  static Widget build({
    required Function(List<Uint8List> selectedImages) onDone,
    required Function() onTapCamera,
  }) {
    return ChangeNotifierProvider<PostImagePresenter>(
      create: (context) => PostImagePresenter(),
      child: PostImageView(
        onDone: onDone,
        onTapCamera: onTapCamera,
      ),
    );
  }
}

class _PostImageViewState extends State<PostImageView> {
  late final ValueNotifier<bool> isFirstNotifier;

  PermissionStatus get permissionStatus => PermissionRepository.instance.photos;

  @override
  void initState() {
    isFirstNotifier = ValueNotifier(SharedPreferencesRepository.instance.isFirstTimeAlbum);
    super.initState();
  }

  @override
  void dispose() {
    isFirstNotifier.dispose();
    super.dispose();
  }

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
                backgroundColor: ColorStyles.white,
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
      backgroundColor: ColorStyles.white,
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
              child: ThrottleButton(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/x.svg',
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Selector<PostImagePresenter, AssetAlbum?>(
              selector: (context, presenter) => presenter.selectedAlbum,
              builder: (context, selectedAlbum, child) {
                final currentAlbum = selectedAlbum;
                final isAll = (currentAlbum?.assetPathEntity.isAll ?? true);
                final title = isAll ? '최근 항목' : (currentAlbum?.assetPathEntity.name ?? '');
                return ThrottleButton(
                  onTap: () async {
                    final result = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssetAlbumListView(),
                      ),
                    );
                    if (result != null && context.mounted) {
                      context.read<PostImagePresenter>().onChangeAlbum(result);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: TextStyles.title01SemiBold),
                      SvgPicture.asset('assets/icons/down.svg', height: 18, width: 18),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 0,
              child: Selector<PostImagePresenter, bool>(
                selector: (context, presenter) => presenter.isSelect,
                builder: (context, isSelect, child) {
                  return AbsorbPointer(
                    absorbing: !isSelect,
                    child: ThrottleButton(
                      onTap: () async {
                        final currentContext = context;
                        final images = await currentContext.read<PostImagePresenter>().getSelectedPhotoData();
                        widget.onDone.call(images.whereType<Uint8List>().toList());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isSelect ? ColorStyles.red : ColorStyles.gray20,
                        ),
                        child: Text(
                          '다음',
                          style: TextStyles.labelSmallMedium.copyWith(
                            color: isSelect ? ColorStyles.white : ColorStyles.gray40,
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
    required int selectedAt,
    required bool isSingleSelect,
  }) {
    final isSelected = selectedAt != -1;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: AssetEntityImage(image, fit: BoxFit.cover, isOriginal: false,),
        ),
        if (isSelected) // 선택된 사진 음영표시
          Container(color: ColorStyles.black30),
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
                  width: 24.w,
                  height: 24.h,
                  child: Center(
                    child: isSingleSelect
                        ? SvgPicture.asset(
                            'assets/icons/check_red_filled.svg',
                            height: 24.h,
                            width: 24.w,
                          )
                        : Text(
                            (selectedAt + 1).toString(),
                            style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.white),
                          ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorStyles.black50, width: 1),
                    color: ColorStyles.black50,
                  ),
                  width: 24.w,
                  height: 24.h,
                ),
        )
      ],
    );
  }

  Widget buildCameraButton() {
    return ThrottleButton(
      onTap: () async {
        widget.onTapCamera.call();
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
              maxLines: 2,
              '선택한 일부 사진과 동영상에만 엑세스할 수 있는 권한을 Brewbuds 앱에 부여했습니다.',
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
          const SizedBox(width: 64),
          ThrottleButton(
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
      barrierColor: ColorStyles.black50,
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
          context.read<PostImagePresenter>().onTapReSelectPhoto();
        case ManagementBottomSheetResult.openSetting:
          openAppSettings();
          break;
        case null:
          return;
      }
    }
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        if (permissionStatus == PermissionStatus.limited) ...[
          buildManagementButton(context),
          const SizedBox(height: 1),
        ],
        Expanded(
          child: Builder(
            builder: (context) {
              final images = context.select<PostImagePresenter, List<AssetEntity>>(
                (presenter) => presenter.selectedAlbum?.images ?? [],
              );
              return GridView.builder(
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
                    final image = images.elementAtOrNull(index - 1);
                    if (image != null) {
                      return Builder(
                        builder: (context) {
                          final isSingleSelect = context.select<PostImagePresenter, bool>(
                            (presenter) => presenter.selectedPhotoIndexList.length == 1,
                          );
                          final selectedAt = context.select<PostImagePresenter, int>(
                            (presenter) => presenter.getOrderOfSelected(index - 1),
                          );
                          return ThrottleButton(
                            onTap: () {
                              context.read<PostImagePresenter>().onSelectPhotoAt(index - 1);
                            },
                            child: buildImage(
                              image: image,
                              selectedAt: selectedAt,
                              isSingleSelect: isSingleSelect,
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

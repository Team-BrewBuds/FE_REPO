import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/permission/permission_denied_view.dart';
import 'package:brew_buds/domain/photo/core/custom_circle_crop_layer_painter.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:brew_buds/domain/photo/photo_first_time_view.dart';
import 'package:brew_buds/domain/photo/widget/asset_album_list_view.dart';
import 'package:brew_buds/domain/photo/widget/management_bottom_sheet.dart';
import 'package:brew_buds/domain/profile/image_edit/profile_image_presenter.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor/image_editor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class ProfileImageView extends StatefulWidget {
  final double previewHeight;
  final void Function() onTapCamera;

  const ProfileImageView({
    super.key,
    required this.previewHeight,
    required this.onTapCamera,
  });

  @override
  State<ProfileImageView> createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> with TickerProviderStateMixin {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _previewController;
  late final ValueNotifier<bool> isFirstNotifier;
  bool _isPreViewVisibleWhenDragStart = true;
  bool _isScrolledAtTop = true;
  ScrollDirection _scrollDirection = ScrollDirection.idle;

  double get previewOffset => (1.0 - _previewController.value) * -widget.previewHeight;

  PermissionStatus get permissionStatus => PermissionRepository.instance.photos;

  @override
  void initState() {
    isFirstNotifier = ValueNotifier(SharedPreferencesRepository.instance.isFirstTimeAlbum);
    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );

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
              return Builder(
                builder: (context) {
                  final isLoading = context.select<ProfileImagePresenter, bool>((presenter) => presenter.isLoading);
                  return Stack(
                    children: [
                      Scaffold(
                        backgroundColor: ColorStyles.black,
                        appBar: _buildAppBar(context),
                        body: SafeArea(
                          child: _buildBody(context),
                        ),
                      ),
                      if (isLoading) const Positioned.fill(child: LoadingBarrier()),
                    ],
                  );
                },
              );
            default:
              return PermissionDeniedView.photo();
          }
        }
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      centerTitle: false,
      backgroundColor: ColorStyles.black,
      toolbarHeight: 52,
      title: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
        child: Row(
          children: [
            ThrottleButton(
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
            Builder(
              builder: (context) {
                final isSelect = context.select<ProfileImagePresenter, bool>(
                  (presenter) => presenter.isSelect,
                );
                return AbsorbPointer(
                  absorbing: !isSelect,
                  child: FutureButton(
                    onTap: () => _onSave(),
                    onError: (_) {
                      EventBus.instance.fire(const MessageEvent(message: '프로필 이미지 등록에 실패했어요.'));
                    },
                    onComplete: (_) {
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelect ? ColorStyles.red : ColorStyles.gray20,
                      ),
                      child: Text(
                        '완료',
                        style: TextStyles.labelSmallMedium.copyWith(
                          color: isSelect ? ColorStyles.white : ColorStyles.gray40,
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

  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _previewController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: previewOffset,
              left: 0,
              right: 0,
              child: Builder(builder: (context) {
                final preview = context.select<ProfileImagePresenter, Future<Uint8List?>>(
                  (presenter) => presenter.preView,
                );
                return FutureBuilder(
                  future: preview,
                  initialData: null,
                  builder: (context, snapShot) {
                    final data = snapShot.data;
                    if (data != null) {
                      return ExtendedImage.memory(
                        data,
                        height: width,
                        width: width,
                        fit: BoxFit.contain,
                        cacheRawData: true,
                        mode: ExtendedImageMode.editor,
                        extendedImageEditorKey: _editorKey,
                        initEditorConfigHandler: (ExtendedImageState? state) {
                          return EditorConfig(
                            maxScale: 5.0,
                            cropRectPadding: EdgeInsets.zero,
                            hitTestSize: 0,
                            initCropRectType: InitCropRectType.layoutRect,
                            cropAspectRatio: CropAspectRatios.ratio1_1,
                            cornerSize: Size.zero,
                            lineHeight: 1,
                            lineColor: ColorStyles.white,
                            editorMaskColorHandler: (context, pointerDown) => ColorStyles.black30,
                            cropLayerPainter: CustomCircleCropLayerPainter(),
                          );
                        },
                      );
                    } else {
                      return MyNetworkImage(
                        imageUrl: context.read<ProfileImagePresenter>().currentImageUrl,
                        height: width,
                        width: width,
                      );
                    }
                  },
                );
              }),
            ),
            Positioned(
              top: width + previewOffset,
              left: 0,
              right: 0,
              bottom: 0,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _isScrolledAtTop = _scrollController.offset == 0;
                    _isPreViewVisibleWhenDragStart = _previewController.value > 0.99;
                  } else if (notification is UserScrollNotification) {
                    _scrollDirection = notification.direction;
                  } else if (notification is ScrollEndNotification) {
                    if (_isPreViewVisibleWhenDragStart) {
                      if (_previewController.value <= 0.99) {
                        _previewController.animateTo(0.0);
                      }
                    } else {
                      if (_previewController.value >= 0.01) {
                        _previewController.animateTo(1.0);
                      }
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: BlockScrollButAllowNotificationPhysics(
                    preViewOffsetGetter: () => _previewController.value,
                    isScrolledAtTop: () => _scrollController.offset == 0,
                    onScrolledWithFling: (velocity) {
                      switch (_scrollDirection) {
                        case ScrollDirection.idle:
                          return;
                        case ScrollDirection.forward:
                          if (velocity < 0 && _isScrolledAtTop && _previewController.value < 1.0) {
                            _previewController.animateTo(1.0);
                          }
                          return;
                        case ScrollDirection.reverse:
                          if (velocity > 0 && _previewController.value > 0.0) {
                            _previewController.animateTo(0.0);
                          }
                          return;
                      }
                    },
                    onScrolledWithDrag: (offset) {
                      final delta = offset / widget.previewHeight;

                      final next = (_previewController.value + delta).clamp(0.0, 1.0);

                      _previewController.value = next;
                    },
                  ),
                  slivers: [
                    Builder(builder: (context) {
                      final currentAlbum = context.select<ProfileImagePresenter, AssetAlbum?>(
                        (presenter) => presenter.selectedAlbum,
                      );
                      return SliverAppBar(
                        pinned: true,
                        automaticallyImplyLeading: false,
                        backgroundColor: ColorStyles.black,
                        titleSpacing: 0,
                        toolbarHeight: 40.h,
                        title: _buildAlbumTitle(
                          context: context,
                          albumTitle: (currentAlbum?.assetPathEntity.isAll ?? true)
                              ? '최근 항목'
                              : currentAlbum?.assetPathEntity.name ?? '',
                        ),
                      );
                    }),
                    if (permissionStatus == PermissionStatus.limited) ...[
                      SliverAppBar(
                        pinned: true,
                        automaticallyImplyLeading: false,
                        backgroundColor: ColorStyles.black,
                        titleSpacing: 0,
                        toolbarHeight: 67.h,
                        title: buildManagementButton(context: context),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 1)),
                    ],
                    Builder(builder: (context) {
                      final currentAlbum = context.select<ProfileImagePresenter, AssetAlbum?>(
                        (presenter) => presenter.selectedAlbum,
                      );
                      return SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return buildCameraButton(context);
                          } else {
                            final image = currentAlbum?.images.elementAtOrNull(index - 1);
                            if (image != null) {
                              return Builder(builder: (context) {
                                final selectedImageIndex = context
                                    .select<ProfileImagePresenter, int?>((presenter) => presenter.selectedImageIndex);
                                return ThrottleButton(
                                  onTap: () {
                                    context.read<ProfileImagePresenter>().onSelectPhotoAt(index - 1);
                                    _previewController.animateTo(1.0);
                                  },
                                  child: buildImage(image: image, isSelected: (index - 1) == selectedImageIndex),
                                );
                              });
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        },
                        itemCount: (currentAlbum?.images.length ?? 0) + 1,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlbumTitle({required BuildContext context, required String albumTitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          ThrottleButton(
            onTap: () async {
              final result = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetAlbumListView(),
                ),
              );
              if (result != null && context.mounted) {
                context.read<ProfileImagePresenter>().onChangeAlbum(result);
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
      ),
    );
  }

  Widget buildManagementButton({required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: ColorStyles.gray60,
      child: Row(
        spacing: 64.w,
        children: [
          Expanded(
            child: Text(
              '선택한 일부 사진과 동영상에만 엑세스할 수 있는 권한을 Brewbuds 앱에 부여했습니다.',
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
              maxLines: 2,
            ),
          ),
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

  Widget buildCameraButton(BuildContext context) {
    return ThrottleButton(
      onTap: () {
        widget.onTapCamera.call();
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

  Widget buildImage({
    required AssetEntity image,
    required bool isSelected,
  }) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: AssetEntityImage(
            image,
            fit: BoxFit.cover,
            isOriginal: false,
          ),
        ),
        if (isSelected) Container(color: ColorStyles.black30),
        Positioned(
          top: 8,
          right: 8,
          child: isSelected
              ? SvgPicture.asset(
                  'assets/icons/check_red_filled.svg',
                  height: 24.h,
                  width: 24.w,
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorStyles.white50, width: 1),
                    color: ColorStyles.black50,
                  ),
                  width: 24.w,
                  height: 24.h,
                ),
        )
      ],
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
          await context.read<ProfileImagePresenter>().onTapReSelectPhoto();
        case ManagementBottomSheetResult.openSetting:
          await openAppSettings();
          break;
        case null:
          break;
      }
    }
  }

  Future<void> _onSave() async {
    final context = this.context;
    final state = _editorKey.currentState;

    if (state != null) {
      final cropRect = state.getCropRect();
      final Uint8List rawImageData = state.rawImageData;
      if (cropRect != null) {
        final editorOption = ImageEditorOption();
        editorOption.addOption(ClipOption.fromRect(cropRect));

        final result = await ImageEditor.editImage(
          image: rawImageData,
          imageEditorOption: editorOption,
        );

        if (context.mounted && result != null) {
          return context.read<ProfileImagePresenter>().onSave(result);
        }
      }
    }

    return Future.error(Error());
  }
}

class BlockScrollButAllowNotificationPhysics extends ScrollPhysics {
  final double Function() preViewOffsetGetter;
  final bool Function() isScrolledAtTop;
  final void Function(double velocity) onScrolledWithFling;
  final void Function(double offset) onScrolledWithDrag;

  const BlockScrollButAllowNotificationPhysics({
    super.parent,
    required this.preViewOffsetGetter,
    required this.isScrolledAtTop,
    required this.onScrolledWithFling,
    required this.onScrolledWithDrag,
  });

  @override
  BlockScrollButAllowNotificationPhysics applyTo(ScrollPhysics? ancestor) {
    return BlockScrollButAllowNotificationPhysics(
      parent: buildParent(ancestor),
      preViewOffsetGetter: preViewOffsetGetter,
      isScrolledAtTop: isScrolledAtTop,
      onScrolledWithFling: onScrolledWithFling,
      onScrolledWithDrag: onScrolledWithDrag,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    final currentOffset = preViewOffsetGetter();
    final isScrolledAtTop = this.isScrolledAtTop();

    if (currentOffset >= 0.01 && offset < 0) {
      onScrolledWithDrag(offset);
      return 0;
    }

    if (currentOffset <= 0.99 && offset > 0) {
      if (isScrolledAtTop) {
        onScrolledWithDrag(offset);
        return 0;
      }
    }

    return const BouncingScrollPhysics().applyPhysicsToUserOffset(position, offset);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    onScrolledWithFling(velocity);

    return const BouncingScrollPhysics().createBallisticSimulation(position, velocity);
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}

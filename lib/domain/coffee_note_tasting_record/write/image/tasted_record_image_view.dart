import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/image/tasted_record_image_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow_presenter.dart';
import 'package:brew_buds/domain/permission/permission_denied_view.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:brew_buds/domain/photo/photo_first_time_view.dart';
import 'package:brew_buds/domain/photo/widget/asset_album_list_view.dart';
import 'package:brew_buds/domain/photo/widget/management_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class TastedRecordImageView extends StatefulWidget {
  final double previewHeight;
  final void Function() onTapCamera;

  const TastedRecordImageView({
    super.key,
    required this.previewHeight,
    required this.onTapCamera,
  });

  static Widget buildWithPresenter({
    required double previewHeight,
    required void Function() onTapCamera,
  }) {
    return ChangeNotifierProvider<TastedRecordImagePresenter>(
      create: (context) => TastedRecordImagePresenter(),
      child: TastedRecordImageView(previewHeight: previewHeight, onTapCamera: onTapCamera),
    );
  }

  @override
  State<TastedRecordImageView> createState() => _TastedRecordImageViewState();
}

class _TastedRecordImageViewState extends State<TastedRecordImageView> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
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
              return ValueListenableBuilder(
                  valueListenable: _isLoadingNotifier,
                  builder: (context, isLoading, _) {
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
                  });
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
                final hasSelectedItem = context.select<TastedRecordImagePresenter, bool>(
                  (presenter) => presenter.selectedPhotoIndexList.isNotEmpty,
                );
                return AbsorbPointer(
                  absorbing: !hasSelectedItem,
                  child: ThrottleButton(
                    onTap: () async {
                      final currentContext = context;
                      _isLoadingNotifier.value = true;
                      final images = await currentContext.read<TastedRecordImagePresenter>().getSelectedPhotoData();
                      _isLoadingNotifier.value = false;
                      if (currentContext.mounted) {
                        currentContext
                            .read<TastedRecordWriteFlowPresenter>()
                            .goTo(TastedRecordWriteFlow.albumEditStep(images.whereType<Uint8List>().toList()));
                      }
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

  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Builder(
      builder: (context) {
        final currentAlbum = context.select<TastedRecordImagePresenter, AssetAlbum?>(
          (presenter) => presenter.selectedAlbum,
        );
        final preview = context.select<TastedRecordImagePresenter, AssetEntity?>(
          (presenter) => presenter.preView,
        );
        return GestureDetector(
          onVerticalDragUpdate: (detail) {
            final dy = detail.delta.dy;
            final delta = dy / widget.previewHeight;

            final next = (_previewController.value + delta).clamp(0.0, 1.0);

            _previewController.value = next;

            if (_previewController.value == 0 && dy < 0) {
              _scrollController.animateTo(
                _scrollController.offset + -dy,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuad,
              );
            }
          },
          onVerticalDragEnd: (detail) {
            final velocity = detail.velocity.pixelsPerSecond.dy;

            if (_previewController.value < 0.99) {
              _previewController.animateTo(0.0);

              if (velocity < 0 && _scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.offset + -(velocity * 0.3),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuad,
                );
              }
            }
          },
          child: AnimatedBuilder(
            animation: _previewController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: previewOffset,
                    left: 0,
                    right: 0,
                    child: preview != null
                        ? AssetEntityImage(
                            preview,
                            isOriginal: true,
                            width: width,
                            height: width,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: ColorStyles.gray50,
                            width: width,
                            height: width,
                          ),
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
                          SliverAppBar(
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
                          ),
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
                          SliverGrid.builder(
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
                                    final isSingleSelect = context.select<TastedRecordImagePresenter, bool>(
                                      (presenter) => presenter.selectedPhotoIndexList.length == 1,
                                    );
                                    final selectedAt = context.select<TastedRecordImagePresenter, int>(
                                      (presenter) => presenter.getOrderOfSelected(index - 1),
                                    );
                                    return ThrottleButton(
                                      onTap: () {
                                        context.read<TastedRecordImagePresenter>().onSelectPhotoAt(index - 1);
                                        _previewController.animateTo(1.0);
                                      },
                                      child: buildImage(
                                        image: image,
                                        selectedAt: selectedAt,
                                        isSingleSelect: isSingleSelect,
                                      ),
                                    );
                                  });
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                            },
                            itemCount: (currentAlbum?.images.length ?? 0) + 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
                context.read<TastedRecordImagePresenter>().onChangeAlbum(result);
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
      onTap: () async {
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
    required int selectedAt,
    required bool isSingleSelect,
  }) {
    final isSelected = selectedAt != -1;
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
        if (selectedAt != -1) // 선택된 사진 음영표시
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
                            '${selectedAt + 1}',
                            style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.white),
                          ),
                  ),
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
          _isLoadingNotifier.value = true;
          await context.read<TastedRecordImagePresenter>().onTapReSelectPhoto();
        case ManagementBottomSheetResult.openSetting:
          _isLoadingNotifier.value = true;
          await openAppSettings();
          break;
        case null:
          break;
      }
    }
    _isLoadingNotifier.value = false;
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

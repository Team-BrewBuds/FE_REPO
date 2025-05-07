import 'dart:io';
import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/analytics_manager.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/camera/camera_first_time_view.dart';
import 'package:brew_buds/domain/camera/widget/custom_camera_button.dart';
import 'package:brew_buds/domain/photo/core/circle_crop_overlay_painter.dart';
import 'package:brew_buds/domain/photo/photo_edit_screen.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class CameraScreen<T> extends StatefulWidget {
  final BoxShape _previewShape;
  final Future<T> Function(BuildContext context, Uint8List imageData) onDone;
  final Function(BuildContext context) onTapAlbum;
  final bool isTastedRecordFlow;

  const CameraScreen({
    super.key,
    required this.onDone,
    required this.onTapAlbum,
    BoxShape previewShape = BoxShape.rectangle,
    this.isTastedRecordFlow = false,
  }) : _previewShape = previewShape;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final DeferredPointerHandlerLink _deferredPointerLink = DeferredPointerHandlerLink();
  late final ValueNotifier<bool> isFirstNotifier;
  final ValueNotifier<Uint8List?> imageData = ValueNotifier(null);
  Uint8List? originData;

  @override
  void initState() {
    isFirstNotifier = ValueNotifier(SharedPreferencesRepository.instance.isFirstTimeCamera);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isTastedRecordFlow) {
        AnalyticsManager.instance.logScreen(screenName: 'tasted_record_camera');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    isFirstNotifier.dispose();
    _deferredPointerLink.dispose();
    imageData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isFirstNotifier,
      builder: (context, isFirst, _) {
        final thumbnail = PhotoRepository.instance.albumList.firstOrNull?.images.firstOrNull;
        return isFirst
            ? CameraFirstTimeView(
                onNext: () async {
                  await SharedPreferencesRepository.instance.useCamera();
                  isFirstNotifier.value = false;
                },
              )
            : Scaffold(
                backgroundColor: Colors.black,
                body: ValueListenableBuilder(
                  valueListenable: imageData,
                  builder: (context, imageData, _) {
                    final data = imageData;
                    return DeferredPointerHandler(
                      link: _deferredPointerLink,
                      child: data != null
                          ? _buildPreviewView(data: data)
                          : Column(
                              children: [
                                Expanded(child: _buildCameraPreview()),
                                Container(
                                  height: 145,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        ThrottleButton(
                                          onTap: () {
                                            if (widget.isTastedRecordFlow) {
                                              AnalyticsManager.instance.logButtonTap(buttonName: 'tasted_record_camera_back');
                                            }
                                            widget.onTapAlbum.call(context);
                                          },
                                          child: thumbnail != null
                                              ? Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: AssetEntityImage(
                                                    thumbnail,
                                                    isOriginal: false,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : SvgPicture.asset(
                                                  'assets/icons/image.svg',
                                                  height: 36,
                                                  width: 36,
                                                  colorFilter: const ColorFilter.mode(
                                                    ColorStyles.white,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              );
      },
    );
  }

  Widget _buildCameraPreview() {
    return CameraAwesomeBuilder.custom(
      previewFit: CameraPreviewFit.cover,
      saveConfig: SaveConfig.photo(),
      sensorConfig: SensorConfig.single(),
      builder: (state, preview) {
        return Column(
          children: [
            Expanded(
              child: Container(
                color: ColorStyles.black30,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Center(
                  child: Row(
                    children: [
                      ThrottleButton(
                        onTap: () {
                          if (widget.isTastedRecordFlow) {
                            AnalyticsManager.instance.logButtonTap(buttonName: 'tasted_record_camera_close');
                          }
                          context.pop();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/x.svg',
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      const Spacer(),
                      AwesomeFlashButton(
                        state: state,
                        onFlashTap: (sensorConfig, flashMode) {
                          if (flashMode == FlashMode.none) {
                            sensorConfig.setFlashMode(FlashMode.on);
                          } else if (flashMode == FlashMode.on) {
                            sensorConfig.setFlashMode(FlashMode.auto);
                          } else if (flashMode == FlashMode.auto) {
                            sensorConfig.setFlashMode(FlashMode.none);
                          } else {
                            sensorConfig.setFlashMode(FlashMode.auto);
                          }
                        },
                        iconBuilder: (flashMode) {
                          switch (flashMode) {
                            case FlashMode.none:
                              return SvgPicture.asset(
                                'assets/icons/flash_off.svg',
                                height: 24,
                                width: 24,
                              );
                            case FlashMode.on:
                              return SvgPicture.asset(
                                'assets/icons/flash_on.svg',
                                height: 24,
                                width: 24,
                              );
                            case FlashMode.auto:
                              return SvgPicture.asset(
                                'assets/icons/flash_auto.svg',
                                height: 24,
                                width: 24,
                              );
                            case FlashMode.always:
                              return SvgPicture.asset(
                                'assets/icons/flash_on.svg',
                                height: 24,
                                width: 24,
                              );
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      state.when(
                        onPhotoMode: (photoState) => AwesomeCameraSwitchButton(
                          state: photoState,
                          iconBuilder: () {
                            return Center(
                              child: SvgPicture.asset(
                                'assets/icons/refresh.svg',
                                height: 24,
                                width: 24,
                                colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  const Positioned.fill(child: SizedBox.shrink()),
                  if (widget._previewShape == BoxShape.circle)
                    Positioned.fill(child: CustomPaint(painter: CircleCropOverlayPainter())),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: ColorStyles.black30,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      bottom: -39,
                      child: DeferPointer(
                        link: _deferredPointerLink,
                        child: CustomCameraButton(
                          state: state,
                          onCaptureSuccess: (captureRequest) async {
                            final path = captureRequest.path;
                            if (path != null) {
                              final captureFile = File(path);
                              final captureData = await captureFile.readAsBytes();
                              originData = captureData;
                              imageData.value = captureData;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }, // 하단 버튼 제거 (직접 구현)
    );
  }

  Widget _buildPreviewView({required Uint8List data}) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Center(
              child: Row(
                children: [
                  ThrottleButton(
                    onTap: () {
                      if (widget.isTastedRecordFlow) {
                        AnalyticsManager.instance.logButtonTap(buttonName: 'tasted_record_camera_close');
                      }
                      context.pop();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/x.svg',
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  const Spacer(),
                  ThrottleButton(
                    onTap: () async {
                      final origin = originData;
                      if (origin != null) {
                        final editedData = await Navigator.of(context).push<Uint8List>(
                          MaterialPageRoute(
                            builder: (context) => PhotoEditScreen(
                              shape: widget._previewShape,
                              imageData: data,
                              originData: origin,
                            ),
                          ),
                        );
                        
                        if (editedData != null) {
                          imageData.value = editedData;
                        }
                      }
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/edit.svg',
                        height: 28,
                        width: 28,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: widget._previewShape == BoxShape.rectangle
              ? ExtendedImage.memory(data, fit: BoxFit.cover)
              : Stack(
                  children: [
                    Positioned.fill(child: ExtendedImage.memory(data, fit: BoxFit.cover)),
                    Positioned.fill(child: CustomPaint(painter: CircleCropOverlayPainter())),
                  ],
                ),
        ),
        Expanded(child: Container(color: Colors.black)),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          height: 145,
          child: Row(
            children: [
              Expanded(
                child: ThrottleButton(
                  onTap: () {
                    imageData.value = null;
                    originData = null;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: const BoxDecoration(
                      color: ColorStyles.gray30,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      '다시찍기',
                      style: TextStyles.labelMediumMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FutureButton(
                  onTap: () => widget.onDone.call(context, data),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: const BoxDecoration(
                      color: ColorStyles.red,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      '사진사용',
                      style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

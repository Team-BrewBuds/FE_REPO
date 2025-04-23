import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/photo/core/circle_crop_overlay_painter.dart';
import 'package:brew_buds/domain/photo/photo_edit_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/image/tasted_record_image_edit_presenter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TastedRecordImageEditView extends StatelessWidget {
  final void Function() onPop;
  final void Function(List<Uint8List> images) onNext;
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);
  final BoxShape _shape;

  TastedRecordImageEditView({
    super.key,
    required BoxShape shape,
    required this.onPop,
    required this.onNext,
  }) : _shape = shape;

  static Widget buildWithPresenter({
    required List<Uint8List> images,
    required Function() onPop,
    required Function(List<Uint8List> images) onNext,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return ChangeNotifierProvider<TastedRecordImageEditPresenter>(
      create: (context) => TastedRecordImageEditPresenter(images: images),
      child: TastedRecordImageEditView(shape: shape, onPop: onPop, onNext: onNext),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: ColorStyles.black, toolbarHeight: 0),
      backgroundColor: ColorStyles.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 45),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                spacing: 18,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Builder(
                      builder: (context) {
                        final images = context.select<TastedRecordImageEditPresenter, List<Uint8List>>(
                          (presenter) => presenter.images,
                        );
                        return _buildImagesSlider(images: images);
                      },
                    ),
                  ),
                  if (context.select<TastedRecordImageEditPresenter, bool>((presenter) => presenter.images.length > 1)) ...[
                    ValueListenableBuilder(
                      valueListenable: _indexNotifier,
                      builder: (context, index, _) {
                        final length =
                            context.select<TastedRecordImageEditPresenter, int>((presenter) => presenter.images.length);
                        return Container(
                            color: Colors.black, child: _buildIndicator(length: length, currentIndex: index));
                      },
                    ),
                  ],
                ],
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: ColorStyles.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Center(
        child: Row(
          children: [
            ThrottleButton(
              onTap: () {
                onPop.call();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const Spacer(),
            ThrottleButton(
              onTap: () {
                onNext.call(context.read<TastedRecordImageEditPresenter>().images);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorStyles.red,
                ),
                child: Text(
                  '다음',
                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSlider({required List<Uint8List> images}) {
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (context, _, index) {
        final image = images[index];
        return _shape == BoxShape.rectangle
            ? AspectRatio(
                aspectRatio: 1,
                child: ExtendedImage.memory(image, fit: BoxFit.cover),
              )
            : AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(child: ExtendedImage.memory(image, fit: BoxFit.cover)),
                    Positioned.fill(child: CustomPaint(painter: CircleCropOverlayPainter())),
                  ],
                ),
              );
      },
      options: CarouselOptions(
        aspectRatio: 1,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        initialPage: 0,
        onPageChanged: (index, reason) {
          _indexNotifier.value = index;
        },
      ),
    );
  }

  Widget _buildIndicator({required int length, required int currentIndex}) {
    return AnimatedSmoothIndicator(
      activeIndex: currentIndex,
      count: length, // Replace count
      axisDirection: Axis.horizontal,
      effect: CustomizableEffect(
        dotDecoration: DotDecoration(
          width: 7,
          height: 7,
          color: ColorStyles.gray50,
          borderRadius: BorderRadius.circular(7),
        ),
        activeDotDecoration: const DotDecoration(
          width: 20,
          height: 7,
          color: ColorStyles.white,
          borderRadius: BorderRadius.all(Radius.circular(3.49)),
        ),
        spacing: 4,
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      height: 145,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          ThrottleButton(
            onTap: () async {
              final currentContext = context;
              final originImage = currentContext.read<TastedRecordImageEditPresenter>().originImages[_indexNotifier.value];
              final image = currentContext.read<TastedRecordImageEditPresenter>().images[_indexNotifier.value];

              final result = await Navigator.of(currentContext).push<Uint8List>(
                MaterialPageRoute(
                  builder: (context) => PhotoEditScreen(imageData: image, originData: originImage),
                ),
              );

              if (result != null && currentContext.mounted) {
                currentContext.read<TastedRecordImageEditPresenter>().onEditedImage(
                      index: _indexNotifier.value,
                      imageData: result,
                    );
              }
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: Center(child: SvgPicture.asset('assets/icons/edit.svg')),
            ),
          ),
        ],
      ),
    );
  }
}

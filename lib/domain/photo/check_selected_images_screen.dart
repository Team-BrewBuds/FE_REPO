import 'dart:typed_data';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/photo/photo_edit_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CheckSelectedImagesScreen extends StatefulWidget {
  final List<Uint8List> _images;
  final List<Uint8List> _imagesOrigin;
  final BoxShape _shape;
  final Function(BuildContext context, List<Uint8List> images) onNext;

  CheckSelectedImagesScreen({
    super.key,
    required List<Uint8List> image,
    required this.onNext,
    BoxShape shape = BoxShape.rectangle,
  })  : _images = image,
        _imagesOrigin = List.from(image),
        _shape = shape;

  @override
  State<CheckSelectedImagesScreen> createState() => _CheckSelectedImagesScreenState();
}

class _CheckSelectedImagesScreenState extends State<CheckSelectedImagesScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildAppBar()),
            AspectRatio(aspectRatio: 1, child: _buildImagesSlider()),
            Expanded(child: Container(color: Colors.black, child: _buildIndicator())),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Center(
        child: Row(
          children: [
            ThrottleButton(
              onTap: () {
                Navigator.pop(context);
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
                widget.onNext(context, widget._images);
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

  Widget _buildImagesSlider() {
    return CarouselSlider.builder(
      itemCount: widget._images.length,
      itemBuilder: (context, _, index) {
        return widget._shape == BoxShape.rectangle
            ? AspectRatio(
                aspectRatio: 1,
                child: ExtendedImage.memory(widget._images[index], fit: BoxFit.cover),
              )
            : AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(child: ExtendedImage.memory(widget._images[index], fit: BoxFit.cover)),
                    Positioned.fill(child: CustomPaint(painter: _CircleCropOverlayPainter())),
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
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildIndicator() {
    return widget._images.length > 1
        ? Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 16,
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: widget._images.length, // Replace count
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
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      height: 145,
      child: Row(
        children: [
          const Spacer(),
          ThrottleButton(
            onTap: () async {
              final imageData = widget._images[_currentIndex];
              final data = await Navigator.of(context).push<Uint8List>(
                MaterialPageRoute(
                  builder: (context) => PhotoEditScreen(
                    imageData: imageData,
                    originData: widget._imagesOrigin[_currentIndex],
                    shape: widget._shape,
                  ),
                ),
              );

              if (data != null) {
                setState(() {
                  widget._images[_currentIndex] = data;
                });
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

class _CircleCropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ColorStyles.black70;
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

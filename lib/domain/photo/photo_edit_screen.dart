import 'dart:typed_data';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor/image_editor.dart';

class PhotoEditScreen extends StatefulWidget {
  final BoxShape _shape;
  final Uint8List _originData;
  final Uint8List _imageData;

  const PhotoEditScreen({
    super.key,
    BoxShape shape = BoxShape.rectangle,
    required Uint8List imageData,
    required Uint8List originData,
  })  : _shape = shape,
        _imageData = imageData,
        _originData = originData;

  @override
  State<PhotoEditScreen> createState() => _PhotoEditScreenState();
}

class _PhotoEditScreenState extends State<PhotoEditScreen> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();
  late Uint8List imageData;

  @override
  void initState() {
    imageData = widget._imageData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: _buildCameraPreview()),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      child: _buildTopButtons(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildTopButtons() {
    final canUndo = widget._originData == imageData;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
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
        Visibility(
          visible: !canUndo,
          child: GestureDetector(
              onTap: () {
                undo();
              },
              child: Text(
                '되돌리기',
                style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.red),
              )),
        ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return ExtendedImage.memory(
      imageData,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.editor,
      cacheRawData: true,
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
          cropLayerPainter:
              widget._shape == BoxShape.rectangle ? const EditorCropLayerPainter() : CustomCircleCropLayerPainter(),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 46),
      height: 145,
      child: Center(
        child: GestureDetector(
          onTap: () {
            _saveCroppedImage();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration:
                const BoxDecoration(color: ColorStyles.gray30, borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Text(
              '완료',
              style: TextStyles.labelMediumMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveCroppedImage() async {
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

        context.pop(result);
      }
    }
  }

  undo() {
    setState(() {
      imageData = widget._originData;
    });
  }
}

class CustomCircleCropLayerPainter extends EditorCropLayerPainter {
  @override
  void paintMask(Canvas canvas, Rect rect, ExtendedImageCropLayerPainter painter) {
    final paint = Paint()..color = ColorStyles.black30;
    final path = Path()..addRect(rect);

    path.addOval(Rect.fromCircle(
      center: painter.cropRect.center,
      radius: painter.cropRect.size.width * 0.49, // 원 크기 조절
    ));

    path.fillType = PathFillType.evenOdd; // 내부 원을 투명하게 만듦
    canvas.drawPath(path, paint);
  }

  @override
  void paintCorners(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {}

  @override
  void paintLines(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {}
}

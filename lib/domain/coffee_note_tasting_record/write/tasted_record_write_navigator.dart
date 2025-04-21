import 'package:brew_buds/domain/camera/camera_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/views/tasted_record_write_first_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/views/tasted_record_write_last_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/views/tasted_record_write_secod_screen.dart';
import 'package:brew_buds/domain/photo/presenter/photo_presenter_with_preview.dart';
import 'package:brew_buds/domain/photo/view/photo_screen_with_preview.dart';
import 'package:brew_buds/domain/photo/view/selected_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TastedRecordWriteNavigator extends StatelessWidget {
  const TastedRecordWriteNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TastedRecordWriteFlowPresenter()),
        ChangeNotifierProvider(create: (_) => PhotoPresenterWithPreView()),
        ChangeNotifierProvider(create: (_) => TastedRecordWritePresenter()),
      ],
      child: _TastedRecordWriteNavigatorFlowStack(),
    );
  }
}

class _TastedRecordWriteNavigatorFlowStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TastedRecordWriteFlowPresenter>(
      builder: (context, flow, child) {
        return Navigator(
          pages: [
            for (final step in flow.steps)
              switch (step) {
                AlbumSelectStep() => MaterialPage(
                    child: PhotoScreenWithPreview(
                      previewShape: BoxShape.rectangle,
                      previewHeight: MediaQuery.of(context).size.width,
                      onTapCamera: () {
                        context.read<TastedRecordWriteFlowPresenter>().replace(
                              TastedRecordWriteFlow.imageSelectWithCamera(),
                            );
                      },
                    ),
                  ),
                AlbumEditStep() => MaterialPage(
                    child: SelectedPhotoScreen.buildWithPresenter(
                      images: step.selectedImages,
                      onPop: () {
                        context.read<TastedRecordWriteFlowPresenter>().back();
                      },
                      onNext: (images) {
                        context.read<TastedRecordWritePresenter>().updateImages(images);
                        context.read<TastedRecordWriteFlowPresenter>().goTo(TastedRecordWriteFlow.writeFirstStep());
                      },
                    ),
                  ),
                ImageSelectWithCamera() => MaterialPage(
                    child: CameraScreen(
                      previewShape: BoxShape.rectangle,
                      onDone: (_, image) {
                        context.read<TastedRecordWritePresenter>().updateImages([image]);
                        context.read<TastedRecordWriteFlowPresenter>().goTo(TastedRecordWriteFlow.writeFirstStep());
                      },
                      onTapAlbum: (_) {
                        context.read<PhotoPresenterWithPreView>().reset();
                        context.read<TastedRecordWriteFlowPresenter>().replace(TastedRecordWriteFlow.albumSelect());
                      },
                    ),
                  ),
                WriteFirstStep() => const MaterialPage(
                    child: TastedRecordWriteFirstScreen(),
                  ),
                WriteSecondStep() => const MaterialPage(
                    child: TastedRecordWriteSecondScreen(),
                  ),
                WriteLastStep() => const MaterialPage(
                    child: TastedRecordWriteLastScreen(),
                  ),
              },
          ],
          onDidRemovePage: (_) {},
        );
      },
    );
  }
}

import 'dart:typed_data';

import 'package:brew_buds/domain/camera/camera_screen.dart';
import 'package:brew_buds/domain/coffee_note_post/post_photo_flow_presenter.dart';
import 'package:brew_buds/domain/photo/presenter/photo_grid_presenter.dart';
import 'package:brew_buds/domain/photo/view/photo_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostPhotoNavigator extends StatelessWidget {
  final void Function(BuildContext context, List<Uint8List> images) onDone;

  const PostPhotoNavigator({
    super.key,
    required this.onDone,
  });

  static PageRoute buildRoute({required void Function(BuildContext context, List<Uint8List> images) onDone}) {
    return MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        create: (_) => PostPhotoFlowPresenter(),
        child: PostPhotoNavigator(onDone: onDone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostPhotoFlowPresenter>(
      builder: (context, flow, child) {
        return Navigator(
          pages: [
            for (final step in flow.steps)
              switch (step) {
                PostPhotoFlow.album => MaterialPage(
                    child: ChangeNotifierProvider(
                      create: (_) => PhotoGridPresenter(),
                      child: PhotoGridView(
                        onDone: (images) {
                          onDone.call(context, images);
                        },
                        onTapCamera: () {
                          context.read<PostPhotoFlowPresenter>().replace(PostPhotoFlow.camera);
                        },
                      ),
                    ),
                  ),
                PostPhotoFlow.camera => MaterialPage(
                    child: CameraScreen(
                      onTapAlbum: (_) {
                        context.read<PostPhotoFlowPresenter>().replace(PostPhotoFlow.album);
                      },
                      onDone: (_, image) {
                        onDone.call(context, [image]);
                      },
                    ),
                  ),
              }
          ],
          onDidRemovePage: (_) {},
        );
      },
    );
  }
}

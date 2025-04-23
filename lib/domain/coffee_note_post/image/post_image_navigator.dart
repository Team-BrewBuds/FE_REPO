import 'dart:typed_data';

import 'package:brew_buds/domain/camera/camera_screen.dart';
import 'package:brew_buds/domain/coffee_note_post/image/post_image_flow_presenter.dart';
import 'package:brew_buds/domain/coffee_note_post/image/post_image_presenter.dart';
import 'package:brew_buds/domain/coffee_note_post/image/post_image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostImageNavigator extends StatelessWidget {
  final void Function(BuildContext context, List<Uint8List> images) onDone;

  const PostImageNavigator({
    super.key,
    required this.onDone,
  });

  static PageRoute buildRoute({required void Function(BuildContext context, List<Uint8List> images) onDone}) {
    return MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        create: (_) => PostImageFlowPresenter(),
        child: PostImageNavigator(onDone: onDone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostImageFlowPresenter>(
      builder: (context, flow, child) {
        return Navigator(
          pages: [
            for (final step in flow.steps)
              switch (step) {
                PostImageFlow.album => MaterialPage(
                    child: ChangeNotifierProvider(
                      create: (_) => PostImagePresenter(),
                      child: PostImageView(
                        onDone: (images) {
                          onDone.call(context, images);
                        },
                        onTapCamera: () {
                          context.read<PostImageFlowPresenter>().replace(PostImageFlow.camera);
                        },
                      ),
                    ),
                  ),
                PostImageFlow.camera => MaterialPage(
                    child: CameraScreen(
                      onTapAlbum: (_) {
                        context.read<PostImageFlowPresenter>().replace(PostImageFlow.album);
                      },
                      onDone: (_, image) async {
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

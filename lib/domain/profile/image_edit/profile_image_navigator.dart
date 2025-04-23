import 'package:brew_buds/domain/camera/camera_screen.dart';
import 'package:brew_buds/domain/profile/image_edit/profile_image_navigator_presenter.dart';
import 'package:brew_buds/domain/profile/image_edit/profile_image_presenter.dart';
import 'package:brew_buds/domain/profile/image_edit/profile_image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImageNavigator extends StatefulWidget {
  final String imageUrl;

  const ProfileImageNavigator._({
    required this.imageUrl,
  });

  static Widget buildWithPresenter({required String imageUrl}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileImageNavigatorPresenter>(
          create: (context) => ProfileImageNavigatorPresenter(),
        ),
        ChangeNotifierProvider<ProfileImagePresenter>(
          create: (context) => ProfileImagePresenter(currentImageUrl: imageUrl),
        ),
      ],
      child: ProfileImageNavigator._(imageUrl: imageUrl),
    );
  }

  @override
  State<ProfileImageNavigator> createState() => _ProfileImageNavigatorState();
}

class _ProfileImageNavigatorState extends State<ProfileImageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileImageNavigatorPresenter>(
      builder: (context, flow, child) {
        return Navigator(
          pages: [
            for (final step in flow.steps)
              switch (step) {
                // TODO: Handle this case.
                ProfileImageFlow.album => MaterialPage(
                    child: ProfileImageView(
                      previewHeight: MediaQuery.of(context).size.width,
                      onTapCamera: () {
                        context.read<ProfileImageNavigatorPresenter>().replace(ProfileImageFlow.camera);
                      },
                    ),
                  ),
                // TODO: Handle this case.
                ProfileImageFlow.camera => MaterialPage(
                    child: CameraScreen(
                      onDone: (_, imageData) => context.read<ProfileImagePresenter>().onSave(imageData),
                      onTapAlbum: (_) {
                        context.read<ProfileImagePresenter>().reset();
                        context.read<ProfileImageNavigatorPresenter>().replace(ProfileImageFlow.album);
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

import 'package:animations/animations.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/photo/presenter/photo_presenter.dart';
import 'package:brew_buds/photo/view/grid_photo_view_with_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildTastingRecordWriteScreen<T>({
  required Widget Function(BuildContext context, VoidCallback action) closeBuilder,
  void Function(T? result)? onClosed,
}) {
  return OpenContainer<T>(
    onClosed: onClosed,
    closedBuilder: closeBuilder,
    openBuilder: (context, _) {
      return ChangeNotifierProvider(
        create: (context) => PhotoPresenter(permissionStatus: PermissionRepository.instance.photos),
        builder: (context, _) => GridPhotoViewWithPreview(permissionStatus: PermissionRepository.instance.photos),
      );
    },
  );
}

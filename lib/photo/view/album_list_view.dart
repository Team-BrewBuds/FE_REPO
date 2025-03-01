import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/photo/model/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AlbumListView extends StatefulWidget {
  final List<Album> albumList;

  const AlbumListView({
    super.key,
    required this.albumList,
  });

  @override
  State<AlbumListView> createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            child: SvgPicture.asset(
              'assets/icons/x.svg',
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
            ),
          ),
        ),
        leadingWidth: 40,
        titleSpacing: 0,
        title: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              '앨범',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 22 / 13,
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.albumList.length,
        itemBuilder: (context, index) {
          final album = widget.albumList[index];
          return GestureDetector(
            onTap: () async {
              context.pop(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    child: AssetEntityImage(
                      width: 60,
                      height: 60,
                      album.thumbnail,
                      isOriginal: false,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          album.name,
                          style: TextStyles.labelMediumMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${album.imagesCount}',
                          style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray20),
      ),
    );
  }
}

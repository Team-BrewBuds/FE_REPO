import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AssetAlbumListView extends StatelessWidget {
  final List<AssetAlbum> albumList = PhotoRepository.instance.albumList;

  AssetAlbumListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ThrottleButton(
          onTap: () {
            Navigator.of(context).pop();
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
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text('앨범', style: TextStyles.title01SemiBold),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: albumList.length,
          itemBuilder: (context, index) {
            final album = albumList[index];
            return ThrottleButton(
              onTap: () async {
                Navigator.of(context).pop(index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      child: album.images.firstOrNull != null
                          ? AssetEntityImage(
                              width: 60,
                              height: 60,
                              album.images.first,
                              isOriginal: false,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: ColorStyles.gray70,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            album.assetPathEntity.isAll ? '최근 항목' : album.assetPathEntity.name,
                            style: TextStyles.labelMediumMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${album.images.length}',
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
      ),
    );
  }
}

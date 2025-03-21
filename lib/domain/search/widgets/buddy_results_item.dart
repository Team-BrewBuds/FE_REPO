import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/material.dart';

class BuddyResultsItem extends StatelessWidget {
  final String _imageUri;
  final String _nickname;
  final int _followerCount;
  final int _tastedRecordCount;

  const BuddyResultsItem({
    super.key,
    required String imageUri,
    required String nickname,
    required int followerCount,
    required int tastedRecordCount,
  })  : _imageUri = imageUri,
        _nickname = nickname,
        _followerCount = followerCount,
        _tastedRecordCount = tastedRecordCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      color: Colors.transparent,
      child: Row(
        children: [
          if (_imageUri.isNotEmpty) ...[
            const SizedBox(width: 8),
            MyNetworkImage(
              imageUrl: _imageUri,
              height: 40,
              width: 40,
              shape: BoxShape.circle,
            ),
          ],
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _nickname,
                  style: TextStyles.labelMediumMedium,
                ),
                Row(
                  children: [
                    Text(
                      '팔로워 $_followerCount',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                    ),
                    const SizedBox(width: 4),
                    Container(width: 1, height: 10, color: ColorStyles.gray30),
                    const SizedBox(width: 4),
                    Text(
                      '시음기록 $_tastedRecordCount',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/material.dart';

class SavedPostWidget extends StatelessWidget {
  final String title;
  final String subject;
  final String createdAt;
  final String author;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '게시글',
                  style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyles.title01SemiBold,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subject,
                      style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                    ),
                    const SizedBox(width: 4),
                    Container(width: 1, height: 10, color: ColorStyles.gray30),
                    const SizedBox(width: 4),
                    Text(
                      createdAt,
                      style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                    ),
                    const SizedBox(width: 4),
                    Container(width: 1, height: 10, color: ColorStyles.gray30),
                    const SizedBox(width: 4),
                    Text(
                      author,
                      style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (imageUrl != null) ...[
            const SizedBox(width: 24),
            MyNetworkImage(
              imageUrl: imageUrl,
              height: 64,
              width: 64,
            ),
          ],
        ],
      ),
    );
  }

  const SavedPostWidget({
    super.key,
    required this.title,
    required this.subject,
    required this.createdAt,
    required this.author,
    this.imageUrl,
  });
}

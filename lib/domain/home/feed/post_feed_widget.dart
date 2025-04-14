import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/home/feed/feed_widget.dart';
import 'package:brew_buds/domain/home/feed/presenter/post_feed_presenter.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_button.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_card.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

final class PostFeedWidget extends FeedWidget<PostFeedPresenter> {
  const PostFeedWidget({
    super.key,
    required super.isGuest,
    required super.onGuest, required super.onTapComments,
  });

  @override
  Widget buildBody(BuildContext context) {
    final state = context.select<PostFeedPresenter, BodyState>((presenter) => presenter.bodyState);
    Widget? child;

    if (state.images.isNotEmpty) {
      child = _buildImages(context: context, images: state.images);
    } else if (state.tastedRecords.isNotEmpty) {
      child = _buildTastedRecords(context: context, tastedRecords: state.tastedRecords);
    }

    if (child != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          _buildTextBody(
            context: context,
            subject: state.subject,
            title: state.title,
            contents: state.contents,
            tag: state.tag,
            bodyMaxLines: 2,
          ),
        ],
      );
    } else {
      return _buildTextBody(
        context: context,
        subject: state.subject,
        title: state.title,
        contents: state.contents,
        tag: state.tag,
      );
    }
  }

  Widget _buildImages({required BuildContext context, required List<String> images}) {
    final width = MediaQuery.of(context).size.width;
    return HorizontalSliderWidget(
      itemLength: images.length,
      itemBuilder: (context, index) => MyNetworkImage(
        imageUrl: images[index],
        height: width,
        width: width,
      ),
    );
  }

  Widget _buildTastedRecords({required BuildContext context, required List<TastedRecordInPost> tastedRecords}) {
    final width = MediaQuery.of(context).size.width;
    return HorizontalSliderWidget(
      itemLength: tastedRecords.length,
      itemBuilder: (context, index) => TastingRecordCard(
        image: MyNetworkImage(
          imageUrl: tastedRecords[index].thumbnailUrl,
          height: width,
          width: width,
          showGradient: true,
        ),
        rating: '${tastedRecords[index].rating}',
        type: tastedRecords[index].beanType,
        name: tastedRecords[index].beanName,
        flavors: tastedRecords[index].flavors,
      ),
      childBuilder: (context, index) => ThrottleButton(
        onTap: () {
          if (isGuest) {
            onGuest.call();
          } else {
            showTastingRecordDetail(context: context, id: tastedRecords[index].id);
          }
        },
        child: Container(
          color: ColorStyles.white,
          child: TastingRecordButton(
            name: tastedRecords[index].beanName,
            bodyText: tastedRecords[index].contents,
          ),
        ),
      ),
    );
  }

  Widget _buildTextBody({
    required BuildContext context,
    required PostSubject subject,
    required String title,
    required String contents,
    required String tag,
    int bodyMaxLines = 5,
  }) {
    final isOverFlow = calcOverFlow(context, contents, bodyMaxLines);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_buildSubject(subject: subject), const Spacer()],
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            title,
            style: TextStyles.title01SemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            contents,
            style: TextStyles.bodyRegular,
            maxLines: bodyMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isOverFlow ? 8 : 0),
          if (isOverFlow)
            ThrottleButton(
              onTap: () {
                if (isGuest) {
                  onGuest.call();
                } else {
                  final id = context.read<PostFeedPresenter>().feed.data.id;
                  showPostDetail(context: context, id: id);
                }
              },
              child: Text(
                '더보기',
                style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.gray50),
              ),
            ),
          if (tag.isNotEmpty) ...[
            const SizedBox(height: 12, width: double.infinity),
            Text(tag, style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.red)),
          ],
        ],
      ),
    );
  }

  Widget _buildSubject({required PostSubject subject}) {
    return Container(
      padding: const EdgeInsets.all(5.5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SvgPicture.asset(subject.iconPath, width: 12, height: 12),
          const SizedBox(width: 2),
          Text(subject.toString(), style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white)),
        ],
      ),
    );
  }

  @override
  onTappedCommentsButton(BuildContext context) {
    final id = context.read<PostFeedPresenter>().feed.data.id;
    final author = context.read<PostFeedPresenter>().feed.data.author;
    onTapComments.call(false, id, author);
  }

  @override
  onTappedProfile(BuildContext context) {
    final author = context.read<PostFeedPresenter>().feed.data.author;
    pushToProfile(context: context, id: author.id);
  }
}

import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/domain/detail/post_detail_presenter.dart';
import 'package:brew_buds/domain/detail/post_detail_view.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_post.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_presenter.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPostsView extends StatefulWidget {
  const PopularPostsView({super.key});

  @override
  State<PopularPostsView> createState() => _PopularPostsViewState();
}

class _PopularPostsViewState extends State<PopularPostsView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PopularPostsPresenter>().initState();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 인기글'),
        titleSpacing: 0,
        centerTitle: true,
        titleTextStyle: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
      ),
      body: Container(
        color: ColorStyles.gray20,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            buildSubjectFilter(),
            CupertinoSliverRefreshControl(
              onRefresh: () {
                return context.read<PopularPostsPresenter>().onRefresh();
              },
              builder: (
                BuildContext context,
                RefreshIndicatorMode refreshState,
                double pulledExtent,
                double refreshTriggerPullDistance,
                double refreshIndicatorExtent,
              ) {
                switch (refreshState) {
                  case RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh:
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  default:
                    return Container();
                }
              },
            ),
            Selector<PopularPostsPresenter, DefaultPage<Post>>(
                selector: (context, presenter) => presenter.page,
                builder: (context, page, child) {
                  return SliverList.separated(
                    itemCount: page.results.length,
                    itemBuilder: (context, index) {
                      final popularPost = page.results[index];
                      return GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            barrierColor: ColorStyles.white,
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ChangeNotifierProvider<PostDetailPresenter>(
                                create: (_) => PostDetailPresenter(id: popularPost.id),
                                child: const PostDetailView(),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
                          color: ColorStyles.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PopularPostWidget(
                                  title: popularPost.title,
                                  bodyText: popularPost.contents,
                                  likeCount: '${popularPost.likeCount > 999 ? '999+' : popularPost.likeCount}',
                                  isLiked: popularPost.isLiked,
                                  commentsCount:
                                      '${popularPost.commentsCount > 999 ? '999+' : popularPost.commentsCount}',
                                  hasComment: false,
                                  tag: popularPost.subject.toString(),
                                  writingTime: popularPost.createdAt,
                                  hitsCount: '조회 ${popularPost.viewCount > 9999 ? '9999+' : popularPost.viewCount}',
                                  nickName: popularPost.author.nickname,
                                  imageUrl: popularPost.imagesUrl.firstOrNull,
                                ),
                              ),
                              SizedBox(width: popularPost.imagesUrl.isNotEmpty ? 8 : 0),
                              popularPost.imagesUrl.isNotEmpty
                                  ? MyNetworkImage(
                                      imageUrl: popularPost.imagesUrl.first,
                                      height: 80,
                                      width: 80,
                                      color: const Color(0xffD9D9D9),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray20),
                  );
                }),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Text(
                    '주간 인기글을 모두 읽었어요',
                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.gray60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSubjectFilter() {
    return SliverAppBar(
      titleSpacing: 0,
      floating: true,
      leading: Container(),
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Selector<PopularPostsPresenter, PopularPostSubjectFilterState>(
              selector: (context, presenter) => presenter.subjectFilterState,
              builder: (context, subjectFilterState, child) {
                return Row(
                  children: List<Widget>.generate(
                    subjectFilterState.postSubjectFilterList.length,
                    (index) {
                      return ButtonFactory.buildOvalButton(
                        onTapped: () {
                          scrollController.jumpTo(0);
                          context.read<PopularPostsPresenter>().onChangeSubject(index);
                        },
                        text: subjectFilterState.postSubjectFilterList[index],
                        style: index == subjectFilterState.currentIndex
                            ? OvalButtonStyle.fill(
                                color: ColorStyles.black,
                                textColor: ColorStyles.white,
                                size: OvalButtonSize.medium,
                              )
                            : OvalButtonStyle.line(
                                color: ColorStyles.gray70,
                                textColor: ColorStyles.gray70,
                                size: OvalButtonSize.medium,
                              ),
                      );
                    },
                  ).separator(separatorWidget: const SizedBox(width: 6)).toList(),
                );
              }),
        ),
      ),
    );
  }
}

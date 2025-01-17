import 'dart:async';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/comments_widget.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/home/widgets/slider_view.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:brew_buds/profile/model/bean_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TastedRecordDetailView extends StatefulWidget {
  const TastedRecordDetailView({super.key});

  @override
  State<TastedRecordDetailView> createState() => _TastedRecordDetailViewState();
}

class _TastedRecordDetailViewState extends State<TastedRecordDetailView> {
  final GlobalKey _commentsListKey = GlobalKey();
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;
  int currentIndex = 0;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppbar(),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageListView(),
                _buildButtons(),
                _buildTitle(),
                _buildAuthorProfile(),
                _buildContents(),
                _buildTastingGraph(),
                _buildBeanDetail(),
                _buildComments(constraints.maxHeight),
              ],
            ),
          );
        }),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: _buildBottomTextField(),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            const Text('시음기록', style: TextStyles.title02SemiBold),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/more.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Container(
          width: double.infinity,
          height: 1,
          color: ColorStyles.gray20,
        ),
      ),
    );
  }

  Widget _buildBottomTextField() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 12),
        decoration:
            const BoxDecoration(border: Border(top: BorderSide(color: ColorStyles.gray20)), color: ColorStyles.white),
        child: TextField(
          controller: _textEditingController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: '~ 님에게 댓글 추가..',
            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorStyles.gray40),
              borderRadius: BorderRadius.all(Radius.circular(24)),
              gapPadding: 8,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorStyles.gray40),
              borderRadius: BorderRadius.all(Radius.circular(24)),
              gapPadding: 8,
            ),
            contentPadding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
              child: ButtonFactory.buildOvalButton(
                onTapped: () {
                  if (_textEditingController.text.isNotEmpty) {}
                },
                text: '전송',
                style: OvalButtonStyle.fill(
                  color: ColorStyles.black,
                  textColor: ColorStyles.white,
                  size: OvalButtonSize.large,
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 63),
            constraints: const BoxConstraints(minHeight: 48, maxHeight: 112),
          ),
        ),
      ),
    );
  }

  Widget _buildImageListView() {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: SliderView(
            itemLength: 5,
            itemBuilder: (context, index) {
              return index == 0
                  ? TastingRecordCard(
                      image: Image.network('https://picsum.photos/${width.ceil()}/${height.ceil()}', fit: BoxFit.cover),
                      rating: '4.5',
                      type: BeanType.singleOrigin.toString(),
                      name: '에티오피아 리무 게샤 워시드',
                      tags: [
                        '초콜릿',
                        '바닐라',
                        '트로피칼',
                        '견과류',
                      ],
                    )
                  : Image.network(
                      'https://picsum.photos/${width.ceil()}/${height.ceil()}',
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                      loadingBuilder: (context, widget, event) => SizedBox(
                        height: height,
                        width: width,
                        child: CupertinoActivityIndicator(),
                      ),
                      errorBuilder: (context, object, stackTracer) => Container(),
                    );
            },
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        5 > 1
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(child: _buildAnimatedSmoothIndicator()),
              )
            : const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAnimatedSmoothIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: 5, // Replace count
        axisDirection: Axis.horizontal,
        effect: const ExpandingDotsEffect(
          dotHeight: 7,
          dotWidth: 7,
          spacing: 4,
          dotColor: ColorStyles.gray60,
          activeDotColor: ColorStyles.red,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        children: [
          buildLikeButton(),
          const SizedBox(width: 6),
          buildCommentButton(),
          const Spacer(),
          buildSaveButton(),
        ],
      ),
    );
  }

  Widget buildLikeButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        true ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(
          true ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '좋아요 53',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {},
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildCommentButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        true ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(
          true ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '댓글 30',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {
        if (_commentsListKey.currentContext != null) {
          Scrollable.ensureVisible(
            _commentsListKey.currentContext!,
            duration: Duration(milliseconds: 300),
          );
        }
      },
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildSaveButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        true ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(
          true ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '저장',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      iconAlign: ButtonIconAlign.left,
      onTapped: () {},
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        '에티오피아 할로 하르투메 G1 워시드',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          height: 26.25 / 22,
          letterSpacing: -0.02,
        ),
      ),
    );
  }

  Widget _buildAuthorProfile() {
    return Padding(
      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      child: InkWell(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //프로필 사진
            Container(
              height: 36,
              width: 36,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xffD9D9D9),
                shape: BoxShape.circle,
              ),
              child: Image.network(
                '',
                fit: BoxFit.cover,
                errorBuilder: (context, _, trace) => Container(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ashedpotatom',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyles.title02SemiBold,
              ),
            ),
            FollowButton(onTap: () {}, isFollowed: true),
          ],
        ),
      ),
    );
  }

  Widget _buildContents() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(
              (4.5).ceil(),
              (index) {
                if (index + 1 < 4.5) {
                  return SvgPicture.asset(
                    height: 16,
                    width: 16,
                    'assets/icons/star_fill.svg',
                    colorFilter: ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                  );
                } else {
                  return SvgPicture.asset(
                    height: 16,
                    width: 16,
                    'assets/icons/star_half.svg',
                  );
                }
              },
            )..addAll(
                [
                  SizedBox(width: 2),
                  Text(
                    '(4.5)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 18 / 12,
                        letterSpacing: -0.01,
                        color: ColorStyles.gray70),
                  ),
                ],
              ),
          ),
          SizedBox(height: 7),
          Row(
            children: ['초콜릿', '바닐라', '트로피칼', '견과류']
                .map((taste) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 0.8),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Text(
                        taste,
                        style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70),
                      ),
                    ))
                .separator(separatorWidget: SizedBox(width: 2))
                .toList()
              ..addAll(
                [
                  Spacer(),
                  Text(
                    '2024-11-11',
                    style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                  ),
                ],
              ),
          ),
          SizedBox(height: 12),
          Text(
            '산미 좋아하시면 에티오피아 괜찮아요^^ 나쁘지 않은데 조금 텁텁한 맛이 있는거 같아요. 두번 사먹을 맛이긴 하나 자주 먹을거 같진 않네요산미 좋아하시면 에티오피아 괜찮아요^^ 나쁘지 않은데 조금 텁텁한 맛이 있는거 같아요. 두번 사먹을 맛이긴 하나 자주 먹을거 같진 않네요산미 좋아하시면 에티오피아 괜찮아요^^ 나쁘지 않은데 조금 텁텁한 맛이 있는거 같아요. 두번 사먹을 맛이긴 하나 자주 먹을거 같진 않네요',
            style: TextStyles.bodyNarrowRegular,
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: ColorStyles.gray10,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/location.svg',
                  height: 16,
                  width: 16,
                ),
                SizedBox(width: 4),
                Text('장소', style: TextStyles.labelSmallSemiBold),
                SizedBox(width: 8),
                Text('마일드스톤 커피', style: TextStyles.bodyNarrowRegular),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTastingGraph() {
    final activeStyle = TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.red);
    final inactiveStyle = TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60);
    final minValue = 1;
    final maxValue = 5;
    final midValue = ((minValue + maxValue) / 2).ceil();
    final bodyValue = 2;
    final acidityValue = 4;
    final acerbityValue = 3;
    final sweetnessValue = 1;
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('테이스팅', style: TextStyles.title02SemiBold),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '트로피칼',
                  textAlign: TextAlign.center,
                  style: bodyValue < midValue ? activeStyle : inactiveStyle,
                ),
              ),
              Expanded(
                flex: 9,
                child: AbsorbPointer(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      trackCornerRadius: 0,
                      activeTrackHeight: 2,
                      inactiveTrackHeight: 2,
                      activeTrackColor: Color(0xFFD9D9D9),
                      inactiveTrackColor: Color(0xFFD9D9D9),
                      tickOffset: Offset(0, -2),
                      minorTickSize: Size(4, 2),
                      tickSize: Size.zero,
                      inactiveMinorTickColor: ColorStyles.white,
                      activeMinorTickColor: ColorStyles.white,
                      thumbColor: ColorStyles.red,
                      thumbRadius: 7,
                    ),
                    child: SfSlider(
                      interval: 5,
                      minorTicksPerInterval: 3,
                      showTicks: true,
                      value: bodyValue,
                      min: minValue,
                      max: maxValue,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '무거운',
                  textAlign: TextAlign.center,
                  style: bodyValue > midValue ? activeStyle : inactiveStyle,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '산미약한',
                  textAlign: TextAlign.center,
                  style: acidityValue < midValue ? activeStyle : inactiveStyle,
                ),
              ),
              Expanded(
                flex: 9,
                child: AbsorbPointer(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      trackCornerRadius: 0,
                      activeTrackHeight: 2,
                      inactiveTrackHeight: 2,
                      activeTrackColor: Color(0xFFD9D9D9),
                      inactiveTrackColor: Color(0xFFD9D9D9),
                      tickOffset: Offset(0, -2),
                      minorTickSize: Size(4, 2),
                      tickSize: Size.zero,
                      inactiveMinorTickColor: ColorStyles.white,
                      activeMinorTickColor: ColorStyles.white,
                      thumbColor: ColorStyles.red,
                      thumbRadius: 7,
                    ),
                    child: SfSlider(
                      interval: 5,
                      minorTicksPerInterval: 3,
                      showTicks: true,
                      value: acidityValue,
                      min: minValue,
                      max: maxValue,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '산미강한',
                  textAlign: TextAlign.center,
                  style: acidityValue > midValue ? activeStyle : inactiveStyle,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '쓴맛약한',
                  textAlign: TextAlign.center,
                  style: acerbityValue < midValue ? activeStyle : inactiveStyle,
                ),
              ),
              Expanded(
                flex: 9,
                child: AbsorbPointer(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      trackCornerRadius: 0,
                      activeTrackHeight: 2,
                      inactiveTrackHeight: 2,
                      activeTrackColor: Color(0xFFD9D9D9),
                      inactiveTrackColor: Color(0xFFD9D9D9),
                      tickOffset: Offset(0, -2),
                      minorTickSize: Size(4, 2),
                      tickSize: Size.zero,
                      inactiveMinorTickColor: ColorStyles.white,
                      activeMinorTickColor: ColorStyles.white,
                      thumbColor: ColorStyles.red,
                      thumbRadius: 7,
                    ),
                    child: SfSlider(
                      interval: 5,
                      minorTicksPerInterval: 3,
                      showTicks: true,
                      value: acerbityValue,
                      min: minValue,
                      max: maxValue,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '쓴맛강한',
                  textAlign: TextAlign.center,
                  style: acerbityValue > midValue ? activeStyle : inactiveStyle,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '단맛약한',
                  textAlign: TextAlign.center,
                  style: sweetnessValue < midValue ? activeStyle : inactiveStyle,
                ),
              ),
              Expanded(
                flex: 9,
                child: AbsorbPointer(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      trackCornerRadius: 0,
                      activeTrackHeight: 2,
                      inactiveTrackHeight: 2,
                      tickOffset: Offset(0, -2),
                      minorTickSize: Size(4, 2),
                      tickSize: Size.zero,
                      inactiveMinorTickColor: ColorStyles.white,
                      activeMinorTickColor: ColorStyles.white,
                      thumbColor: ColorStyles.red,
                      thumbRadius: 7,
                    ),
                    child: SfSlider(
                      interval: 5,
                      minorTicksPerInterval: 3,
                      showTicks: true,
                      value: sweetnessValue,
                      min: minValue,
                      max: maxValue,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '단맛강한',
                  textAlign: TextAlign.center,
                  style: sweetnessValue > midValue ? activeStyle : inactiveStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeanDetail() {
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('원두 상세정보', style: TextStyles.title02SemiBold),
          SizedBox(height: 24),
          Row(
            children: [
              Text('원두 유형', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('싱글오리진(디카페인)', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('생산 국가', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('에티오피아', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('생산 지역', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('Cerrado, Minas Gerais', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('원두 품종', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('Catuai, Mundo Novo, Others', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('가공 방식', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('Pulped Natural', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('로스터리', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('Lavatree', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('로스팅 포인트', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('라이트 미디엄', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Container(height: 1, color: ColorStyles.gray20),
          SizedBox(height: 12),
          Row(
            children: [
              Text('추출 방식', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('핸드 드립', style: TextStyles.labelSmallMedium),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('음료 유형', style: TextStyles.labelSmallSemiBold),
              Spacer(),
              Text('핫', style: TextStyles.labelSmallMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComments(double minHeight) {
    final length = 20;
    return ConstrainedBox(
      constraints: length == 0 ? BoxConstraints(maxHeight: minHeight + 24) : BoxConstraints(minHeight: minHeight + 24),
      child: Padding(
        key: _commentsListKey,
        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('댓글 ($length)', style: TextStyles.title02SemiBold),
          ]..addAll(
              length == 0
                  ? [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '아직 댓글이 없어요',
                              style: TextStyles.title02SemiBold,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '댓글을 남겨보세요',
                              style: TextStyles.captionSmallMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ]
                  : [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: length,
                        itemBuilder: (context, index) {
                          return CommentsWidget(
                            commentItem: CommentItem(
                              padding: EdgeInsets.all(16),
                              profileImageUri: '',
                              nickName: '커피에빠져죽고싶은',
                              createdAt: '1시간 전',
                              isWriter: true,
                              contents: '이거 커피 맛있어요!',
                              isLiked: false,
                              likeCount: '$index',
                              onTappedLikeButton: () {},
                            ),
                          );
                        },
                      ),
                    ],
            ),
        ),
      ),
    );
  }
}

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/domain/coffee_note_post/view/tasted_record_grid_presenter.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TastedRecordGridView extends StatefulWidget {
  const TastedRecordGridView({super.key});

  @override
  State<TastedRecordGridView> createState() => _TastedRecordGridViewState();

  static Widget build({required List<TastedRecordInProfile> tastedRecords}) {
    return ChangeNotifierProvider(
      create: (context) => TastedRecordGridPresenter(selectedTastedRecords: List.from(tastedRecords)),
      // ✅ 새로운 `Provider` 생성
      child: const TastedRecordGridView(),
    );
  }
}

class _TastedRecordGridViewState extends State<TastedRecordGridView> {
  late final Throttle paginationThrottle;

  @override
  void initState() {
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<TastedRecordGridPresenter>().fetchMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Selector<TastedRecordGridPresenter, GridViewState>(
          selector: (context, presenter) => presenter.gridViewState,
          builder: (context, gridViewState, child) {
            if (context.select<TastedRecordGridPresenter, bool>(
                (presenter) => presenter.isLoading && gridViewState.tastedRecords.isEmpty)) {
              return const Center(child: CupertinoActivityIndicator(color: ColorStyles.gray70));
            } else {
              return gridViewState.tastedRecords.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scroll) {
                        if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                          paginationThrottle.setValue(null);
                        }
                        return false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: gridViewState.tastedRecords.length,
                          itemBuilder: (context, index) {
                            final tastedRecord = gridViewState.tastedRecords[index];
                            return FutureButton(
                              onTap: () => context.read<TastedRecordGridPresenter>().onSelected(tastedRecord),
                              onError: (_) {
                                EventBus.instance.fire(const MessageEvent(message: '시음기록은 최대 10개까지 첨부할 수 있어요.'));
                              },
                              child: _buildGridItem(
                                imageUrl: tastedRecord.imageUrl,
                                rating: tastedRecord.rating,
                                beanName: tastedRecord.beanName,
                                selectedItemLength: gridViewState.selectedTastedRecords.length,
                                selectedIndex: gridViewState.selectedTastedRecords.indexOf(tastedRecord),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : _buildEmpty();
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      centerTitle: false,
      backgroundColor: ColorStyles.white,
      toolbarHeight: 52,
      title: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              left: 0,
              child: ThrottleButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                ),
              ),
            ),
            Center(child: Text('시음기록', style: TextStyles.title01SemiBold)),
            Positioned(
              right: 0,
              child: Selector<TastedRecordGridPresenter, List<TastedRecordInProfile>>(
                selector: (context, presenter) => presenter.selectedTastedRecords,
                builder: (context, selectedTastedRecords, child) {
                  final hasSelectedItem = selectedTastedRecords.isNotEmpty;
                  return AbsorbPointer(
                    absorbing: !hasSelectedItem,
                    child: ThrottleButton(
                      onTap: () {
                        Navigator.of(context).pop(selectedTastedRecords);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: hasSelectedItem ? ColorStyles.red : ColorStyles.gray20,
                        ),
                        child: Text(
                          '다음',
                          style: TextStyles.labelSmallMedium.copyWith(
                            color: hasSelectedItem ? ColorStyles.white : ColorStyles.gray40,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required String imageUrl,
    required double rating,
    required String beanName,
    required int selectedItemLength,
    required int selectedIndex,
  }) {
    final isSelected = selectedIndex != -1;
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return MyNetworkImage(
                            imageUrl: imageUrl,
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 6,
                      bottom: 6,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/star_fill.svg',
                            height: 12,
                            width: 12,
                            colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 2),
                          Text('$rating', style: TextStyles.captionSmallSemiBold.copyWith(color: ColorStyles.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  beanName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    height: 12 / 10,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (isSelected) ...[
          Positioned.fill(child: Container(color: ColorStyles.black30)),
          Positioned(
            // 선택된 사진 순번표시
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorStyles.white, width: 1),
                color: ColorStyles.red,
              ),
              width: 20,
              height: 20,
              child: Center(
                child: selectedItemLength == 1
                    ? SvgPicture.asset(
                        'assets/icons/check_red_filled.svg',
                        height: 20,
                        width: 20,
                      )
                    : Text(
                        (selectedIndex + 1).toString(),
                        style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.white),
                      ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  _buildEmpty() {
    return Center(
      child: Text('첫 시음기록을 작성해 보세요.', style: TextStyles.title02SemiBold),
    );
  }
}

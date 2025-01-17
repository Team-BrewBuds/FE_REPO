import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FollowerListPB extends StatefulWidget {
  final int initialIndex;

  const FollowerListPB({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<FollowerListPB> createState() => _FollowerListPBState();
}

class _FollowerListPBState extends State<FollowerListPB> {
  late int currentIndex;
  bool isRefresh = false;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTitle(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final isFollowed = index % 2 == 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffD9D9D9),
                          ),
                          child: Image.network(
                            '',
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            '커피의 신',
                            style: TextStyles.labelMediumMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ButtonFactory.buildOvalButton(
                          onTapped: () {},
                          text: isFollowed ? '팔로잉' : '팔로우',
                          style: isFollowed
                              ? OvalButtonStyle.fill(
                                  color: ColorStyles.gray20, textColor: ColorStyles.gray80, size: OvalButtonSize.large)
                              : OvalButtonStyle.fill(
                                  color: ColorStyles.red, textColor: ColorStyles.white, size: OvalButtonSize.large),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildTitle() {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            const Text('아이디', style: TextStyles.title02SemiBold),
            const Spacer(),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorWeight: 2,
      indicatorPadding: const EdgeInsets.only(top: 4, left: 16, right: 16),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: ColorStyles.black,
      labelPadding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      labelStyle: TextStyles.title01SemiBold,
      labelColor: ColorStyles.black,
      unselectedLabelStyle: TextStyles.title01SemiBold,
      unselectedLabelColor: ColorStyles.gray50,
      dividerHeight: 1,
      dividerColor: ColorStyles.gray20,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      tabs: const [
        Tab(text: '팔로워', height: 31),
        Tab(text: '팔로잉', height: 31),
      ],
      onTap: (index) {
        if (currentIndex == index) {
          setState(() {
            isRefresh = true;
          });
          Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
            setState(() {
              isRefresh = false;
            });
          });
        } else {
          setState(() {
            currentIndex = index;
          });
        }
      },
    );
  }
}

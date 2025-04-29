import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/setting/model/blocked_user.dart';
import 'package:brew_buds/domain/setting/presenter/blocking_user_management_presenter.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BlockingUserManagementView extends StatefulWidget {
  const BlockingUserManagementView({super.key});

  @override
  State<BlockingUserManagementView> createState() => _BlockingUserManagementViewState();
}

class _BlockingUserManagementViewState extends State<BlockingUserManagementView> {
  late final Throttle paginationThrottle;
  late final ScrollController scrollController;
  bool _showHelper = true;

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
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(_scrollListener);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    paginationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (scrollController.position.pixels > scrollController.position.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<BlockingUserManagementPresenter>().fetchMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (_showHelper) _buildHelper(),
              Expanded(
                child: Selector<BlockingUserManagementPresenter, List<BlockedUser>>(
                  selector: (context, presenter) => presenter.users,
                  builder: (context, users, child) {
                    return users.isNotEmpty
                        ? Builder(builder: (context) {
                            final isLoading = context.select<BlockingUserManagementPresenter, bool>(
                              (presenter) => presenter.isLoading,
                            );
                            return isLoading
                                ? const Center(child: CupertinoActivityIndicator(color: ColorStyles.gray70))
                                : _buildBlockedUserList(users: users);
                          })
                        : Center(child: Text('차단한 버디가 없어요.', style: TextStyles.title02SemiBold));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThrottleButton(
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
            Text('차단 관리', style: TextStyles.title02Bold),
            const Spacer(),
            const SizedBox(
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorStyles.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text.rich(
            TextSpan(
              text: '차단하게 되면 차단한 버디의 계정, 커피 노트, 반응이 ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 16.8 / 12,
                letterSpacing: -0.01,
                color: ColorStyles.white,
              ),
              children: [
                TextSpan(
                  text: '노출되지 않으며',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    height: 16.8 / 12,
                    letterSpacing: -0.01,
                    color: ColorStyles.white,
                  ),
                ),
                const TextSpan(
                  text: ' 상대방에게는 차단했다는 정보를 알리지 않아요.',
                ),
              ],
            ),
          )),
          const SizedBox(width: 16),
          ThrottleButton(
            onTap: () {
              setState(() {
                _showHelper = false;
              });
            },
            child: SvgPicture.asset(
              width: 16,
              height: 16,
              'assets/icons/x.svg',
              colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUserList({required List<BlockedUser> users}) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              MyNetworkImage(
                imageUrl: user.profileImageUri,
                height: 48,
                width: 48,
                shape: BoxShape.circle,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user.nickname,
                  style: TextStyles.labelMediumMedium,
                ),
              ),
              const SizedBox(width: 8),
              FutureButton(
                onTap: () => context.read<BlockingUserManagementPresenter>().unBlockAt(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorStyles.black,
                  ),
                  child: Text(
                    '차단 해제',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      height: 16.25 / 13,
                      color: ColorStyles.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin HomeViewMixin<T extends StatefulWidget, Presenter extends HomeViewPresenter> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Presenter>().initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Presenter>(builder: (context, presenter, _) {
      return Container(
        color: ColorStyles.gray20,
        child: CustomScrollView(
          slivers: [
            buildListViewTitle(presenter),
            _buildRefreshWidget(presenter),
            _buildListView(presenter),
          ],
        ),
      );
    });
  }

  SliverAppBar buildListViewTitle(Presenter presenter) => const SliverAppBar(toolbarHeight: 0);

  Widget buildListItem(Presenter presenter, int index);

  Widget _buildRefreshWidget(Presenter presenter) {
    return CupertinoSliverRefreshControl(
      onRefresh: presenter.onRefresh,
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
    );
  }

  SliverList _buildListView(Presenter presenter) {
    return SliverList.separated(
      itemCount: presenter.feeds.length,
      itemBuilder: (context, index) => buildListItem(presenter, index),
      separatorBuilder: (context, index) => _buildSeparator(presenter, index),
    );
  }

  Widget _buildSeparator(Presenter presenter, int index) {
    if (index % 12 == 11) {
      return _buildRemandedBuddies(presenter);
    } else {
      return Container(height: 12, color: ColorStyles.gray50);
    }
  }

  Widget _buildRemandedBuddies(Presenter presenter) {
    if (presenter.remandedUsers.isNotEmpty) {
      //추천 버디 UI
      return Container(height: 290, color: Colors.red,);
    } else {
      return Container(height: 12, color: ColorStyles.gray50);
    }
  }
}

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/detail/coffee_bean/tasted_record_in_coffee_bean_list_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Widget buildTastedRecordInCoffeeBeanListScreen({required String name, required int id}) {
  return ChangeNotifierProvider(
    create: (context) => TastedRecordInCoffeeBeanListPresenter(id: id),
    child: TastedRecordInCoffeeBeanListScreen(name: name),
  );
}

final class TastedRecordInCoffeeBeanListScreen extends StatefulWidget {
  final String name;

  const TastedRecordInCoffeeBeanListScreen({
    super.key,
    required this.name,
  });

  @override
  State<TastedRecordInCoffeeBeanListScreen> createState() => _TastedRecordInCoffeeBeanListScreenState();
}

class _TastedRecordInCoffeeBeanListScreenState extends State<TastedRecordInCoffeeBeanListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 29),
              Row(
                children: [
                  Text('시음기록', style: TextStyles.title02SemiBold),
                  const SizedBox(width: 2),
                  Selector<TastedRecordInCoffeeBeanListPresenter, int>(
                    selector: (context, presenter) => presenter.count,
                    builder: (context, count, child) => Text('($count)', style: TextStyles.captionMediumSemiBold),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Selector<TastedRecordInCoffeeBeanListPresenter, List<TastedRecordInCoffeeBeanPresenter>>(
                  selector: (context, presenter) => presenter.presenters,
                  builder: (context, presenters, child) {
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 48),
                      itemCount: presenters.length,
                      itemBuilder: (context, index) {
                        final tastedRecordPresenter = presenters[index];
                        return ChangeNotifierProvider.value(
                          value: tastedRecordPresenter,
                          child: ThrottleButton(
                            onTap: () {
                              ScreenNavigator.showTastedRecordDetail(context: context, id: tastedRecordPresenter.id);
                            },
                            child: const TastedRecordInCoffeeBeanWidget(),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Container(height: 1, color: ColorStyles.gray20),
                    );
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
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThrottleButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.name,
                style: TextStyles.title02SemiBold,
                overflow: TextOverflow.ellipsis,
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
}

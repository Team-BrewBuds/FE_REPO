import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/detail/coffee_bean/tasted_record_in_coffee_bean_list_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_widget.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TastedRecordInCoffeeBeanListPresenter>().initState();
    });
    super.initState();
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
              const SizedBox(height: 29),
              Row(
                children: [
                  const Text('시음기록', style: TextStyles.title02SemiBold),
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
                child: Selector<TastedRecordInCoffeeBeanListPresenter, DefaultPage<TastedRecordInCoffeeBean>>(
                  selector: (context, presenter) => presenter.page,
                  builder: (context, page, child) {
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 48),
                      itemCount: page.results.length,
                      itemBuilder: (context, index) {
                        final tastedRecord = page.results[index];
                        return GestureDetector(
                          onTap: () {
                            showTastingRecordDetail(context: context, id: tastedRecord.id);
                          },
                          child: TastedRecordInCoffeeBeanWidget(
                            authorNickname: tastedRecord.nickname,
                            rating: tastedRecord.rating.toDouble(),
                            flavors: tastedRecord.flavors,
                            imageUrl: tastedRecord.photoUrl,
                            contents: tastedRecord.contents,
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Container(
                        height: 1,
                        color: ColorStyles.gray20,
                      ),
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
            GestureDetector(
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

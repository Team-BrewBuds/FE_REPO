import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/domain/report/report_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Future<String?> pushToReportScreen(BuildContext context, {required int id, required String type}) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ReportPresenter(id: id, type: type),
        child: const ReportScreen(),
      ),
    ),
  );
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Selector<ReportPresenter, String>(
              selector: (context, presenter) => presenter.selectedReason,
              builder: (context, selectedReason, child) => _buildReportReason(context, selectedReason: selectedReason),
            ),
            const Spacer(),
            Selector<ReportPresenter, bool>(
              selector: (context, presenter) => presenter.canReport,
              builder: (context, canReport, child) => _buildReportButton(context, canReport: canReport),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            Text('신고하기', style: TextStyles.title02SemiBold),
            const Spacer(),
            const SizedBox(width: 24, height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildReportReason(BuildContext context, {required String selectedReason}) {
    final reasonList = context.read<ReportPresenter>().reasonList;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('신고 이유를 선택해 주세요.', style: TextStyles.title04SemiBold),
          const SizedBox(height: 48),
          ...reasonList.map((reason) {
            final isSelected = reason == selectedReason;
            return ThrottleButton(
              onTap: () {
                context.read<ReportPresenter>().onSelectReason(reason);
              },
              child: Row(
                children: [
                  isSelected
                      ? SvgPicture.asset('assets/icons/check_red_filled.svg', width: 18, height: 18)
                      : Container(
                          width: 18,
                          height: 18,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorStyles.gray50)),
                        ),
                  const SizedBox(width: 8),
                  Text(reason, style: TextStyles.labelMediumMedium),
                  const Spacer(),
                ],
              ),
            );
          }).separator(separatorWidget: const SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, {required bool canReport}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 46, left: 16, right: 16),
      child: AbsorbPointer(
        absorbing: !canReport,
        child: ThrottleButton(
          onTap: () {
            context.read<ReportPresenter>().report().then((result) {
              //수정필요
              switch (result) {
                case Success<String>():
                  Navigator.of(context).pop(result.data);
                  break;
                case Error<String>():
                  _showSnackBar(context, message: result.e);
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: BoxDecoration(
                color: canReport ? ColorStyles.black : ColorStyles.gray20,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Text(
              '신고하기',
              style: TextStyles.labelMediumMedium.copyWith(color: canReport ? ColorStyles.white : ColorStyles.gray40),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black90,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

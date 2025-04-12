import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_first_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_presenter.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool?> showTastedRecordUpdateScreen({required BuildContext context, required TastedRecord tastedRecord}) {
  return showCupertinoModalPopup<bool>(
    barrierColor: ColorStyles.white,
    barrierDismissible: false,
    context: context,
    builder: (context) => _buildTastingWriteScreen(context, tastedRecord),
  );
}

Widget _buildTastingWriteScreen(BuildContext context, TastedRecord tastedRecord) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TastedRecordUpdatePresenter(tastedRecord: tastedRecord)),
    ],
    child: MaterialApp(
      title: 'Brew Buds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const TastedRecordUpdateFirstScreen(),
    ),
  );
}

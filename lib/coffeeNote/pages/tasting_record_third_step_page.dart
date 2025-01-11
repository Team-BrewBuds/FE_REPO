import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:flutter/material.dart';

import 'core/tasing_record_mixin.dart';

class TastingRecordThirdStepPage extends StatefulWidget {
  const TastingRecordThirdStepPage({super.key});

  @override
  State<TastingRecordThirdStepPage> createState() => _TastingRecordThirdStepPageState();
}

class _TastingRecordThirdStepPageState extends State<TastingRecordThirdStepPage> with TasingRecordMixin<TastingRecordThirdStepPage>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {
    // TODO: implement buildBody
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child:  Container()
      ),
    );
  }

  @override
  // TODO: implement currentPageIndex
  int get currentPageIndex => 2;

  @override
  // TODO: implement isSatisfyRequirements
  bool get isSatisfyRequirements => true;

  @override
  // TODO: implement isSkippablePage
  bool get isSkippablePage => false;

  @override
  // TODO: implement onNext
  void Function() get onNext => (){};

  @override
  // TODO: implement onSkip
  void Function() get onSkip => (){};
}

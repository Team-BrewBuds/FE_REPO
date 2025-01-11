import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:flutter/material.dart';

import 'core/tasing_record_mixin.dart';

class TastingRecordSecStepPage extends StatefulWidget {
  const TastingRecordSecStepPage({super.key});

  @override
  State<TastingRecordSecStepPage> createState() => _TastingRecordSecStepPageState();
}

class _TastingRecordSecStepPageState extends State<TastingRecordSecStepPage> with TasingRecordMixin<TastingRecordSecStepPage>{

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
  int get currentPageIndex =>  1;

  @override
  // TODO: implement isSatisfyRequirements
  bool get isSatisfyRequirements => true;

  @override
  // TODO: implement isSkippablePage
  bool get isSkippablePage =>  false;

  @override
  // TODO: implement onNext
  void Function() get onNext => (){};

  @override
  // TODO: implement onSkip
  void Function() get onSkip => (){};
}

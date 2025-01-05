import 'package:brew_buds/coffeeNote/coffee_note_presenter.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:flutter/material.dart';

import '../../common/color_styles.dart';
import '../../common/drag_bar.dart';
import '../../common/text_styles.dart';

class WdgtBottomSheet extends StatefulWidget {
  final String title;
  final CoffeeNotePresenter presenter;

  const WdgtBottomSheet(
      {super.key, required this.title, required this.presenter});

  @override
  State<WdgtBottomSheet> createState() => _WdgtBottomSheetState();
}

class _WdgtBottomSheetState extends State<WdgtBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const DraggableIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyles.title02SemiBold,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: ColorStyles.gray20,
              ),
              ListView.builder(
                shrinkWrap: true, // ListView 높이를 제한
                physics: const NeverScrollableScrollPhysics(),
                itemCount: PostSubject.values.length - 1,
                itemBuilder: (context, index) {
                  final subject = PostSubject.values[index + 1];
                  return ListTile(
                    title: Text(
                      subject.toString(),
                      style: TextStyles.labelMediumMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, subject);
                      setState(() {
                        widget.presenter.setTitle(subject.toString());
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

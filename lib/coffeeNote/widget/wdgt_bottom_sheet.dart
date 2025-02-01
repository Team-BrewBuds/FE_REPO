import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/provider/post_presenter.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:flutter/material.dart';
import '../../common/drag_bar.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';

class WdgtBottomSheet extends StatefulWidget {
  final String title;
  final PostPresenter presenter;

  const WdgtBottomSheet({
    super.key,
    required this.title,
    required this.presenter,
  });

  @override
  State<WdgtBottomSheet> createState() => _WdgtBottomSheetState();
}

class _WdgtBottomSheetState extends State<WdgtBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDraggableIndicator(),
        _buildTitle(),
        const Divider(
          thickness: 1.0,
          color: ColorStyles.gray20,
        ),
        _buildSubjectList(),
      ],
    );
  }

  // 드래그 표시 인디케이터
  Widget _buildDraggableIndicator() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: const DraggableIndicator());
  }

  // BottomSheet 제목
  Widget _buildTitle() {
    return Padding(
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
    );
  }

  // PostSubject 리스트를 보여주는 위젯
  Widget _buildSubjectList() {
    return ListView.builder(
      shrinkWrap: true, // ListView 높이를 제한
      physics: const NeverScrollableScrollPhysics(),
      itemCount: PostSubject.values.length - 1,
      itemBuilder: (context, index) {
        final subject = PostSubject.values[index + 1];
        return _buildSubjectTile(subject);
      },
    );
  }

  // ListTile 항목을 빌드하는 메서드
  Widget _buildSubjectTile(PostSubject subject) {
    return ListTile(
      title: Text(
        subject.toString(),
        style: TextStyles.labelMediumMedium,
      ),
      onTap: () {
        widget.presenter.selectTopic(subject.toString());
        Navigator.pop(context, subject);
      },
    );
  }
}

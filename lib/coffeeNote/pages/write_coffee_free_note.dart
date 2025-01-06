import 'package:brew_buds/coffeeNote/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/controller/custom_controller.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:provider/provider.dart';

import '../../common/button_factory.dart';
import '../../common/color_styles.dart';
import '../../common/icon_button_factory.dart';
import '../../common/text_styles.dart';
import '../../common/widget/wdgt_valid_question.dart';
import '../widget/wdgt_bottom_sheet.dart';

class WriteCoffeeFreeNote extends StatefulWidget {
  const WriteCoffeeFreeNote({super.key});

  @override
  State<WriteCoffeeFreeNote> createState() => _WriteCoffeeFreeNoteState();
}

class _WriteCoffeeFreeNoteState extends State<WriteCoffeeFreeNote> {
  late CustomTagController customTagController;
  CoffeeNotePresenter presenter = CoffeeNotePresenter();

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customTagController = CustomTagController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    customTagController.dispose();
  }


  Future<bool> _onWillPop() async {
    bool? shouldPop = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WdgtValidQuestion(
          title: '게시물 등록을 그만두시겠습니까?',
          content: '지금까지 쓴 내용은 저장되지 않아요.',
        );
      },
    );
    return shouldPop ?? false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('글쓰기', style: TextStyles.title02SemiBold),
            actions: [
              TextButton(
                onPressed: () {},
                child: Container(
                  width: 55,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ColorStyles.gray20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '등록',
                      style: TextStyle(color: ColorStyles.gray40),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Consumer<CoffeeNotePresenter>(
            builder: (BuildContext context, CoffeeNotePresenter presenter,
                Widget? child) {
              return Container(
                  //
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 1.0,
                        color: ColorStyles.gray20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => WdgtBottomSheet(
                                      title: '게시물 주제',
                                      presenter: presenter,
                                    ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                presenter.title,
                                style: TextStyles.labelMediumMedium,
                              ),
                              SvgPicture.asset(
                                "assets/icons/down.svg",
                                color: ColorStyles.black,
                                width: 24.0,
                                height: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 1.0,
                        color: ColorStyles.gray20,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: presenter.titleController,
                          cursorColor: ColorStyles.black,
                          decoration: InputDecoration(
                            hintText: '제목을 입력하세요.',
                            hintStyle: TextStyles.title02SemiBold
                                .copyWith(color: ColorStyles.gray50),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorStyles.gray20)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorStyles.gray20), // 포커스 상태 밑줄 색상
                            ),
                          ),
                        ),
                      ),
                      // 내용 입력 필드를 Expanded로 감싸서 최대 공간 차지하도록 함
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFormField(
                            controller: presenter.customTagController,
                            cursorColor: ColorStyles.black,
                            decoration: InputDecoration(
                              hintText: '내용을 입력하세요.',
                              hintStyle: TextStyles.bodyRegular
                                  .copyWith(color: ColorStyles.gray50),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorStyles.gray20)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorStyles.gray20), // 포커스 상태 밑줄 색상
                              ),
                            ),
                            maxLines: null,
                            expands: true,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 46, top: 24, left: 16, right: 16),
                        child: Row(
                          children: [
                            IconButtonFactory.buildVerticalButtonWithIconWidget(
                                iconWidget: SvgPicture.asset(
                                  'assets/icons/album.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                text: '사진',
                                onTapped: () {},
                                textStyle: TextStyles.captionSmallMedium),
                            SizedBox(
                              width: 10,
                            ),
                            IconButtonFactory.buildVerticalButtonWithIconWidget(
                                iconWidget: SvgPicture.asset(
                                  'assets/icons/coffee.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                text: '기록',
                                onTapped: () {},
                                textStyle: TextStyles.captionSmallMedium),
                            SizedBox(
                              width: 10,
                            ),
                            IconButtonFactory.buildVerticalButtonWithIconWidget(
                                iconWidget: SvgPicture.asset(
                                  'assets/icons/tag.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                text: '태그',
                                onTapped: () {},
                                textStyle: TextStyles.captionSmallMedium),
                          ],
                        ),
                      )
                    ],
                  ));
            },
          )),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/profile/image_edit/profile_image_navigator.dart';
import 'package:brew_buds/domain/profile/presenter/coffee_life_bottom_sheet_presenter.dart';
import 'package:brew_buds/domain/profile/presenter/edit_profile_presenter.dart';
import 'package:brew_buds/domain/profile/widgets/coffee_life_bottom_sheet.dart';
import 'package:brew_buds/exception/profile_edit_exception.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  final String nickname;
  final String introduction;
  final String link;

  const EditProfileView({
    super.key,
    required this.nickname,
    required this.introduction,
    required this.link,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _nicknameEditingController;
  late final TextEditingController _introductionEditingController;
  late final TextEditingController _linkEditingController;
  late final FocusNode _linkFocusNode;
  late final FocusNode _nicknameFocusNode;
  late final FocusNode _introductionFocusNode;

  @override
  void initState() {
    _nicknameEditingController = TextEditingController(text: widget.nickname);
    _introductionEditingController = TextEditingController(text: widget.introduction);
    _linkEditingController = TextEditingController(text: widget.link);

    _nicknameFocusNode = FocusNode();
    _introductionFocusNode = FocusNode();
    _linkFocusNode = FocusNode();
    _linkFocusNode.addListener(() {
      _handleFocusChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    _nicknameEditingController.dispose();
    _introductionEditingController.dispose();
    _linkEditingController.dispose();
    _nicknameFocusNode.dispose();
    _introductionFocusNode.dispose();
    _linkFocusNode.removeListener(() {
      _handleFocusChange();
    });
    _linkFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_linkFocusNode.hasFocus) {
      if (_linkEditingController.text.isEmpty) {
        _linkEditingController.value = const TextEditingValue(
          text: 'https://',
          selection: TextSelection.collapsed(offset: 'https://'.length),
        );
      }
    } else {
      if (_linkEditingController.text == 'https://') {
        _clearLink();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Selector<EditProfilePresenter, String>(
                    selector: (context, presenter) => presenter.imageUrl,
                    builder: (context, imageUrl, child) => _buildProfileImage(imageUrl: imageUrl),
                  ),
                  const SizedBox(height: 16),
                  _buildNickname(),
                  const SizedBox(height: 24),
                  _buildIntroduction(),
                  const SizedBox(height: 24),
                  _buildLink(),
                  Selector<EditProfilePresenter, List<CoffeeLife>>(
                    selector: (context, presenter) => presenter.selectedCoffeeLifeList,
                    builder: (context, selectedCoffeeLifeList, child) => _buildCoffeeLife(
                      coffeeLifeList: selectedCoffeeLifeList,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Center(
                child: ThrottleButton(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/back.svg',
                    fit: BoxFit.cover,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
            Center(child: Text('프로필 편집', style: TextStyles.title02Bold)),
            Positioned(
              right: 0,
              child: Center(
                child: Selector<EditProfilePresenter, bool>(
                    selector: (context, presenter) => presenter.canEdit,
                    builder: (context, canEdit, _) {
                      return FutureButton<bool, ProfileEditException>(
                        onTap: () => context.read<EditProfilePresenter>().onSave(),
                        onError: (exception) {
                          EventBus.instance.fire(
                            MessageEvent(
                              context: context,
                              message: exception?.toString() ?? '알 수 없는 오류가 발생했어요.',
                            ),
                          );
                        },
                        onComplete: (result) {
                          if (result) {
                            EventBus.instance.fire(MessageEvent(context: context, message: '프로필을 수정했어요.'));
                            context.pop();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            '저장',
                            style: TextStyles.title02SemiBold.copyWith(
                              color: canEdit ? ColorStyles.red : ColorStyles.gray30,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage({required String imageUrl}) {
    return OpenContainer(
      openElevation: 0,
      openColor: Colors.transparent,
      closedElevation: 0,
      closedColor: Colors.transparent,
      openBuilder: (context, _) => ProfileImageNavigator.buildWithPresenter(imageUrl: imageUrl),
      closedBuilder: (context, _) => SizedBox(
        width: 98,
        height: 98,
        child: Stack(
          children: [
            Positioned.fill(
              child: MyNetworkImage(
                imageUrl: imageUrl,
                height: 98,
                width: 98,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: const Color(0xff888888)),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 28,
                width: 28,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xffd9d9d9),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: const Color(0xff888888)),
                ),
                child: const FittedBox(
                  fit: BoxFit.cover,
                  child: Icon(Icons.camera_alt_rounded, color: ColorStyles.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNickname() {
    return Selector<EditProfilePresenter, NicknameState>(
        selector: (context, presenter) => presenter.nicknameState,
        builder: (context, state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('닉네임', style: TextStyles.title01SemiBold),
              const SizedBox(height: 8),
              TextFormField(
                focusNode: _nicknameFocusNode,
                controller: _nicknameEditingController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  NicknameFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: '2 ~ 12자 이내',
                  hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ColorStyles.gray20,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: state.isEditing
                          ? state.isValid && !state.isDuplicating
                              ? ColorStyles.gray50
                              : ColorStyles.red
                          : ColorStyles.gray50,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.zero,
                    gapPadding: 0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: state.isEditing
                          ? state.isValid && !state.isDuplicating
                              ? ColorStyles.gray50
                              : ColorStyles.red
                          : ColorStyles.gray50,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.zero,
                    gapPadding: 0,
                  ),
                  suffixIcon: state.isChecking
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          width: 40,
                          height: 40,
                          child: const Center(child: CupertinoActivityIndicator(color: ColorStyles.black)),
                        )
                      : const SizedBox.shrink(),
                  suffixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
                ),
                style: TextStyles.labelSmallMedium,
                cursorColor: ColorStyles.black,
                cursorErrorColor: ColorStyles.black,
                cursorHeight: 16,
                cursorWidth: 1,
                maxLines: 1,
                onChanged: (newNickName) {
                  context.read<EditProfilePresenter>().onChangeNickname(newNickName);
                },
              ),
              if (state.isEditing && !state.isValid) ...[
                const SizedBox(height: 8),
                Text(
                  '2자 이상 입력해 주세요.',
                  style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
                ),
              ] else if (state.isEditing && state.isDuplicating) ...[
                const SizedBox(height: 8),
                Text(
                  '이미 사용 중인 닉네임이에요.',
                  style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  '닉네임은 14일 동안 최대 2번까지 변경할 수 있어요.',
                  style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
                ),
              ],
            ],
          );
        });
  }

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('소개', style: TextStyles.title01SemiBold),
            const Spacer(),
            Selector<EditProfilePresenter, int>(
              selector: (context, presenter) => presenter.introductionCount,
              builder: (context, introductionCount, child) => _buildCounter(count: introductionCount),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: TextFormField(
            focusNode: _introductionFocusNode,
            controller: _introductionEditingController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            expands: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(150),
            ],
            decoration: InputDecoration(
              hintText: '버디님을 자유롭게 소개해 주세요.',
              hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50, height: 1.35),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.gray50, width: 1),
                borderRadius: BorderRadius.zero,
                gapPadding: 0,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.gray50, width: 1),
                borderRadius: BorderRadius.zero,
                gapPadding: 0,
              ),
            ),
            style: TextStyles.labelSmallMedium,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: ColorStyles.black,
            cursorErrorColor: ColorStyles.black,
            cursorHeight: 16,
            cursorWidth: 1,
            onChanged: (newIntroduction) {
              context.read<EditProfilePresenter>().onChangeIntroduction(newIntroduction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCounter({required int count}) {
    return Text('$count / 150', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50));
  }

  Widget _buildLink() {
    return Selector<EditProfilePresenter, LinkState>(
      selector: (context, presenter) => presenter.linkState,
      builder: (context, linkState, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('링크', style: TextStyles.title01SemiBold),
            const SizedBox(height: 8),
            TextFormField(
              focusNode: _linkFocusNode,
              controller: _linkEditingController,
              keyboardType: TextInputType.url,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9:/?&=._\-#%]')),
              ],
              decoration: InputDecoration(
                hintText: 'URL을 입력해 주세요.',
                hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                contentPadding: const EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: linkState.isValid ? ColorStyles.gray50 : ColorStyles.red,
                      width: 1),
                  borderRadius: BorderRadius.zero,
                  gapPadding: 0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: linkState.isValid ? ColorStyles.gray50 : ColorStyles.red,
                      width: 1),
                  borderRadius: BorderRadius.zero,
                  gapPadding: 0,
                ),
                suffixIcon: linkState.hasLink
                    ? ThrottleButton(
                        onTap: () {
                          _clearLink();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
                        ),
                      )
                    : const SizedBox.shrink(),
                suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 48),
              ),
              style: TextStyles.labelSmallMedium,
              cursorColor: ColorStyles.black,
              cursorErrorColor: ColorStyles.black,
              cursorHeight: 16,
              cursorWidth: 1,
              maxLines: 1,
              onChanged: (newLink) {
                context.read<EditProfilePresenter>().onChangeLink(newLink);
              },
            ),
            if (!linkState.isValid) ...[
              const SizedBox(height: 4),
              Text(
                '주소가 유효하지 않습니다.',
                style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCoffeeLife({required List<CoffeeLife> coffeeLifeList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('커피 생활', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorStyles.gray50, width: 1),
                ),
                child: _buildCoffeeLifeList(coffeeLifeList: coffeeLifeList),
              ),
            ),
            const SizedBox(width: 8),
            ThrottleButton(
              onTap: () {
                _showCoffeeLifeBottomSheet(coffeeLifeList: coffeeLifeList);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorStyles.gray30,
                ),
                child: Text('정보 설정', style: TextStyles.labelMediumMedium),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '커피 생활은 최대 6개까지 설정할 수 있어요.',
          style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
        ),
      ],
    );
  }

  Widget _buildCoffeeLifeList({required List<CoffeeLife> coffeeLifeList}) {
    return coffeeLifeList.isEmpty
        ? Text(
            '버디님의 커피 생활을 소개해 보세요.',
            style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
          )
        : Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 4,
                    children: coffeeLifeList
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            decoration: BoxDecoration(
                              color: ColorStyles.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              e.title,
                              style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ThrottleButton(
                onTap: () {
                  context.read<EditProfilePresenter>().onChangeSelectedCoffeeLife([]);
                },
                child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
              ),
            ],
          );
  }

  _showCoffeeLifeBottomSheet({required List<CoffeeLife> coffeeLifeList}) async {
    final context = this.context;
    final result = await showBarrierDialog<List<CoffeeLife>>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChangeNotifierProvider<CoffeeLifeBottomSheetPresenter>(
          create: (context) => CoffeeLifeBottomSheetPresenter(selectedCoffeeLifeList: coffeeLifeList),
          child: const CoffeeLifeBottomSheet(),
        );
      },
    );

    if (result != null && context.mounted) {
      context.read<EditProfilePresenter>().onChangeSelectedCoffeeLife(result);
    }
  }

  _clearLink() {
    _linkEditingController.value = TextEditingValue.empty;
    context.read<EditProfilePresenter>().onChangeLink('');
  }
}

class NicknameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    int cursorPosition = newValue.selection.baseOffset;

    text = text.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');

    // 6️⃣ 커서 위치 보정
    int diff = text.length - newValue.text.length;
    int newCursorPosition = (cursorPosition + diff).clamp(0, text.length);

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

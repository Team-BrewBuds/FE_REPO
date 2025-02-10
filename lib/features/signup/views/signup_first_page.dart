import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/features/signup/core/signup_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpFirstPage extends StatefulWidget {
  const SignUpFirstPage({super.key});

  @override
  State<SignUpFirstPage> createState() => _SignUpFirstPageState();
}

class _SignUpFirstPageState extends State<SignUpFirstPage> with SignupMixin<SignUpFirstPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final FocusNode _nickNameFocusNode = FocusNode();
  final FocusNode _yearOfAgeFocusNode = FocusNode();

  @override
  int get currentPageIndex => 0;

@override
bool get isSatisfyRequirements =>
    context.read<SignUpPresenter>().isValidNicknameLength &&
    !context.read<SignUpPresenter>().isDuplicateNickname &&
    _ageController.text.length == 4 &&
    context.read<SignUpPresenter>().isValidYearOfBirth &&
    context.read<SignUpPresenter>().currentGender != null;


  @override
  bool get isSkippablePage => false;

  @override
  void Function() get onNext => () {
        context.push('/signup/second');
      };

  @override
  void Function() get onSkip => () {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpPresenter>().init();
      _nicknameController.addListener(() {
        context.read<SignUpPresenter>().onChangeNickName(_nicknameController.text);
      });
      _ageController.addListener(() {
        context.read<SignUpPresenter>().onChangeYearOfBirth(_ageController.text);
      });
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _nicknameController.dispose();
    _nickNameFocusNode.dispose();
    _yearOfAgeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context, SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('버디님에 대해 알려주세요', style: TextStyles.title04SemiBold),
        const SizedBox(height: 48),
        const Text('닉네임', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _nickNameFocusNode,
          controller: _nicknameController,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
          ],
          decoration: InputDecoration(
            hintText: '2 ~ 12자 이내',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _nicknameController.text.isEmpty ||
                        (!presenter.isDuplicateNickname && presenter.isValidNicknameLength)
                    ? ColorStyles.gray50
                    : ColorStyles.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _nicknameController.text.isEmpty ||
                        (!presenter.isDuplicateNickname && presenter.isValidNicknameLength)
                    ? ColorStyles.black
                    : ColorStyles.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
            contentPadding: const EdgeInsets.all(12),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: _buildNickNameSuffixIcon(presenter),
            ),
            suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 48),
            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
          ),
          style: TextStyles.labelSmallMedium,
          cursorColor: ColorStyles.black,
          cursorErrorColor: ColorStyles.black,
          cursorHeight: 16,
          cursorWidth: 1,
          maxLines: 1,
        ),
        if (_nicknameController.text.isEmpty ||
            (!presenter.isDuplicateNickname && presenter.isValidNicknameLength)) ...[
          const SizedBox(height: 36),
        ] else ...[
          const SizedBox(height: 4),
          Text(
            _nicknameController.text.length < 2 ? '2자 이상 입력해 주세요.' : '이미 사용 중인 닉네임이에요.',
            style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
          ),
          const SizedBox(height: 17),
        ],
        const Text('태어난 연도', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _yearOfAgeFocusNode,
          controller: _ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: '4자리 숫자를 입력해주세요',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _ageController.text.length == 4 && !presenter.isValidYearOfBirth
                    ? ColorStyles.red
                    : ColorStyles.gray50,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    _ageController.text.isEmpty || presenter.isValidYearOfBirth ? ColorStyles.black : ColorStyles.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
            contentPadding: const EdgeInsets.all(12),
            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: _buildYearOfAgeSuffixIcon(presenter),
            ),
            suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 48),
          ),
          style: TextStyles.labelSmallMedium,
          cursorColor: ColorStyles.black,
          cursorErrorColor: ColorStyles.black,
          cursorHeight: 16,
          cursorWidth: 1,
        ),
        const SizedBox(height: 8),
        Text(
          _ageController.text.length == 4 && !presenter.isValidYearOfBirth
              ? '만 14세 미만은 가입할 수 없어요.'
              : '버디님과 비슷한 연령대가 선호하는 원두를 추천해드려요.',
          style: TextStyles.captionSmallMedium.copyWith(
            color: _ageController.text.length == 4 && !presenter.isValidYearOfBirth
                ? ColorStyles.red
                : ColorStyles.gray50,
          ),
        ),
        const SizedBox(height: 36),
        const Text('성별', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        Row(
          children: Gender.values
              .map(
                (gender) => Expanded(
                  child: InkWell(
                    onTap: () {
                      presenter.onChangeGender(gender);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: presenter.currentGender == gender ? ColorStyles.background : ColorStyles.white,
                        border: Border.all(
                          color: presenter.currentGender == gender ? ColorStyles.red : ColorStyles.gray50,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          gender.toString(),
                          style: TextStyles.labelMediumMedium.copyWith(
                            color: presenter.currentGender == gender ? ColorStyles.red : ColorStyles.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .separator(separatorWidget: const SizedBox(width: 8))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNickNameSuffixIcon(SignUpPresenter presenter) {
    if (_nicknameController.text.isEmpty) {
      return SizedBox.shrink();
    } else if (!presenter.isDuplicateNickname && presenter.isValidNicknameLength) {
      return SvgPicture.asset(
        'assets/icons/check_fill.svg',
        height: 24,
        width: 24,
      );
    } else {
      return InkWell(
        onTap: () {
          _nicknameController.clear();
        },
        child: SvgPicture.asset(
          'assets/icons/x_round.svg',
          height: 24,
          width: 24,
        ),
      );
    }
  }

  Widget? _buildYearOfAgeSuffixIcon(SignUpPresenter presenter) {
    if (_ageController.text.isEmpty) {
      return SizedBox.shrink();
    } else if (_ageController.text.length < 4 || !presenter.isValidYearOfBirth) {
      return InkWell(
        onTap: () {
          _ageController.clear();
        },
        child: SvgPicture.asset(
          'assets/icons/x_round.svg',
          height: 24,
          width: 24,
        ),
      );
    } else {
      return SvgPicture.asset(
        'assets/icons/check_fill.svg',
        height: 24,
        width: 24,
      );
    }
  }

  @override
  onTappedOutSide() {
    if (_nickNameFocusNode.hasFocus) {
      _nickNameFocusNode.unfocus();
    }

    if (_yearOfAgeFocusNode.hasFocus) {
      _yearOfAgeFocusNode.unfocus();
    }
  }
}

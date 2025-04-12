import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/signup/sign_up_presenter.dart';
import 'package:brew_buds/model/common/gender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignUpFirstPage extends StatefulWidget {
  @override
  State<SignUpFirstPage> createState() => _SignUpFirstPageState();

  const SignUpFirstPage({super.key});
}

class _SignUpFirstPageState extends State<SignUpFirstPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final FocusNode _nickNameFocusNode = FocusNode();
  final FocusNode _yearOfAgeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    _nicknameController.removeListener(() {
      context.read<SignUpPresenter>().onChangeNickName(_nicknameController.text);
    });
    _ageController.removeListener(() {
      context.read<SignUpPresenter>().onChangeYearOfBirth(_ageController.text);
    });
    _ageController.dispose();
    _nicknameController.dispose();
    _nickNameFocusNode.dispose();
    _yearOfAgeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('버디님에 대해 알려주세요', style: TextStyles.title04SemiBold),
        const SizedBox(height: 48),
        _buildNicknameTextFormField(),
        _buildYearOfAgeTextFormField(),
        Selector<SignUpPresenter, Gender?>(
          selector: (context, presenter) => presenter.currentGender,
          builder: (context, currentGender, child) => _buildGenderSelector(selectedGender: currentGender),
        ),
      ],
    );
  }

  Widget _buildNicknameTextFormField() {
    return Selector<SignUpPresenter, NicknameValidState>(
      selector: (context, presenter) => presenter.nicknameValidState,
      builder: (context, nicknameValidState, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('닉네임', style: TextStyles.title01SemiBold),
            const SizedBox(height: 8),
            TextFormField(
              focusNode: _nickNameFocusNode,
              controller: _nicknameController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                NicknameFormatter(),
              ],
              decoration: InputDecoration(
                hintText: '2 ~ 12자 이내',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: nicknameValidState.isChangeNickname
                        ? (nicknameValidState.isValidNickname && !nicknameValidState.isDuplicatingNickname)
                            ? ColorStyles.gray50
                            : ColorStyles.red
                        : ColorStyles.gray50,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: nicknameValidState.isChangeNickname
                        ? (nicknameValidState.isValidNickname && !nicknameValidState.isDuplicatingNickname)
                            ? ColorStyles.gray50
                            : ColorStyles.red
                        : ColorStyles.gray50,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                contentPadding: const EdgeInsets.all(12),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildNickNameSuffixIcon(
                    hasNickname: nicknameValidState.hasNickname,
                    isValidNickname: nicknameValidState.isValidNickname && !nicknameValidState.isDuplicatingNickname,
                    isCheckingDuplicateNicknames: nicknameValidState.isNicknameChecking,
                  ),
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
            if (nicknameValidState.hasNickname && !nicknameValidState.isValidNickname) ...[
              const SizedBox(height: 4),
              Text(
                '2자 이상 입력해 주세요.',
                style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
              ),
              const SizedBox(height: 17),
            ] else if (nicknameValidState.hasNickname && nicknameValidState.isDuplicatingNickname) ...[
              const SizedBox(height: 4),
              Text(
                '이미 사용 중인 닉네임이에요.',
                style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
              ),
              const SizedBox(height: 17),
            ] else ...[
              const SizedBox(height: 36),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNickNameSuffixIcon({
    required bool hasNickname,
    required bool isValidNickname,
    required bool isCheckingDuplicateNicknames,
  }) {
    if (isCheckingDuplicateNicknames) {
      return const SizedBox(height: 24, width: 24, child: CupertinoActivityIndicator(color: ColorStyles.gray70));
    } else if (hasNickname && isValidNickname) {
      return SvgPicture.asset('assets/icons/check_fill.svg', height: 24, width: 24);
    } else if (hasNickname && !isValidNickname) {
      return ThrottleButton(
        onTap: () {
          _clearNickname();
        },
        child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _clearNickname() {
    _nicknameController.value = TextEditingValue.empty;
  }

  Widget _buildYearOfAgeTextFormField() {
    return Selector<SignUpPresenter, YearOfBirthValidState>(
      selector: (context, presenter) => presenter.yearOfBirthValidState,
      builder: (context, yearOfBirthValidState, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('태어난 연도', style: TextStyles.title01SemiBold),
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
                    color: yearOfBirthValidState.yearOfBirthLength == 0
                        ? ColorStyles.gray50
                        : yearOfBirthValidState.yearOfBirthLength == 4 && yearOfBirthValidState.isValidYearOfBirth
                            ? ColorStyles.gray50
                            : ColorStyles.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: yearOfBirthValidState.yearOfBirthLength == 0
                        ? ColorStyles.black
                        : yearOfBirthValidState.yearOfBirthLength == 4 && yearOfBirthValidState.isValidYearOfBirth
                            ? ColorStyles.black
                            : ColorStyles.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                contentPadding: const EdgeInsets.all(12),
                hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: _buildYearOfAgeSuffixIcon(
                    isValidYearOfBirth: yearOfBirthValidState.isValidYearOfBirth,
                    yearOfBirthLength: yearOfBirthValidState.yearOfBirthLength,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 48),
              ),
              style: TextStyles.labelSmallMedium,
              cursorColor: ColorStyles.black,
              cursorErrorColor: ColorStyles.black,
              cursorHeight: 16,
              cursorWidth: 1,
            ),
            if (yearOfBirthValidState.yearOfBirthLength > 0 && yearOfBirthValidState.yearOfBirthLength < 4) ...[
              const SizedBox(height: 8),
              Text('4자리 숫자를 입력해주세요.', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red)),
              const SizedBox(height: 36),
            ] else if (yearOfBirthValidState.yearOfBirthLength == 4 && !yearOfBirthValidState.isValidYearOfBirth) ...[
              const SizedBox(height: 8),
              Text('만 14세 미만은 가입할 수 없어요.', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red)),
              const SizedBox(height: 36),
            ] else ...[
              const SizedBox(height: 59),
            ],
          ],
        );
      },
    );
  }

  Widget? _buildYearOfAgeSuffixIcon({required int yearOfBirthLength, required bool isValidYearOfBirth}) {
    if (yearOfBirthLength == 0) {
      return const SizedBox.shrink();
    } else if (yearOfBirthLength == 4 && isValidYearOfBirth) {
      return SvgPicture.asset('assets/icons/check_fill.svg', height: 24, width: 24);
    } else {
      return ThrottleButton(
        onTap: () {
          _clearYearOfAge();
        },
        child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
      );
    }
  }

  _clearYearOfAge() {
    _ageController.value = TextEditingValue.empty;
  }

  Widget _buildGenderSelector({Gender? selectedGender}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('성별', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        Row(
          spacing: 8,
          children: Gender.values
              .map(
                (gender) => Expanded(
                  child: ThrottleButton(
                    onTap: () {
                      context.read<SignUpPresenter>().onChangeGender(gender);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedGender == gender ? ColorStyles.background : ColorStyles.white,
                        border: Border.all(
                          color: selectedGender == gender ? ColorStyles.red : ColorStyles.gray50,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          gender.toString(),
                          style: TextStyles.labelMediumMedium.copyWith(
                            color: selectedGender == gender ? ColorStyles.red : ColorStyles.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
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

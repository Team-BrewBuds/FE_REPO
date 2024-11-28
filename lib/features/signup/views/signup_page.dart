import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/features/signup/views/signup_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SignupMixin<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final FocusNode _nickNameFocusNode = FocusNode();
  final FocusNode _yearOfAgeFocusNode = FocusNode();

  @override
  int get currentPageIndex => 0;

  @override
  bool get isSatisfyRequirements =>
      (_formKey.currentState?.validate() ?? false) && context.read<SignUpPresenter>().currentGender != null;

  @override
  bool get isSkippablePage => false;

  @override
  void Function() get onNext => () {
        context.push('/signup/enjoy');
      };

  @override
  void Function() get onSkip => () {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpPresenter>().init();

      _nickNameFocusNode.addListener(() {
        if (!_nickNameFocusNode.hasFocus) {
          context.read<SignUpPresenter>().checkNickName();
        }
      });

      _yearOfAgeFocusNode.addListener(() {
        if (!_yearOfAgeFocusNode.hasFocus) {
          context.read<SignUpPresenter>().checkYearOfBirth();
        }
      });
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _nicknameController.dispose();
    _nickNameFocusNode.dispose();
    _yearOfAgeFocusNode.dispose();
    _nickNameFocusNode.removeListener(() {
      if (!_nickNameFocusNode.hasFocus) {
        context.read<SignUpPresenter>().checkNickName();
      }
    });

    _yearOfAgeFocusNode.removeListener(() {
      if (!_yearOfAgeFocusNode.hasFocus) {
        context.read<SignUpPresenter>().checkYearOfBirth();
      }
    });
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context, SignUpPresenter presenter) {
    return Form(
      key: _formKey,
      child: Column(
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
            decoration: InputDecoration(
              hintText: '2 ~ 12자 이내',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.gray50, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.black, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.red, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.red, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefix: const SizedBox(width: 12),
              suffixIcon: _buildNickNameSuffixIcon(presenter),
              counterStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
              hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
              errorStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
            ),
            style: TextStyles.labelSmallMedium,
            onChanged: presenter.onChangeNickName,
            onEditingComplete: presenter.checkNickName,
            onTapOutside: (_) {
              _nickNameFocusNode.unfocus();
            },
            cursorColor: ColorStyles.black,
            cursorErrorColor: ColorStyles.black,
            validator: presenter.validatedNickname,
            autovalidateMode: AutovalidateMode.always,
            maxLines: 1,
            maxLength: 12,
          ),
          const SizedBox(height: 20),
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
              helperText: '버디님과 비슷한 연령대가 선호하는 원두를 추천해드려요',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.gray50, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.black, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.red, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorStyles.red, width: 1),
                borderRadius: BorderRadius.circular(1),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefix: const SizedBox(width: 12),
              suffixIcon: _buildYearOfAgeSuffixIcon(presenter),
              counterStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
              hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
              helperStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
              errorStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.red),
            ),
            style: TextStyles.labelSmallMedium,
            onChanged: presenter.onChangeYearOfBirth,
            onEditingComplete: presenter.checkYearOfBirth,
            onTapOutside: (_) {
              _yearOfAgeFocusNode.unfocus();
            },
            cursorColor: ColorStyles.black,
            cursorErrorColor: ColorStyles.black,
            validator: presenter.validatedYearOfBirth,
            autovalidateMode: AutovalidateMode.always,
          ),
          const SizedBox(height: 20),
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
      ),
    );
  }

  Widget? _buildNickNameSuffixIcon(SignUpPresenter presenter) {
    if (presenter.isNotEmptyNickName) {
      if (presenter.isValidNickName) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 24,
          width: 24,
          child: SvgPicture.asset('assets/icons/check_fill.svg'),
        );
      } else {
        return InkWell(
          onTap: () {
            _nicknameController.clear();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 24,
            width: 24,
            child: SvgPicture.asset('assets/icons/x_round.svg'),
          ),
        );
      }
    } else {
      return null;
    }
  }

  Widget? _buildYearOfAgeSuffixIcon(SignUpPresenter presenter) {
    if (presenter.isNotEmptyYearOfBirth) {
      if (presenter.isValidYearOfBirth) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 24,
          width: 24,
          child: SvgPicture.asset('assets/icons/check_fill.svg'),
        );
      } else {
        return InkWell(
          onTap: () {
            _ageController.clear();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 24,
            width: 24,
            child: SvgPicture.asset('assets/icons/x_round.svg'),
          ),
        );
      }
    } else {
      return null;
    }
  }
}

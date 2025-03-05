import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/photo/view/photo_grid_view_with_preview.dart';
import 'package:brew_buds/profile/presenter/coffee_life_bottom_sheet_presenter.dart';
import 'package:brew_buds/profile/presenter/edit_profile_presenter.dart';
import 'package:brew_buds/profile/widgets/coffee_life_bottom_sheet.dart';
import 'package:extended_image/extended_image.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unFocus();
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
                  Selector<EditProfilePresenter, ProfileImageState>(
                    selector: (context, presenter) => presenter.profileImageState,
                    builder: (context, state, child) => _buildProfileImage(
                      imageUri: state.imageUrl,
                      imageData: state.imageData,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNickname(),
                  const SizedBox(height: 24),
                  _buildIntroduction(),
                  const SizedBox(height: 24),
                  _buildLink(),
                  const SizedBox(height: 24),
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

  _unFocus() {
    if (_nicknameFocusNode.hasFocus) _nicknameFocusNode.unfocus();
    if (_introductionFocusNode.hasFocus) _introductionFocusNode.unfocus();
    if (_linkFocusNode.hasFocus) _linkFocusNode.unfocus();
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
                child: InkWell(
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
            const Center(child: Text('프로필 편집', style: TextStyles.title02Bold)),
            Positioned(
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () {
                    context.read<EditProfilePresenter>().onSave();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      '저장',
                      style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage({required String imageUri, Uint8List? imageData}) {
    return SizedBox(
      width: 98,
      height: 98,
      child: Stack(
        children: [
          Positioned.fill(
            child: imageData != null
                ? ExtendedImage.memory(
                    imageData,
                    fit: BoxFit.cover,
                    width: 98,
                    height: 98,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: const Color(0xff888888)),
                  )
                : MyNetworkImage(
                    imageUri: imageUri,
                    height: 98,
                    width: 98,
                    color: const Color(0xffd9d9d9),
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: const Color(0xff888888)),
                  ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                _showAlbumModal();
              },
              child: Container(
                height: 28.17,
                width: 28.17,
                decoration: BoxDecoration(
                  color: const Color(0xffd9d9d9),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: const Color(0xff888888)),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: ColorStyles.black, size: 19),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNickname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('닉네임', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _nicknameFocusNode,
          controller: _nicknameEditingController,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
          ],
          decoration: InputDecoration(
            hintText: '2 ~ 12자 이내',
            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: ColorStyles.gray20,
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
          cursorColor: ColorStyles.black,
          cursorErrorColor: ColorStyles.black,
          cursorHeight: 16,
          cursorWidth: 1,
          maxLines: 1,
          onChanged: (newNickName) {
            context.read<EditProfilePresenter>().onChangeNickname(newNickName);
          },
        ),
        const SizedBox(height: 8),
        Text(
          '닉네임은 14일 동안 최대 2번까지 변경할 수 있어요.',
          style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
        ),
      ],
    );
  }

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('소개', style: TextStyles.title01SemiBold),
            const Spacer(),
            Selector<EditProfilePresenter, int>(
              selector: (context, presenter) => presenter.introductionCount,
              builder: (context, introductionCount, child) => _buildCounter(count: introductionCount),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 175,
          child: TextFormField(
            focusNode: _introductionFocusNode,
            controller: _introductionEditingController,
            keyboardType: TextInputType.text,
            maxLines: null,
            expands: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(150),
            ],
            decoration: InputDecoration(
              hintText: '버디님을 자유롭게 소개해 주세요..',
              hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('링크', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _linkFocusNode,
          controller: _linkEditingController,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: 'URL을 입력해 주세요.',
            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
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
            suffixIcon: Selector<EditProfilePresenter, bool>(
              selector: (context, presenter) => presenter.hasLink,
              builder: (context, hasLink, child) => hasLink
                  ? GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
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
      ],
    );
  }

  Widget _buildCoffeeLife({required List<CoffeeLife> coffeeLifeList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('커피 생활', style: TextStyles.title01SemiBold),
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
            InkWell(
              onTap: () {
                _showCoffeeLifeBottomSheet(coffeeLifeList: coffeeLifeList);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorStyles.gray30,
                ),
                child: const Text('정보 설정', style: TextStyles.labelMediumMedium),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '간단한 정보 설정으로 내 커피 생활을 알릴 수 있어요.',
          style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
        ),
      ],
    );
  }

  Widget _buildCoffeeLifeList({required List<CoffeeLife> coffeeLifeList}) {
    return coffeeLifeList.isEmpty
        ? Text(
            '커피 생활을 어떻게 즐기는지 알려주세요.',
            style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
          )
        : Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                        .separator(separatorWidget: const SizedBox(width: 4))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  context.read<EditProfilePresenter>().onChangeSelectedCoffeeLife([]);
                },
                child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
              ),
            ],
          );
  }

  _showCoffeeLifeBottomSheet({required List<CoffeeLife> coffeeLifeList}) async {
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

  _showAlbumModal() {
    showCupertinoModalPopup(
      barrierColor: ColorStyles.white,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GridPhotoViewWithPreview.build(
          permissionStatus: PermissionRepository.instance.photos,
          previewShape: BoxShape.circle,
          canMultiSelect: false,
          onCancel: (context) {
            context.pop();
          },
          onDone: (context, images) {
            final imageData = images.firstOrNull;
            if (imageData != null) {
              _onChangeImageData(imageData);
            }
            context.pop();
          },
          onCancelCamera: (context) {
            context.pop();
          },
          onDoneCamera: (context, imageData) {
            if (imageData != null) {
              _onChangeImageData(imageData);
            }
            context.pop();
          },
        );
      },
    );
  }

  _onChangeImageData(Uint8List imageData) {
    context.read<EditProfilePresenter>().onChangeImageData(imageData);
  }
}

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  final String url;

  const WebScreen({
    super.key,
    required this.url,
  });

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  late final WebViewController controller;
  final ValueNotifier<bool> isProgressNotifier = ValueNotifier(false);
  final ValueNotifier<int> progressNotifier = ValueNotifier(0);
  final ValueNotifier<bool> canGoBackNotifier = ValueNotifier(false);
  final ValueNotifier<bool> canGoForwardNotifier = ValueNotifier(false);
  final ValueNotifier<String> titleNotifier = ValueNotifier('');
  final ValueNotifier<bool> isErrorNotifier = ValueNotifier(false);
  late final ValueNotifier<String> urlNotifier;

  @override
  void initState() {
    super.initState();
    urlNotifier = ValueNotifier(Uri.parse(widget.url).host);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            isProgressNotifier.value = true;
            progressNotifier.value = 0;
          },
          onPageFinished: (_) async {
            isProgressNotifier.value = false;
            canGoBackNotifier.value = await controller.canGoBack();
            canGoForwardNotifier.value = await controller.canGoForward();
            titleNotifier.value = await controller.getTitle() ?? 'Web';
          },
          onProgress: (progress) {
            progressNotifier.value = progress;
          },
          onUrlChange: (urlState) {
            final url = urlState.url;
            if (url != null) {
              urlNotifier.value = Uri.parse(url).host;
            }
          },
          onWebResourceError: (_) async {
            titleNotifier.value = 'Error Page';
            isProgressNotifier.value = false;
            canGoBackNotifier.value = await controller.canGoBack();
            canGoForwardNotifier.value = await controller.canGoForward();
            isErrorNotifier.value = true;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  void dispose() {
    isProgressNotifier.dispose();
    progressNotifier.dispose();
    canGoBackNotifier.dispose();
    canGoForwardNotifier.dispose();
    titleNotifier.dispose();
    isErrorNotifier.dispose();
    urlNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: const Color(0xffd9d9d9),
                child: ValueListenableBuilder(
                  valueListenable: isErrorNotifier,
                  builder: (context, isError, child) {
                    if (isError) {
                      return Center(
                        child: Text(
                          '이 웹사이트를 읽어들이는 중 문제가 발생했습니다',
                          style: TextStyles.title01SemiBold,
                        ),
                      );
                    } else {
                      return WebViewWidget(controller: controller);
                    }
                  },
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      centerTitle: false,
      titleSpacing: 0,
      toolbarHeight: 75,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: titleNotifier,
                  builder: (context, title, _) {
                    return Text(
                      title.length > 36 ? title.substring(0, 36) : title,
                      style: TextStyles.captionMediumSemiBold,
                    );
                  },
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.lock, size: 12, color: ColorStyles.gray70),
                    const SizedBox(width: 4),
                    ValueListenableBuilder(
                      valueListenable: urlNotifier,
                      builder: (context, url, _) {
                        return Text(
                          url,
                          style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray70),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(width: 24, height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ValueListenableBuilder(
      valueListenable: isProgressNotifier,
      builder: (context, isProgress, _) {
        if (isProgress) {
          return ValueListenableBuilder(
            valueListenable: progressNotifier,
            builder: (context, progress, _) {
              return Row(
                children: [
                  Expanded(flex: progress, child: Container(height: 2, color: ColorStyles.red)),
                  Expanded(flex: 100 - progress, child: Container(height: 2, color: const Color(0xffd9d9d9))),
                ],
              );
            },
          );
        } else {
          return Container(height: 2, color: ColorStyles.white);
        }
      },
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25, top: 15),
      child: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: canGoBackNotifier,
            builder: (context, canGoBack, _) {
              return AbsorbPointer(
                absorbing: !canGoBack,
                child: GestureDetector(
                  onTap: () {
                    controller.goBack();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/back.svg',
                    height: 36,
                    width: 36,
                    colorFilter: ColorFilter.mode(
                      canGoBack ? ColorStyles.black : ColorStyles.gray50,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 48),
          ValueListenableBuilder(
            valueListenable: canGoForwardNotifier,
            builder: (context, canGoForward, _) {
              return AbsorbPointer(
                absorbing: !canGoForward,
                child: GestureDetector(
                  onTap: () {
                    controller.goForward();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/arrow.svg',
                    height: 36,
                    width: 36,
                    colorFilter: ColorFilter.mode(
                      canGoForward ? ColorStyles.black : ColorStyles.gray50,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          GestureDetector(
              onTap: () {
                controller.reload();
              },
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: SvgPicture.asset('assets/icons/refresh_sharp.svg'),
              )),
        ],
      ),
    );
  }
}

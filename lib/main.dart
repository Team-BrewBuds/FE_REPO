import 'dart:async';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/dio_client.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/app_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/domain/notification/notification_presenter.dart';
import 'package:brew_buds/firebase_options.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:brew_buds/model/events/need_login_event.dart';
import 'package:brew_buds/model/events/need_update_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  DioClient.instance.initial();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values),
    initializeDateFormatting('ko'),
    SharedPreferencesRepository.instance.init(),
    FirebaseAnalytics.instance.logAppOpen(),
  ]);

  if (!SharedPreferencesRepository.instance.isCompletePermission) {
    await AccountRepository.instance.logout();
  } else {
    await PermissionRepository.instance.initPermission();
    await Future.wait([
      AccountRepository.instance.init(),
      NotificationRepository.instance.init(),
    ]);
    PhotoRepository.instance.initState();
  }

  await AppRepository.instance.checkUpdateRequired();

  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'],
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT'],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationPresenter>(create: (_) => NotificationPresenter()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late final GoRouter router;
  late final StreamSubscription needUpdateSub;
  late final StreamSubscription needLoginSub;
  late final StreamSubscription messageSub;
  bool _isAlertShow = false;

  @override
  void initState() {
    router = createRouter(AccountRepository.instance.accessToken.isNotEmpty, navigatorKey);
    WidgetsBinding.instance.addObserver(this);
    messageSub = EventBus.instance.on<MessageEvent>().listen(onMessageEvent);
    needUpdateSub = EventBus.instance.on<NeedUpdateEvent>().listen(onNeedUpdateEvent);
    needLoginSub = EventBus.instance.on<NeedLoginEvent>().listen((_) {
      if (!_isAlertShow) {
        _isAlertShow = true;
        _showLoginAlert();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppRepository.instance.checkUpdateRequired();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    messageSub.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      AppRepository.instance.checkUpdateRequired();
    }
  }

  void onMessageEvent(MessageEvent event) {
    showSnackBar(message: event.message);
  }

  void onNeedUpdateEvent(NeedUpdateEvent event) {
    _showForceUpdateDialog(event.id);
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp.router(
        routerConfig: router,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Brew Buds',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', ''),
        ],
        theme: ThemeData(
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: Colors.white,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorStyles.white,
            scrolledUnderElevation: 0,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Color(0xFFFFA388),
            cursorColor: Color(0xFFFFA388),
            selectionHandleColor: Color(0xFFFF4412),
          ),
          useMaterial3: true,
          cupertinoOverrideTheme: const CupertinoThemeData(
            primaryColor: Color(0xFFFF4412),
          ),
        ),
      ),
    );
  }

  showSnackBar({required String message}) {
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black90,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void _showForceUpdateDialog(String id) {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      showCupertinoDialog(
        context: currentContext,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('최신 버전의 앱이 있습니다', style: TextStyles.title02SemiBold),
            content: Text('최적의 사용 환경을 위해 최신 버전의\n앱으로 업데이해주세요.', style: TextStyles.bodyRegular),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  '업데이트',
                  style: TextStyles.captionMediumMedium.copyWith(color: CupertinoColors.activeBlue),
                ),
                onPressed: () async {
                  final uri = Uri.parse('https://apps.apple.com/kr/app/id$id');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  _showLoginAlert() async {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      await showCupertinoDialog(
        context: currentContext,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('토큰 만료', style: TextStyles.title02SemiBold),
            content: Text('로그인 페이지로 이동합니다.', style: TextStyles.bodyRegular),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text(
                  '닫기',
                  style: TextStyles.captionMediumMedium.copyWith(color: CupertinoColors.destructiveRed),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  '확인',
                  style: TextStyles.captionMediumMedium.copyWith(color: CupertinoColors.activeBlue),
                ),
                onPressed: () {
                  context.pop();
                },
              )
            ],
          );
        },
      );
      await NotificationRepository.instance.deleteToken();
      await AccountRepository.instance.logout();
      if (currentContext.mounted) {
        currentContext.go('/');
        _isAlertShow = false;
      }
    }
  }
}

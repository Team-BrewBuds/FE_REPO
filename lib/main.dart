import 'dart:async';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/dio_client.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/firebase_options.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

import 'data/repository/app_repository.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  await PermissionRepository.instance.initPermission();

  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  //
  // await initializeDateFormatting('ko');
  //
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DioClient.instance.initial();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values),
    initializeDateFormatting('ko'),
    AccountRepository.instance.init(),
    SharedPreferencesRepository.instance.init(),
    NotificationRepository.instance.init(),
    PhotoRepository.instance.initState(),
  ]);

  if (SharedPreferencesRepository.instance.isFirst) {
    await AccountRepository.instance.deleteAll();
  }

  await AppRepository.instance.checkUpdateRequired();

  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'],
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT'],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountRepository.instance),
      ],
      child: MyApp(
        router: createRouter(AccountRepository.instance.accessToken.isNotEmpty),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final StreamSubscription messageSub;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    messageSub = EventBus.instance.on<MessageEvent>().listen(onMessageEvent);
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
      await AppRepository.instance.checkUpdateRequired();
    }
  }

  void onMessageEvent(MessageEvent event) {
    showSnackBar(context: event.context, message: event.message);
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp.router(
        routerConfig: widget.router,
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

  showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

Future<void> checkInitialMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    AccountRepository.instance.notify();
  }
}

void setupFCMListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AccountRepository.instance.notify();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    AccountRepository.instance.notify();
  });
}

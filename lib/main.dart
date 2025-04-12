import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/core/dio_client.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  await initializeDateFormatting('ko');
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppRepository.instance.checkUpdateRequired();

  DioClient.instance.initial();
  await AccountRepository.instance.init();
  await SharedPreferencesRepository.instance.init();
  await PermissionRepository.instance.initPermission();
  await NotificationRepository.instance.init();

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
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await AppRepository.instance.checkUpdateRequired();
    }
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
          ),
          useMaterial3: true,
        ),
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AccountRepository.instance.notify();
}

void setupFCMListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AccountRepository.instance.notify();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    AccountRepository.instance.notify();
  });
}

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/signup/provider/sign_up_presenter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('ko');
  await dotenv.load(fileName: ".env");

  //카카오 앱키
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'],
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT'],
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await PermissionRepository.instance.initPermission();

  await AccountRepository.instance.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => LoginPresenter(
          accountRepository: AccountRepository.instance,
          loginRepository: LoginRepository.instance,
        ),
      ),
      ChangeNotifierProvider(create: (context) => SignUpPresenter()),
    ],
    child: MyApp(router: createRouter(AccountRepository.instance.accessToken.isNotEmpty),),
  ));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp.router(
      routerConfig: router,
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
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   // statusBarColor: ColorStyles.black,
          //   statusBarIconBrightness: Brightness.light,
          //   statusBarBrightness: Brightness.light,
          // ),
        ),
        useMaterial3: true,
      ),
    );
  }
}

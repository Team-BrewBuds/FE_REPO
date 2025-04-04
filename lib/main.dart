import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'features/signup/provider/sign_up_presenter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting('ko');
  await dotenv.load(fileName: ".env");

  //카카오 앱키
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'],
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT'],
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AccountRepository.instance),
      ChangeNotifierProvider(
        create: (context) => LoginPresenter(
          accountRepository: AccountRepository.instance,
          loginRepository: LoginRepository.instance,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => SignUpPresenter(
          accountRepository: AccountRepository.instance,
          loginRepository: LoginRepository.instance,
        ),
      ),
    ],
    child: const MyApp(),
  ));

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Brew Buds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        useMaterial3: true,
      ),
    );
  }
}

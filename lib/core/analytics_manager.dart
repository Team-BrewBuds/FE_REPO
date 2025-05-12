import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsManager {
  AnalyticsManager._();

  static final AnalyticsManager _instance = AnalyticsManager._();

  static AnalyticsManager get instance => _instance;

  factory AnalyticsManager() => instance;

  logButtonTap({required String buttonName}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
      },
    );
  }

  logScreen({required String screenName}) async {
    await FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }
}

import UIKit
import Flutter
import NidThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "com.brewbuds/naver_login"
    private var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        
        // ✅ 네이버 SDK 초기화
        NidOAuth.shared.initialize()
        NidOAuth.shared.setLoginBehavior(.appPreferredWithInAppBrowserFallback) // 3번 방식
        
        // ✅ 네이버 채널 핸들링
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            switch call.method {
            case "login":
                self.handleNaverLogin(result: result)
            case "logout":
                NidOAuth.shared.logout()
                result(true)
            case "unlink":
                NidOAuth.shared.disconnect { res in
                    switch res {
                    case .success:
                        NidOAuth.shared.logout()
                        result(true)
                    case .failure(let err):
                        result(FlutterError(code: "UNLINK_FAIL", message: err.localizedDescription, details: nil))
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // ✅ URL 스킴 처리 (카카오 + 네이버 함께)
    override func application(_ app: UIApplication,
                              open url: URL,
                              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 카카오 로그인
        if (url.absoluteString.hasPrefix("kakao")) {
            return super.application(app, open: url, options: options)
        }
        
        // 네이버 로그인
        if (NidOAuth.shared.handleURL(url) == true) { // 네이버앱에서 전달된 Url인 경우
            return true
        }
        
        return super.application(app, open: url, options: options)
    }
    
    // MARK: - Private
    
    private func handleNaverLogin(result: @escaping FlutterResult) {
        NidOAuth.shared.requestLogin { loginRes in
            switch loginRes {
            case .success(let login):
                let payload: [String: Any?] = [
                    "accessToken": login.accessToken.tokenString
                ]
                result(payload)
            case .failure(let error):
                result(FlutterError(code: "LOGIN_FAIL", message: error.localizedDescription, details: nil))
            }
        }
    }
}

import UIKit
import Flutter
import NaverThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let thirdConn = NaverThirdPartyLoginConnection.getSharedInstance()
        thirdConn?.isNaverAppOauthEnable = true
        thirdConn?.isInAppOauthEnable = true
        
        if let consumerKey = Bundle.main.object(forInfoDictionaryKey: "naverConsumerKey") as? String {
            thirdConn?.consumerKey = consumerKey
        }
        if let consumerSecret = Bundle.main.object(forInfoDictionaryKey: "naverConsumerSecret") as? String {
            thirdConn?.consumerSecret = consumerSecret
        }
        if let serviceAppName = Bundle.main.object(forInfoDictionaryKey: "naverServiceAppName") as? String {
            thirdConn?.appName = serviceAppName
        }
        if let serviceUrlScheme = Bundle.main.object(forInfoDictionaryKey: "naverServiceAppUrlScheme") as? String {
            thirdConn?.serviceUrlScheme = serviceUrlScheme
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var result = false
        print(url)
        if (url.absoluteString.hasPrefix("kakao")) {
            result = super.application(app, open: url, options: options)
        }
        
        if (!result) {
            var naverLoginUrl = url;
            if !url.absoluteString.contains("authCode") {
                let redundantCodeLength = 2;
                naverLoginUrl = URL(string: "\(url.absoluteString.dropLast(redundantCodeLength))0&authCode=")!;
            }
            result = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: naverLoginUrl, options: options)
        }
        
        return result
    }
}

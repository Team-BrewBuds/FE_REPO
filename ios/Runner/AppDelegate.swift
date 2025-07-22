import UIKit
import Flutter
import NidThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var result = false
        if (url.absoluteString.hasPrefix("kakao")) {
            result = super.application(app, open: url, options: options)
        }
        
        if (NidOAuth.shared.handleURL(url) == true) {
          return true
        }
        
        return result
    }
}

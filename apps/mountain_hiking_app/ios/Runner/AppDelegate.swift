import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     //GMSServices.provideAPIKey("REDACTED_GOOGLE_MAPS_API_KEY") // <--- 加入這行
    GMSServices.provideAPIKey("REDACTED_GOOGLE_MAPS_API_KEY") // <--- 加入這行
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

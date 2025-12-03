import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Read API Key from .env
    let assetPath = FlutterDartProject.lookupKey(forAsset: ".env")
    if let path = Bundle.main.path(forResource: assetPath, ofType: nil) {
        do {
            let content = try String(contentsOfFile: path)
            let lines = content.components(separatedBy: .newlines)
            for line in lines {
                if line.starts(with: "GOOGLE_MAPS_API_KEY=") {
                    let apiKey = String(line.dropFirst("GOOGLE_MAPS_API_KEY=".count)).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !apiKey.isEmpty {
                        GMSServices.provideAPIKey(apiKey)
                    }
                    break
                }
            }
        } catch {
            print("Error reading .env file: \(error)")
        }
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // engineBridge.applicationRegistrar.messenger() is the documented way
    // to get a FlutterBinaryMessenger from FlutterImplicitEngineBridge.
    let shareChannel = FlutterMethodChannel(
      name: "rectify/share",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    shareChannel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "share", let text = call.arguments as? String else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let vc = self?.window?.rootViewController as? FlutterViewController else {
        result(FlutterError(code: "NO_VC", message: "Root view controller unavailable", details: nil))
        return
      }
      let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
      if let popover = activityVC.popoverPresentationController {
        popover.sourceView = vc.view
        popover.sourceRect = CGRect(
          x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0
        )
        popover.permittedArrowDirections = []
      }
      vc.present(activityVC, animated: true)
      result(nil)
    }
  }
}

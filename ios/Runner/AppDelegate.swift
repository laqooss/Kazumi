import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        // let channel = FlutterMethodChannel(name: "com.predidit.laqoo/intent",
        //                                    binaryMessenger: controller.binaryMessenger)
        // channel.setMethodCallHandler({
        //     (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        //     if call.method == "openVideoWithMime" {
        //         guard let args = call.arguments else { return }
        //         if let myArgs = args as? [String: Any],
        //            let url = myArgs["url"] as? String,
        //            let mimeType = myArgs["mimeType"] as? String {
        //             self.openVideoWithMime(url: url, mimeType: mimeType)
        //         }
        //         result(nil)
        //     } else {
        //         result(FlutterMethodNotImplemented)
        //     }
        // })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // private func openVideoWithMime(url: String, mimeType: String) {
    //     if let videoUrl = URL(string: url) {
    //         let player = AVPlayer(url: videoUrl)
    //         let playerViewController = AVPlayerViewController()
    //         playerViewController.player = player
    //
    //         UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true, completion: {
    //             playerViewController.player!.play()
    //         })
    //     }
    // }
}
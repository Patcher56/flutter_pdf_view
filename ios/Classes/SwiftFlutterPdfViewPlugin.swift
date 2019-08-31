import Flutter
import UIKit
import PDFKit

public class FlutterPDFViewFactory : NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return FlutterPDFView(frame, viewId: viewId, args: (args as? Dictionary<String, Any>)!)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

public class FlutterPDFView : NSObject, FlutterPlatformView {
    let frame: CGRect
    let args: Dictionary<String, Any>

    init(_ frame: CGRect, viewId: Int64, args: Dictionary<String, Any>) {
        self.frame = frame
        self.args = args
        print(args)
    }

    public func view() -> UIView {
        if #available(iOS 11.0, *) {
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: URL(fileURLWithPath: self.args["path"] as! String))
            pdfView.displayMode = PDFDisplayMode.singlePageContinuous
            pdfView.autoScales = true

            return pdfView
        } else {
            let label = UILabel(frame: self.frame)
            label.text = "No support for iOS < 11.0"
            return label
        }
    }

}

public class SwiftFlutterPdfViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pdf_view", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPdfViewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // register factory and view
    let factory = FlutterPDFViewFactory(messenger: registrar.messenger())
    let viewId = "FlutterPDFView"
    registrar.register(factory, withId: viewId)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

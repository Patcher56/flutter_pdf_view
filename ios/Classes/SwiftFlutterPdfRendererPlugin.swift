import Flutter
import UIKit
import PDFKit

public class FlutterPDFViewFactory : NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        print("arguments \(args ?? "")")
        return FlutterPDFView(frame, viewId:viewId, args:args)
    }
}

public class FlutterPDFView : NSObject, FlutterPlatformView {
    let frame: CGRect

    init(_ frame: CGRect, viewId: Int64, args: Any?) {
        self.frame = frame
        print(args ?? "")
    }

    public func view() -> UIView {
        if #available(iOS 11.0, *) {
            let pdfView = PDFView()
//            pdfView.document = PDFDocument(url: URL(fileURLWithPath: path))
//            pdfview.displayMode = PDFDisplayMode.singlePageContinuous
            pdfView.autoScales = true

            return pdfView
        } else {
            let label = UILabel(frame: self.frame)
            label.text = "No support for iOS < 11.0"
            return label
        }
    }

}

public class SwiftFlutterPdfRendererPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel!

    init(channel: FlutterMethodChannel) {
        super.init()
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FlutterPDFViewFactory(messenger: registrar.messenger())
        let viewId = "FlutterPDFView"
        registrar.register(factory, withId: viewId)
    }
}

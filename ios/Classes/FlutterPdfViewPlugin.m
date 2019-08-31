#import "FlutterPdfViewPlugin.h"
#import <flutter_pdf_view/flutter_pdf_view-Swift.h>

@implementation FlutterPdfViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPdfViewPlugin registerWithRegistrar:registrar];
}
@end

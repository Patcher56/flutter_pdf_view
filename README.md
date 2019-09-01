# flutter_pdf_view

A simple flutter plugin to show PDFs natively.
On iOS this plugin shows the PDF via the PDFKit (introduced in iOS 11.0). Currently iOS <11.0 is not supported and throws an error.
On Android this plugin opens the given pdf in one of the installed PDF viewers (you can choose which one).

## Getting Started

See the example on how to use it.

1. Import package in dart file

```dart
import 'package:flutter_pdf_view/flutter_pdf_view.dart';
```

2. Use new `PDFView` widget for showing the PDF output (only on iOS, but also needed on Android)

The easiest way to get a `pdfFilePath` from an URL is to use [flutter cache manager](https://pub.dev/packages/flutter_cache_manager) plugin.

```dart
PdfView(pdfFile: pdfFilePath);
```

### For iOS: Activate PlatformView preview

We work with an embedded view (called `PlatformView` using `UIKitView` for showing the native iOS PDFView).
Becuase this is still not activated by default, you have to insert the following code in the `ios/Runner/Info.plist` file in your project.

```plist
<key>io.flutter.embedded_views_preview</key>
<true/>
```

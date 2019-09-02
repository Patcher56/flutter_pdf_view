import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class FlutterPdfView {
  static const MethodChannel _channel = const MethodChannel('flutter_pdf_view');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class PdfView extends StatefulWidget {
  final String pdfFile;

  PdfView({@required this.pdfFile});

  @override
  State<StatefulWidget> createState() => _PdfViewState();
}

void openPdfFile(String path) {
  if (!Platform.isAndroid) {
    return;
  }

  final MethodChannel _channel = MethodChannel('flutter_pdf_view');
  _channel.invokeMethod('openPdfFile', {'path': path});
}

class _PdfViewState extends State<PdfView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return UiKitView(
              viewType: 'FlutterPDFView',
              creationParams: {'path': widget.pdfFile},
              creationParamsCodec: StandardMessageCodec(),
            );
          } else {
            return Center(
              child: Text('A embedded pdf viewer is not supported on android.'),
            );
          }
        },
      ),
    );
  }
}

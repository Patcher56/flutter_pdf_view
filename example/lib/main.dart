import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pdf_view/flutter_pdf_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> downloadedFilePath;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void download() {
    setState(() {
      downloadedFilePath = downloadPdfFile(controller.text);
    });
  }

  Future<String> downloadPdfFile(String url) async {
    File fetchedFile = await DefaultCacheManager().getSingleFile(url);
    return fetchedFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PdfRenderer example app'),
        ),
        body: Column(children: <Widget>[
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter URL here...',
            ),
          ),
          RaisedButton(
            onPressed: download,
            child: Text('Render PDF'),
          ),
          FutureBuilder<String>(
            future: downloadedFilePath,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Text text = Text('');
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  text = Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  text = Text('Data: ${snapshot.data}');
                  return PdfView(pdfFile: snapshot.data);
                } else {
                  text = Text('Unavailable');
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                text = Text('Downloading PDF File...');
              } else {
                text = Text('Please load a PDF file.');
              }
              return Container(
                child: text,
              );
            },
          ),
        ]),
      ),
    );
  }
}

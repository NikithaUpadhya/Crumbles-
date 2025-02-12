import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String docUrl;

  PdfViewerScreen({required this.docUrl});

  Future<String> fetchPdf() async {
    final response = await http.get(Uri.parse(docUrl));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } else {
      throw Exception('Failed to load document');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Happy Learning :)'),
      ),
      body: FutureBuilder<String>(
        future: fetchPdf(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SfPdfViewer.file(
              File(snapshot.data!),
            );
          }
        },
      ),
    );
  }
}




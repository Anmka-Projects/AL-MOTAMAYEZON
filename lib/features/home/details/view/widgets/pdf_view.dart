import 'package:elmotamizon/common/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatelessWidget {
  const PdfView({super.key, required this.pdfLink, required this.name});
  final String pdfLink, name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: name),
      body: SfPdfViewerTheme(
        data: const SfPdfViewerThemeData(
          backgroundColor: Colors.white,
        ),
        child: SfPdfViewer.network(
          pdfLink,
          // key: _pdfViewerKey,
          canShowPaginationDialog: false,
        ),
      ),
    );
  }
}

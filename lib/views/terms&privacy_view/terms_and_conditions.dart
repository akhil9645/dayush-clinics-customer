import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndConditions extends StatefulWidget {
  final dynamic arguments;
  TermsAndConditions({super.key}) : arguments = Get.arguments;

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  Map<String, dynamic>? data;
  String? _errorMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          data?['appbartitle'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10.r),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : SfPdfViewer.asset(
              data?['pdffilepath'] ?? '',
              canShowScrollHead: true,
              enableDoubleTapZooming: true,
              onDocumentLoadFailed: (details) {
                developer.log("SfPdfViewer error: ${details.description}");
                setState(() {
                  _errorMessage = 'Error rendering PDF';
                });
              },
              onDocumentLoaded: (details) {
                developer.log(
                    "PDF loaded with ${details.document.pages.count} pages");
              },
            ),
    );
  }
}

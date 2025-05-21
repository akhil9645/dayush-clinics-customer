import 'dart:developer' as developer;
import 'dart:io';
import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/consultation_history & scheduled appointmentsController/consultationHistoryScheduledAppointmentscontroller.dart';

class ViewPrescription extends StatefulWidget {
  final dynamic arguments;
  ViewPrescription({super.key}) : arguments = Get.arguments;

  @override
  State<ViewPrescription> createState() => _ViewPrescriptionState();
}

class _ViewPrescriptionState extends State<ViewPrescription> {
  final ConsultationController consultationController =
      Get.find<ConsultationController>();
  Map<String, dynamic>? data;
  String? _pdfPath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    data = widget.arguments as Map<String, dynamic>;
    _loadPrescription();
  }

  Future<void> _loadPrescription() async {
    try {
      final consultationId = data?['consultationId'];
      final success = await consultationController
          .getPrescriptionDownloadUrl(consultationId);
      if (success && consultationController.downloadUrl.value.isNotEmpty) {
        final url = consultationController.downloadUrl.value;
        final file = await _downloadPdf(url);
        setState(() {
          _pdfPath = file.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to fetch prescription URL';
        });
      }
    } catch (e) {
      developer.log("Error loading prescription: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading prescription';
      });
    }
  }

  Future<File> _downloadPdf(String url) async {
    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/prescription_${DateTime.now().millisecondsSinceEpoch}.pdf';
    try {
      await dio.download(url, filePath);
      return File(filePath);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 403) {
        final success = await consultationController
            .getPrescriptionDownloadUrl(data?['consultationId']);
        if (success) {
          await dio.download(
              consultationController.downloadUrl.value, filePath);
          return File(filePath);
        }
      }
      throw Exception('Failed to download PDF: $e');
    }
  }

  Future<void> _savePdfToStorage() async {
    try {
      if (_pdfPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets()
              .snackBarinfo('No PDF available to download.', color: Colors.red),
        );
        return;
      }

      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              CommonWidgets().snackBarinfo('Storage permission denied.',
                  color: Colors.red),
            );
            return;
          }
        }
      }

      Directory? directory;
      String fileName =
          'Prescription_${DateTime.now().millisecondsSinceEpoch}.pdf';
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final newFilePath = '${directory.path}/$fileName';
      final tempFile = File(_pdfPath!);
      await tempFile.copy(newFilePath);

      if (Platform.isAndroid) {
        await Process.run('am', [
          'broadcast',
          '-a',
          'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
          '-d',
          'file://$newFilePath'
        ]);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo(
          'PDF saved to ${Platform.isAndroid ? 'Downloads' : 'Documents'} folder.',
          color: Colors.green,
        ),
      );
      developer.log("PDF saved at: $newFilePath");
    } catch (e) {
      developer.log("Error saving PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo('Failed to save PDF.', color: Colors.red),
      );
    }
  }

  Future<void> _sharePdf() async {
    try {
      if (_pdfPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets()
              .snackBarinfo('No PDF available to share.', color: Colors.red),
        );
        return;
      }

      // Share the PDF file
      final file = File(_pdfPath!);
      await Share.shareXFiles(
        [XFile(_pdfPath!, mimeType: 'application/pdf')],
        text: 'Prescription PDF',
        subject: 'Share Prescription',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets()
            .snackBarinfo('PDF shared successfully.', color: Colors.green),
      );
      developer.log("PDF shared from: $_pdfPath");
    } catch (e) {
      developer.log("Error sharing PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonWidgets().snackBarinfo('Failed to share PDF.', color: Colors.red),
      );
    }
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
          'View Prescription',
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5).r,
            child: IconButton(
              onPressed: _savePdfToStorage,
              icon: Icon(
                Icons.file_download_outlined,
                size: 24.w,
              ),
              tooltip: 'Download PDF',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15).r,
            child: IconButton(
              onPressed: _sharePdf,
              icon: Icon(
                Icons.share_outlined,
                size: 24.w,
              ),
              tooltip: 'Share PDF',
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                  ),
                )
              : _pdfPath != null
                  ? SfPdfViewer.file(
                      File(_pdfPath!),
                      canShowScrollHead: true,
                      enableDoubleTapZooming: true,
                      onDocumentLoadFailed: (details) {
                        developer
                            .log("SfPdfViewer error: ${details.description}");
                        setState(() {
                          _errorMessage = 'Error rendering PDF';
                        });
                      },
                      onDocumentLoaded: (details) {
                        developer.log(
                            "PDF loaded with ${details.document.pages.count} pages");
                      },
                    )
                  : Center(
                      child: Text(
                        'No PDF available',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
    );
  }

  @override
  void dispose() {
    if (_pdfPath != null) {
      File(_pdfPath!)
          .delete()
          .catchError((e) => developer.log("Error deleting temp file: $e"));
    }
    super.dispose();
  }
}

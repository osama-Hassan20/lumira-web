// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:printing/printing.dart';
// import 'package:share_plus/share_plus.dart';

// import '../extensions/localization_extension.dart';
// import '../helpers/app_toast.dart';
// import '../widgets/private_widgets/pdf_preview_screen.dart';
// import '../widgets/private_widgets/prescription_pdf_output_dialog.dart';

// enum PrescriptionPdfOutputAction {
//   email,
//   whatsapp,
//   savePdf,
//   printDirect,
//   viewBeforePrint,
// }

// class PrescriptionPdfActionService {
//   PrescriptionPdfActionService._();

//   static Future<void> handlePrescriptionOutput({
//     required BuildContext context,
//     required Future<Uint8List> Function() generatePdfBytes,
//     required String fileNamePrefix,
//     required String previewTitle,
//   }) async {
//     final selectedAction = await PrescriptionPdfOutputDialog.show(context);
//     if (selectedAction == null || !context.mounted) return;

//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );

//     try {
//       final pdfBytes = await generatePdfBytes();
//       if (!context.mounted) return;

//       if (Navigator.of(context, rootNavigator: true).canPop()) {
//         Navigator.of(context, rootNavigator: true).pop();
//       }

//       await _executeAction(
//         context: context,
//         action: selectedAction,
//         pdfBytes: pdfBytes,
//         fileNamePrefix: fileNamePrefix,
//         previewTitle: previewTitle,
//       );
//     } catch (_) {
//       if (context.mounted) {
//         if (Navigator.of(context, rootNavigator: true).canPop()) {
//           Navigator.of(context, rootNavigator: true).pop();
//         }
//         ShowToast.showError(
//           context: context,
//           messageTitle: context.l10n.tr('something_went_wrong'),
//         );
//       }
//     }
//   }

//   static Future<void> _executeAction({
//     required BuildContext context,
//     required PrescriptionPdfOutputAction action,
//     required Uint8List pdfBytes,
//     required String fileNamePrefix,
//     required String previewTitle,
//   }) async {
//     switch (action) {
//       case PrescriptionPdfOutputAction.email:
//         await _sharePdf(
//           pdfBytes: pdfBytes,
//           fileNamePrefix: fileNamePrefix,
//           title: previewTitle,
//           message: context.l10n.tr('pdf_output_share_message'),
//         );
//         break;
//       case PrescriptionPdfOutputAction.whatsapp:
//         await _sharePdf(
//           pdfBytes: pdfBytes,
//           fileNamePrefix: fileNamePrefix,
//           title: previewTitle,
//           message: context.l10n.tr('pdf_output_share_message'),
//         );
//         break;
//       case PrescriptionPdfOutputAction.savePdf:
//         await _savePdf(
//           context: context,
//           pdfBytes: pdfBytes,
//           fileNamePrefix: fileNamePrefix,
//         );
//         break;
//       case PrescriptionPdfOutputAction.printDirect:
//         await Printing.layoutPdf(onLayout: (_) => pdfBytes);
//         break;
//       case PrescriptionPdfOutputAction.viewBeforePrint:
//         if (!context.mounted) return;
//         await Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) =>
//                 PdfPreviewScreen(pdfBytes: pdfBytes, title: previewTitle),
//           ),
//         );
//         break;
//     }
//   }

//   static Future<void> _sharePdf({
//     required Uint8List pdfBytes,
//     required String fileNamePrefix,
//     required String title,
//     required String message,
//   }) async {
//     final fileName = _buildFileName(fileNamePrefix);
//     await SharePlus.instance.share(
//       ShareParams(
//         files: [
//           XFile.fromData(pdfBytes, name: fileName, mimeType: 'application/pdf'),
//         ],
//         subject: title,
//         text: message,
//       ),
//     );
//   }

//   static Future<void> _savePdf({
//     required BuildContext context,
//     required Uint8List pdfBytes,
//     required String fileNamePrefix,
//   }) async {
//     final directory = await _resolveSaveDirectory();
//     final fileName = _buildFileName(fileNamePrefix);
//     final file = File('${directory.path}${Platform.pathSeparator}$fileName');
//     await file.writeAsBytes(pdfBytes, flush: true);

//     if (context.mounted) {
//       ShowToast.showNote(
//         messageTitle: context.l10n.tr('pdf_output_saved_message'),
//       );
//     }
//   }

//   static Future<Directory> _resolveSaveDirectory() async {
//     try {
//       final downloadsDirectory = await getDownloadsDirectory();
//       if (downloadsDirectory != null) return downloadsDirectory;
//     } catch (_) {
//       // Fallback below.
//     }

//     return getApplicationDocumentsDirectory();
//   }

//   static String _buildFileName(String fileNamePrefix) {
//     final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
//     return '${fileNamePrefix}_$timestamp.pdf';
//   }
// }

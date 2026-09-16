import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' as html;

class ExcelExportHelper {
  static Future<void> exportToExcel({
    required String fileName,
    required List<String> headers,
    required List<List<String>> data,
  }) async {
    // Create a new Excel document.
    final Workbook workbook = Workbook();
    // Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];

    // Add headers
    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.getRangeByIndex(1, col + 1);
      cell.setText(headers[col]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#E9B824';
      cell.cellStyle.hAlign = HAlignType.center;
      cell.cellStyle.vAlign = VAlignType.center;
      cell.columnWidth = 25.0; // wider column
    }

    // Add data
    for (int row = 0; row < data.length; row++) {
      for (int col = 0; col < data[row].length; col++) {
        final cell = sheet.getRangeByIndex(row + 2, col + 1);
        final value = data[row][col];
        cell.setText(value);
        cell.cellStyle.hAlign = HAlignType.center;
        cell.cellStyle.vAlign = VAlignType.center;

        // Apply specific colors based on status string matching the app design
        if (value == 'نشط' || value == 'جديدة' || value == 'قديم وفعال' || value == 'تمت الموافقة') {
          cell.cellStyle.fontColor = '#008000'; // AppColors.green00
          cell.cellStyle.backColor = '#E5F2E5';
        } else if (value == 'غير نشط' || value == 'مرفوض' || value == 'منتهي') {
          cell.cellStyle.fontColor = '#FB0202'; // AppColors.red202
          cell.cellStyle.backColor = '#FFE5E5';
        } else if (value == 'بدون اشتراك' || value == 'قريب من الانتهاء' || value == 'قيد المراجعة' || value == 'قيد الانتظار') {
          cell.cellStyle.fontColor = '#E9B824'; // AppColors.yellow
          cell.cellStyle.backColor = '#FFF8E5';
        }
      }
    }

    // Save the document.
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final now = DateTime.now();
    final String fullFileName = '${fileName}_${now.year}${now.month}${now.day}_${now.hour}${now.minute}.xlsx';

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fullFileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fullFileName';
      final file = File(path);
      await file.writeAsBytes(bytes);
    }
  }
}

// تم تعليق هذا الملف - نستخدم رفع الصور فقط حالياً
/*
 
import 'package:flutter/material.dart';

import '../../../core/utils/theme/app_colors.dart';

class DocumentPreviewWidget extends StatelessWidget {
  const DocumentPreviewWidget({
    super.key,
    required this.fileName,
    required this.filePath,
    this.fileSize,
    this.onTap,
  });

  final String fileName;
  final String filePath;
  final String? fileSize;
  final VoidCallback? onTap;

  DocumentInfo _getDocumentInfo() {
    final ext = filePath.split('.').last.toLowerCase();

    switch (ext) {
      case 'pdf':
        return DocumentInfo(
          icon: Icons.picture_as_pdf,
          color: const Color(0xFFE53935), // Red
          label: 'PDF Document',
        );
      case 'doc':
      case 'docx':
        return DocumentInfo(
          icon: Icons.description,
          color: const Color(0xFF1976D2), // Blue
          label: 'Word Document',
        );
      case 'xls':
      case 'xlsx':
        return DocumentInfo(
          icon: Icons.table_chart,
          color: const Color(0xFF388E3C), // Green
          label: 'Excel Spreadsheet',
        );
      case 'txt':
        return DocumentInfo(
          icon: Icons.text_snippet,
          color: const Color(0xFF757575), // Gray
          label: 'Text File',
        );
      case 'ppt':
      case 'pptx':
        return DocumentInfo(
          icon: Icons.slideshow,
          color: const Color(0xFFD32F2F), // Red-Orange
          label: 'PowerPoint',
        );
      case 'zip':
      case 'rar':
        return DocumentInfo(
          icon: Icons.folder_zip,
          color: const Color(0xFFFFA000), // Orange
          label: 'Archive',
        );
      default:
        return DocumentInfo(
          icon: Icons.insert_drive_file,
          color: AppColors.grayAD,
          label: 'File',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final docInfo = _getDocumentInfo();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gray2E,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray29),
        ),
        child: Row(
          children: [
            // Document Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: docInfo.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(docInfo.icon, size: 32, color: docInfo.color),
            ),
            const SizedBox(width: 16),
            // File Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: AppFontStyle.semiBold14(context).copyWith(color: AppColors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    docInfo.label,
                    style: AppFontStyle.regular12(
                      context,
                    ).copyWith(color: AppColors.grayAD),
                  ),
                  if (fileSize != null && fileSize!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.storage, size: 12, color: AppColors.grayAD),
                        const SizedBox(width: 4),
                        Text(
                          fileSize!,
                          style: AppFontStyle.regular12(
                            context,
                          ).copyWith(color: AppColors.grayAD),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Open indicator
            if (onTap != null)
              Icon(Icons.open_in_new, color: AppColors.grayAD, size: 20),
          ],
        ),
      ),
    );
  }
}

class DocumentInfo {
  final IconData icon;
  final Color color;
  final String label;

  DocumentInfo({required this.icon, required this.color, required this.label});
}
*/

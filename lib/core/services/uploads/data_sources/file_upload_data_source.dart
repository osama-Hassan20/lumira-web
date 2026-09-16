import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../api/api_consumer.dart';
import '../../../api/end_points.dart';
import '../models/file_upload_model.dart';
import '../presentation/media_type_model.dart';

abstract class FileUploadDataSource {
  /// Upload a single file to server with optional compression for images
  Future<FileUploadResult> uploadFile(
    MediaTypeModel file, {
    int maxWidth = 1920,
    int quality = 85,
  });

  /// Upload multiple files to server
  Future<MultiFileUploadResult> uploadMultipleFiles(
    List<MediaTypeModel> files, {
    int maxWidth = 1920,
    int quality = 85,
  });
}

class FileUploadDataSourceImpl implements FileUploadDataSource {
  final ApiConsumer apiServices;
  final bool useMockUpload;

  FileUploadDataSourceImpl({
    required this.apiServices,
    this.useMockUpload = true,
  });

  @override
  Future<FileUploadResult> uploadFile(
    MediaTypeModel file, {
    int maxWidth = 1920,
    int quality = 85,
  }) async {
    try {
      if (!file.isValid) {
        return FileUploadResult.failure('Invalid file: no path or bytes');
      }

      MediaTypeModel fileToUpload = file;

      // Compress if it's an image and its size is greater than 200 KB
      if (file.category == MediaCategory.image && file.isFile) {
        int fileSizeInBytes = 0;

        if (file.fileBytes != null) {
          fileSizeInBytes = file.fileBytes!.lengthInBytes;
        } else if (file.path.isNotEmpty) {
          final fileObj = File(file.path);
          if (await fileObj.exists()) {
            fileSizeInBytes = await fileObj.length();
          }
        }

        const int limit512KB = 512 * 1024;
        const int limit1MB = 1024 * 1024;

        if (fileSizeInBytes > limit1MB) {
          return FileUploadResult.failure('حجم الصورة يجب أن لا يتعدى 1 ميجابايت');
        }

        if (fileSizeInBytes > limit512KB) {
          // بنمرر quality مبدئية عالية (95) عشان ينزل منها تدريجياً (95 -> 85 -> 75 -> ...)
          final compressed = await _processImage(file, maxWidth, 95);
          if (compressed != null) {
            fileToUpload = compressed;
          }
        }
      }

      if (useMockUpload) {
        // Backend upload endpoint is not ready yet; return mock URL for now.
        await Future<void>.delayed(const Duration(milliseconds: 250));
        final now = DateTime.now().millisecondsSinceEpoch;
        final extension = fileToUpload.extension.isNotEmpty
            ? fileToUpload.extension
            : 'jpg';
        final fileName = fileToUpload.filename ?? 'mock_upload_$now.$extension';
        return FileUploadResult.success(
          url: 'https://mock.local/uploads/$fileName',
          fileName: fileName,
        );
      }

      late MultipartFile multipartFile;

      if (fileToUpload.fileBytes != null) {
        multipartFile = MultipartFile.fromBytes(
          fileToUpload.fileBytes!,
          filename: fileToUpload.filename,
          contentType: MediaType.parse(_getMimeType(fileToUpload)),
        );
      } else if (fileToUpload.path.isNotEmpty) {
        multipartFile = await MultipartFile.fromFile(
          fileToUpload.path,
          filename: fileToUpload.filename,
          contentType: MediaType.parse(_getMimeType(fileToUpload)),
        );
      } else {
        return FileUploadResult.failure('No file data available');
      }

      String key = 'file';
      String endPoint = EndPoints.uploadAny;
      if (file.category == MediaCategory.image) {
        key = 'image';
        endPoint = EndPoints.uploadImage;
      } else if (file.category == MediaCategory.video) {
        key = 'file';
        endPoint = EndPoints.uploadVideo;
      } else if (file.category == MediaCategory.document) {
        endPoint = EndPoints.uploadDocument;
        key = 'document';
      }
      final formData = FormData.fromMap({key: multipartFile});

      // Re-enable this real API call when backend auth/upload is ready.
      // apiServices.post يرجع response.data مباشرة (الـ Map المحلل)
      final responseData = await apiServices.post(
        path: endPoint,
        body: formData,
      );

      // الـ responseData هو الـ Map المرجع من السيرفر مباشرة
      if (responseData is Map) {
        final url =
            responseData['file'] ??
            responseData['image'] ??
            responseData['filename'] ??
            responseData['path'] ??
            responseData['fileName'];
        if (url != null) {
          return FileUploadResult.success(
            url: url.toString(),
            fileName: fileToUpload.filename,
          );
        }
      }
      return FileUploadResult.failure('Upload failed: unexpected response');
    } catch (e) {
      return FileUploadResult.failure(e.toString());
    }
  }

  @override
  Future<MultiFileUploadResult> uploadMultipleFiles(
    List<MediaTypeModel> files, {
    int maxWidth = 1920,
    int quality = 85,
  }) async {
    try {
      if (useMockUpload) {
        // Fallback or mock
        await Future<void>.delayed(const Duration(milliseconds: 500));
        final results = files.map((f) => FileUploadResult.success(
          url: 'https://mock.local/uploads/${DateTime.now().millisecondsSinceEpoch}_${f.filename ?? 'mock.jpg'}',
          fileName: f.filename,
        )).toList();
        return MultiFileUploadResult(results: results);
      }

      List<MultipartFile> multipartFiles = [];
      List<MediaTypeModel> processedFiles = [];

      for (final file in files) {
        if (!file.isValid) continue;

        MediaTypeModel fileToUpload = file;

        // Compress if it's an image and its size is greater than 200 KB
        if (file.category == MediaCategory.image && file.isFile) {
          int fileSizeInBytes = 0;

          if (file.fileBytes != null) {
            fileSizeInBytes = file.fileBytes!.lengthInBytes;
          } else if (file.path.isNotEmpty) {
            final fileObj = File(file.path);
            if (await fileObj.exists()) {
              fileSizeInBytes = await fileObj.length();
            }
          }

          const int limit512KB = 512 * 1024;
          const int limit1MB = 1024 * 1024;

          if (fileSizeInBytes > limit1MB) {
            return MultiFileUploadResult(results: [FileUploadResult.failure('حجم إحدى الصور يجب أن لا يتعدى 1 ميجابايت')]);
          }

          if (fileSizeInBytes > limit512KB) {
            final compressed = await _processImage(file, maxWidth, 95);
            if (compressed != null) {
              fileToUpload = compressed;
            }
          }
        }

        processedFiles.add(fileToUpload);

        if (fileToUpload.fileBytes != null) {
          multipartFiles.add(MultipartFile.fromBytes(
            fileToUpload.fileBytes!,
            filename: fileToUpload.filename ?? 'image.jpg',
            contentType: MediaType.parse(_getMimeType(fileToUpload)),
          ));
        } else if (fileToUpload.path.isNotEmpty) {
          multipartFiles.add(await MultipartFile.fromFile(
            fileToUpload.path,
            filename: fileToUpload.filename ?? 'image.jpg',
            contentType: MediaType.parse(_getMimeType(fileToUpload)),
          ));
        }
      }

      if (multipartFiles.isEmpty) {
        return MultiFileUploadResult(results: [FileUploadResult.failure('لا توجد ملفات صالحة للرفع')]);
      }

      final formData = FormData();
      for (var mpFile in multipartFiles) {
        formData.files.add(MapEntry('images', mpFile));
      }

      final responseData = await apiServices.post(
        path: EndPoints.uploadImages,
        body: formData,
      );

      if (responseData is Map && responseData['images'] is List) {
        final List<dynamic> uploadedImages = responseData['images'];
        final List<FileUploadResult> results = [];

        for (int i = 0; i < uploadedImages.length; i++) {
          results.add(FileUploadResult.success(
            url: uploadedImages[i].toString(),
            fileName: i < processedFiles.length ? processedFiles[i].filename : 'image_$i.jpg',
          ));
        }
        return MultiFileUploadResult(results: results);
      }

      return MultiFileUploadResult(results: [FileUploadResult.failure('فشل الرفع: استجابة غير متوقعة')]);
    } catch (e) {
      return MultiFileUploadResult(results: [FileUploadResult.failure(e.toString())]);
    }
  }

  /// Process and compress image data
  Future<MediaTypeModel?> _processImage(
    MediaTypeModel mediaModel,
    int maxWidth,
    int quality,
  ) async {
    try {
      Uint8List? originalBytes;
      if (mediaModel.fileBytes != null) {
        originalBytes = mediaModel.fileBytes;
      } else if (mediaModel.path.isNotEmpty) {
        originalBytes = await File(mediaModel.path).readAsBytes();
      }

      if (originalBytes == null) return null;

      debugPrint(
        'Original image size: ${(originalBytes.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB',
      );

      final compressedBytes = await FlutterImageCompress.compressWithList(
        originalBytes,
        quality: quality,
        minWidth: maxWidth,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes.isEmpty) return null;

      debugPrint(
        'Compressed image size: ${(compressedBytes.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB',
      );

      String? filePath;
      final fileName = mediaModel.filename != null
          ? '${mediaModel.filename!.replaceAll(RegExp(r'\.[^.]+$'), '')}_compressed.jpg'
          : 'image_${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      if (!kIsWeb) {
        // Save compressed file to temp directory for non-web platforms
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(compressedBytes);
        filePath = tempFile.path;
      }

      return mediaModel.copyWith(
        path: filePath ?? mediaModel.path,
        fileBytes: compressedBytes,
        filename: fileName,
        mimeType: 'image/jpeg',
      );
    } catch (e) {
      debugPrint('Error processing image for upload: $e');
      return null;
    }
  }

  String _getMimeType(MediaTypeModel file) {
    if (file.mimeType != null) return file.mimeType!;

    final ext = file.extension;
    switch (file.category) {
      case MediaCategory.image:
        switch (ext) {
          case 'jpg':
          case 'jpeg':
            return 'image/jpeg';
          case 'png':
            return 'image/png';
          case 'gif':
            return 'image/gif';
          case 'webp':
            return 'image/webp';
          default:
            return 'image/jpeg';
        }
      case MediaCategory.video:
        switch (ext) {
          case 'mp4':
            return 'video/mp4';
          case 'mov':
            return 'video/quicktime';
          case 'avi':
            return 'video/x-msvideo';
          default:
            return 'video/mp4';
        }
      case MediaCategory.audio:
        switch (ext) {
          case 'mp3':
            return 'audio/mpeg';
          case 'wav':
            return 'audio/wav';
          case 'aac':
            return 'audio/aac';
          case 'm4a':
            return 'audio/mp4';
          default:
            return 'audio/mpeg';
        }
      case MediaCategory.document:
        switch (ext) {
          case 'pdf':
            return 'application/pdf';
          case 'doc':
          case 'docx':
            return 'application/msword';
          case 'xls':
          case 'xlsx':
            return 'application/vnd.ms-excel';
          case 'txt':
            return 'text/plain';
          default:
            return 'application/octet-stream';
        }
    }
  }
}

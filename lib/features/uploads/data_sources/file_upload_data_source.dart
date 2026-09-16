// import 'dart:io';
// import 'package:http_parser/http_parser.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as img;
// import '../../../core/api/api_consumer.dart';
// import '../../../core/api/end_points.dart';
// import '../models/file_upload_model.dart';
// import '../presentation/media_type_model.dart';

// abstract class FileUploadDataSource {
//   /// Upload a single file to server with optional compression for images
//   Future<FileUploadResult> uploadFile(
//     MediaTypeModel file, {
//     int maxWidth = 1920,
//     int quality = 85,
//   });

//   /// Upload multiple files to server
//   Future<MultiFileUploadResult> uploadMultipleFiles(
//     List<MediaTypeModel> files, {
//     int maxWidth = 1920,
//     int quality = 85,
//   });
// }

// class FileUploadDataSourceImpl implements FileUploadDataSource {
//   final ApiConsumer apiServices;
//   final bool useMockUpload;

//   FileUploadDataSourceImpl({
//     required this.apiServices,
//     this.useMockUpload = true,
//   });

//   @override
//   Future<FileUploadResult> uploadFile(
//     MediaTypeModel file, {
//     int maxWidth = 1920,
//     int quality = 85,
//   }) async {
//     try {
//       if (!file.isValid) {
//         return FileUploadResult.failure('Invalid file: no path or bytes');
//       }

//       MediaTypeModel fileToUpload = file;

//       // Compress if it's an image and its size is greater than 200 KB
//       if (file.category == MediaCategory.image && file.isFile) {
//         int fileSizeInBytes = 0;

//         if (file.fileBytes != null) {
//           fileSizeInBytes = file.fileBytes!.lengthInBytes;
//         } else if (file.path.isNotEmpty) {
//           final fileObj = File(file.path);
//           if (await fileObj.exists()) {
//             fileSizeInBytes = await fileObj.length();
//           }
//         }

//         const int limit200KB = 200 * 1024;

//         if (fileSizeInBytes > limit200KB) {
//           // بنمرر quality مبدئية عالية (95) عشان ينزل منها تدريجياً (95 -> 85 -> 75 -> ...)
//           final compressed = await _processImage(file, maxWidth, 95);
//           if (compressed != null) {
//             fileToUpload = compressed;
//           }
//         }
//       }

//       if (useMockUpload) {
//         // Temporary mock mode until backend auth/upload is ready.
//         await Future<void>.delayed(const Duration(milliseconds: 250));
//         final now = DateTime.now().millisecondsSinceEpoch;
//         final extension = fileToUpload.extension.isNotEmpty
//             ? fileToUpload.extension
//             : 'jpg';
//         final fileName = fileToUpload.fileName ?? 'mock_upload_$now.$extension';
//         return FileUploadResult.success(
//           url: 'https://mock.local/uploads/$fileName',
//           fileName: fileName,
//         );
//       }

//       late MultipartFile multipartFile;

//       if (fileToUpload.fileBytes != null) {
//         multipartFile = MultipartFile.fromBytes(
//           fileToUpload.fileBytes!,
//           filename: fileToUpload.fileName,
//           contentType: MediaType.parse(_getMimeType(fileToUpload)),
//         );
//       } else if (fileToUpload.path.isNotEmpty) {
//         multipartFile = await MultipartFile.fromFile(
//           fileToUpload.path,
//           filename: fileToUpload.fileName,
//           contentType: MediaType.parse(_getMimeType(fileToUpload)),
//         );
//       } else {
//         return FileUploadResult.failure('No file data available');
//       }

//       String key = 'file';
//       String endPoint = EndPoints.uploadAny;
//       if (file.category == MediaCategory.image) {
//         key = 'image';
//         endPoint = EndPoints.uploadImage;
//       } else if (file.category == MediaCategory.video) {
//         key = 'video';
//         endPoint = EndPoints.uploadVideo;
//       } else if (file.category == MediaCategory.document) {
//         endPoint = EndPoints.uploadDocument;
//         key = 'document';
//       }
//       final formData = FormData.fromMap({key: multipartFile});

//       // apiServices.post يرجع response.data مباشرة (الـ Map المحلل)
//       final responseData = await apiServices.post(
//         path: endPoint,
//         body: formData,
//       );

//       // الـ responseData هو الـ Map المرجع من السيرفر مباشرة
//       if (responseData is Map) {
//         final serverFilename = responseData['filename']?.toString();
//         final url =
//             serverFilename ??
//             responseData['path']?.toString() ??
//             responseData['fileName']?.toString();
//         if (url != null) {
//           return FileUploadResult.success(
//             url: url,
//             fileName: serverFilename ?? url,
//           );
//         }
//       }
//       return FileUploadResult.failure('Upload failed: unexpected response');
//     } catch (e) {
//       return FileUploadResult.failure(e.toString());
//     }
//   }

//   @override
//   Future<MultiFileUploadResult> uploadMultipleFiles(
//     List<MediaTypeModel> files, {
//     int maxWidth = 1920,
//     int quality = 85,
//   }) async {
//     final List<FileUploadResult> results = [];

//     for (final file in files) {
//       final result = await uploadFile(
//         file,
//         maxWidth: maxWidth,
//         quality: quality,
//       );
//       results.add(result);
//     }

//     return MultiFileUploadResult(results: results);
//   }

//   /// Process and compress image data
//   Future<MediaTypeModel?> _processImage(
//     MediaTypeModel mediaModel,
//     int maxWidth,
//     int quality,
//   ) async {
//     try {
//       Uint8List? imageBytes;
//       String? filePath;
//       final fileName =
//           'image_${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

//       Uint8List? originalBytes;
//       if (mediaModel.fileBytes != null) {
//         originalBytes = mediaModel.fileBytes;
//       } else if (mediaModel.path.isNotEmpty) {
//         originalBytes = await File(mediaModel.path).readAsBytes();
//       }

//       if (originalBytes == null) return null;

//       debugPrint(
//         'Original image size: ${(originalBytes.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB',
//       );

//       final compressed = await _compressImageBytes(
//         originalBytes,
//         maxWidth,
//         quality,
//       );
//       if (compressed == null) return null;

//       debugPrint(
//         'Compressed image size: ${(compressed.lengthInBytes / 1024 / 1024).toStringAsFixed(2)} MB',
//       );

//       imageBytes = compressed;

//       if (!kIsWeb) {
//         // Save compressed file to temp directory for non-web platforms
//         final tempDir = await getTemporaryDirectory();
//         final tempFile = File('${tempDir.path}/$fileName');
//         await tempFile.writeAsBytes(imageBytes);
//         filePath = tempFile.path;
//       }

//       return mediaModel.copyWith(
//         path: filePath ?? mediaModel.path,
//         fileBytes: imageBytes,
//         fileName: fileName,
//         mimeType: 'image/jpeg',
//       );
//     } catch (e) {
//       debugPrint('Error processing image for upload: $e');
//       return null;
//     }
//   }

//   /// Compress image bytes
//   Future<Uint8List?> _compressImageBytes(
//     Uint8List bytes,
//     int maxWidth,
//     int quality,
//   ) async {
//     try {
//       return await compute(
//         _isolateCompress,
//         _CompressionParams(bytes, maxWidth, quality),
//       );
//     } catch (e) {
//       debugPrint('Error compressing image: $e');
//       return null;
//     }
//   }

//   String _getMimeType(MediaTypeModel file) {
//     if (file.mimeType != null) return file.mimeType!;

//     final ext = file.extension;
//     switch (file.category) {
//       case MediaCategory.image:
//         switch (ext) {
//           case 'jpg':
//           case 'jpeg':
//             return 'image/jpeg';
//           case 'png':
//             return 'image/png';
//           case 'gif':
//             return 'image/gif';
//           case 'webp':
//             return 'image/webp';
//           default:
//             return 'image/jpeg';
//         }
//       case MediaCategory.video:
//         switch (ext) {
//           case 'mp4':
//             return 'video/mp4';
//           case 'mov':
//             return 'video/quicktime';
//           case 'avi':
//             return 'video/x-msvideo';
//           default:
//             return 'video/mp4';
//         }
//       case MediaCategory.audio:
//         switch (ext) {
//           case 'mp3':
//             return 'audio/mpeg';
//           case 'wav':
//             return 'audio/wav';
//           case 'aac':
//             return 'audio/aac';
//           case 'm4a':
//             return 'audio/mp4';
//           default:
//             return 'audio/mpeg';
//         }
//       case MediaCategory.document:
//         switch (ext) {
//           case 'pdf':
//             return 'application/pdf';
//           case 'doc':
//           case 'docx':
//             return 'application/msword';
//           case 'xls':
//           case 'xlsx':
//             return 'application/vnd.ms-excel';
//           case 'txt':
//             return 'text/plain';
//           default:
//             return 'application/octet-stream';
//         }
//     }
//   }
// }

// class _CompressionParams {
//   final Uint8List bytes;
//   final int maxWidth;
//   final int quality;

//   _CompressionParams(this.bytes, this.maxWidth, this.quality);
// }

// Future<Uint8List?> _isolateCompress(_CompressionParams params) async {
//   try {
//     final decoded = img.decodeImage(params.bytes);
//     if (decoded == null) return null;

//     img.Image imageToProcess = decoded;

//     // 1. تصغير الأبعاد الأول لو العرض أكبر من المسموح
//     if (decoded.width > params.maxWidth) {
//       imageToProcess = img.copyResize(decoded, width: params.maxWidth);
//     }

//     int currentQuality = params.quality; // يبدأ مثلاً من 90 או 95
//     const int limit200KB = 200 * 1024; // 200 KB
//     const int minQuality = 40; // حد أدنى للجودة عشان الصورة متبوظش

//     Uint8List compressedBytes = Uint8List.fromList(
//       img.encodeJpg(imageToProcess, quality: currentQuality),
//     );

//     // 2. تقليل الجودة تدريجياً 10% في كل محاولة لو الحجم لسه أكبر من 200KB
//     while (compressedBytes.lengthInBytes > limit200KB &&
//         currentQuality > minQuality) {
//       currentQuality -= 10; // تنزيل الجودة 10%
//       if (currentQuality < minQuality) currentQuality = minQuality;

//       compressedBytes = Uint8List.fromList(
//         img.encodeJpg(imageToProcess, quality: currentQuality),
//       );

//       // لو وصلنا للحد الأدنى للجودة نخرج عشان الجودة متبوظش خالص
//       if (currentQuality == minQuality) break;
//     }

//     return compressedBytes;
//   } catch (e) {
//     debugPrint('Error in isolate compression: $e');
//     return null;
//   }
// }

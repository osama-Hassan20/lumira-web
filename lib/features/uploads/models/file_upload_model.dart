// import 'dart:typed_data';

// /// Enum representing the type of file being uploaded
// enum FileUploadType { image, video, audio, custom }

// /// Model representing a file to be uploaded
// class FileUploadModel {
//   final String? filePath;
//   final Uint8List? fileBytes;
//   final String? fileName;
//   final FileUploadType? fileType;
//   final String? mimeType;

//   FileUploadModel({
//     this.filePath,
//     this.fileBytes,
//     this.fileName,
//     this.fileType,
//     this.mimeType,
//   });

//   /// Check if the file is valid (has either path or bytes)
//   bool get isValid => filePath != null || fileBytes != null;

//   /// Get the file extension from the file name
//   String get extension {
//     final name = fileName;
//     if (name == null || name.isEmpty) return '';
//     final parts = name.split('.');
//     return parts.length > 1 ? parts.last.toLowerCase() : '';
//   }

//   /// Get default mime type based on file type and extension
//   String get resolvedMimeType {
//     if (mimeType != null) return mimeType!;
//     if (fileType == null) return 'application/octet-stream';

//     switch (fileType ?? FileUploadType.image) {
//       case FileUploadType.image:
//         return _getImageMimeType(extension);
//       case FileUploadType.video:
//         return _getVideoMimeType(extension);
//       case FileUploadType.audio:
//         return _getAudioMimeType(extension);
//       case FileUploadType.custom:
//         return 'application/octet-stream';
//     }
//   }

//   String _getImageMimeType(String ext) {
//     switch (ext) {
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'gif':
//         return 'image/gif';
//       case 'webp':
//         return 'image/webp';
//       default:
//         return 'image/jpeg';
//     }
//   }

//   String _getVideoMimeType(String ext) {
//     switch (ext) {
//       case 'mp4':
//         return 'video/mp4';
//       case 'mov':
//         return 'video/quicktime';
//       case 'avi':
//         return 'video/x-msvideo';
//       case 'webm':
//         return 'video/webm';
//       default:
//         return 'video/mp4';
//     }
//   }

//   String _getAudioMimeType(String ext) {
//     switch (ext) {
//       case 'mp3':
//         return 'audio/mpeg';
//       case 'wav':
//         return 'audio/wav';
//       case 'aac':
//         return 'audio/aac';
//       case 'ogg':
//         return 'audio/ogg';
//       default:
//         return 'audio/mpeg';
//     }
//   }
// }

// /// Result model for file upload
// class FileUploadResult {
//   final String? url;
//   final String? fileName;
//   final bool? success;
//   final String? errorMessage;

//   FileUploadResult({this.url, this.fileName, this.success, this.errorMessage});

//   factory FileUploadResult.success({required String url, String? fileName}) {
//     return FileUploadResult(url: url, fileName: fileName, success: true);
//   }

//   factory FileUploadResult.failure(String errorMessage) {
//     return FileUploadResult(success: false, errorMessage: errorMessage);
//   }
// }

// /// Result model for multiple file uploads
// class MultiFileUploadResult {
//   final List<FileUploadResult>? results;

//   MultiFileUploadResult({this.results});

//   List<FileUploadResult> get _results => results ?? const [];

//   bool get allSuccess => _results.every((r) => r.success == true);

//   int get successCount => _results.where((r) => r.success == true).length;

//   int get failureCount => _results.where((r) => r.success != true).length;

//   List<String> get successUrls => _results
//       .where((r) => r.success == true)
//       .map((r) => r.url)
//       .whereType<String>()
//       .toList();
// }

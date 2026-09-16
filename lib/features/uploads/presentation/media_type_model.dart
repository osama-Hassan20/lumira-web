// import 'dart:typed_data';

// enum MediaTypeEnum {
//   file,
//   network,
// }

// enum MediaCategory {
//   image,
//   video,
//   audio,
//   document,
// }

// class MediaTypeModel {
//   final MediaTypeEnum type;
//   final String path;
//   final MediaCategory category;
//   final String? fileName;
//   final int? fileSize; // in bytes
//   final Uint8List? fileBytes;
//   final String? mimeType;
//   final bool isDeleted;

//   MediaTypeModel({
//     required this.type,
//     required this.path,
//     required this.category,
//     this.fileName,
//     this.fileSize,
//     this.fileBytes,
//     this.mimeType,
//     this.isDeleted = false,
//   });

//   factory MediaTypeModel.fromJson(
//     String path, {
//     required MediaCategory category,
//     String? fileName,
//     int? fileSize,
//   }) {
//     return MediaTypeModel(
//       type: MediaTypeEnum.network,
//       path: path,
//       category: category,
//       fileName: fileName,
//       fileSize: fileSize,
//     );
//   }

//   MediaTypeModel copyWith({
//     MediaTypeEnum? type,
//     String? path,
//     MediaCategory? category,
//     String? fileName,
//     int? fileSize,
//     Uint8List? fileBytes,
//     String? mimeType,
//     bool? isDeleted,
//   }) {
//     return MediaTypeModel(
//       type: type ?? this.type,
//       path: path ?? this.path,
//       category: category ?? this.category,
//       fileName: fileName ?? this.fileName,
//       fileSize: fileSize ?? this.fileSize,
//       fileBytes: fileBytes ?? this.fileBytes,
//       mimeType: mimeType ?? this.mimeType,
//       isDeleted: isDeleted ?? this.isDeleted,
//     );
//   }

//   String get displayName {
//     if (fileName != null) return fileName!;
//     return path.split('/').last;
//   }

//   String get fileSizeFormatted {
//     if (fileSize == null) return '';
//     final kb = fileSize! / 1024;
//     if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
//     final mb = kb / 1024;
//     return '${mb.toStringAsFixed(1)} MB';
//   }

//   bool get isFile => type == MediaTypeEnum.file;
//   bool get isNetwork => type == MediaTypeEnum.network;

//   /// Check if the file is valid (has either path or bytes)
//   bool get isValid => path.isNotEmpty || fileBytes != null;

//   /// Get the file extension from the file name or path
//   String get extension {
//     final name = fileName ?? path;
//     final parts = name.split('.');
//     return parts.length > 1 ? parts.last.toLowerCase() : '';
//   }
// }

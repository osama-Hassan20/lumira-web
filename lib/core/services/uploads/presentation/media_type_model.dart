import 'dart:typed_data';

enum MediaTypeEnum { file, network }

enum MediaCategory { image, video, audio, document }

class MediaTypeModel {
  final MediaTypeEnum type;
  final String path;
  final MediaCategory category;
  final String? filename;
  final int? fileSize; // in bytes
  final Uint8List? fileBytes;
  final String? mimeType;
  final bool isDeleted;

  MediaTypeModel({
    required this.type,
    required this.path,
    required this.category,
    this.filename,
    this.fileSize,
    this.fileBytes,
    this.mimeType,
    this.isDeleted = false,
  });

  factory MediaTypeModel.fromJson(
    String path, {
    required MediaCategory category,
    String? filename,
    int? fileSize,
  }) {
    return MediaTypeModel(
      type: MediaTypeEnum.network,
      path: path,
      category: category,
      filename: filename,
      fileSize: fileSize,
    );
  }

  MediaTypeModel copyWith({
    MediaTypeEnum? type,
    String? path,
    MediaCategory? category,
    String? filename,
    int? fileSize,
    Uint8List? fileBytes,
    String? mimeType,
    bool? isDeleted,
  }) {
    return MediaTypeModel(
      type: type ?? this.type,
      path: path ?? this.path,
      category: category ?? this.category,
      filename: filename ?? this.filename,
      fileSize: fileSize ?? this.fileSize,
      fileBytes: fileBytes ?? this.fileBytes,
      mimeType: mimeType ?? this.mimeType,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  String get displayName {
    if (filename != null) return filename!;
    return path.split('/').last;
  }

  String get fileSizeFormatted {
    if (fileSize == null) return '';
    final kb = fileSize! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  bool get isFile => type == MediaTypeEnum.file;
  bool get isNetwork => type == MediaTypeEnum.network;

  /// Check if the file is valid (has either path or bytes)
  bool get isValid => path.isNotEmpty || fileBytes != null;

  /// Get the file extension from the file name or path
  String get extension {
    final name = filename ?? path;
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }
}

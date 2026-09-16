import '../../config/app_config.dart';

abstract class EndPoints {
  //?======================== BASE URL ========================
  static String baseUrl = "${AppConfig.baseUrl}api/";

  //?======================== MEDIA URLs ========================
  static String baseImageUrl = "${AppConfig.baseUrl}uploads/";
  // static String baseVideoUrl = "${AppConfig.baseUrl}uploads/videos/";
  // static String baseIconUrl = "${AppConfig.baseUrl}uploads/icons/";
  // static String baseDocumentUrl = "${AppConfig.baseUrl}uploads/documents/";

  //?======================== Uploads ========================
  static const String uploadImage = 'uploads/image'; // Upload single image
  static const String uploadImages = 'uploads/images'; // Upload multiple images
  static const String uploadDocument = 'upload/document'; // Upload document
  static const String uploadVideo = 'uploads/file'; // Upload video
  static const String uploadAny = 'upload/any'; // Upload any file type

  // Delete endpoints
  static const String deleteFile = 'upload/{filename}'; // Delete file
  static const String deleteBatch = 'upload/batch'; // Delete multiple files

  //?======================== AUTH ========================
  static const String login = 'auth/login/dash';
  static const String refreshToken = 'auth/refresh-token';
  static const String resetPassword = 'auth/reset-password';
}

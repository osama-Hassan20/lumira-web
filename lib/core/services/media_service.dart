import 'package:file_picker/file_picker.dart';

class MediaService {
  // final AudioRecorder _recorder = AudioRecorder();

  /// اختيار أي ملفات (صور، فيديو، مستندات)
  Future<List<PlatformFile>> pickFiles({
    FileType type = FileType.any,
    bool allowMultiple = false, // Ignored in single pick
    List<String>? allowedExtensions,
  }) async {
    PlatformFile? result = await FilePicker.pickFile(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    return result != null ? [result] : [];
  }

  /// تسجيل صوت وتحويله لـ PlatformFile ليتناسب مع ميثود الرفع الموحدة
  // Future<PlatformFile?> stopRecordingAndGetFile() async {
  //   final path = await _recorder.stop();
  //   if (path == null) return null;
  //   final file = File(path);
  //   return PlatformFile(
  //     name: 'voice_record.m4a',
  //     path: path,
  //     size: await file.length(),
  //     bytes: await file.readAsBytes(),
  //   );
  // }

  // Future<void> startRecording() async => await _recorder.start(const RecordConfig(), path: '');
  // ملاحظة: اترك المسار فارغاً في record ليقوم هو بتوليد مسار مؤقت تلقائياً
}

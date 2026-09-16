// import 'package:dartz/dartz.dart';

// import '../../../core/errors/failures.dart';
// import '../../../core/uses cases/use_cases.dart';
// import '../presentation/media_type_model.dart';
// import '../repo/file_upload_repo.dart';

// /// Parameters for uploading multiple files
// class UploadMultipleFilesParams {
//   final List<MediaTypeModel> files;
//   final int maxWidth;
//   final int quality;

//   UploadMultipleFilesParams({
//     required this.files,
//     this.maxWidth = 1024,
//     this.quality = 60,
//   });
// }

// class UploadMultipleFilesUseCase
//     implements UseCase<List<MediaTypeModel>, UploadMultipleFilesParams> {
//   final FileUploadRepo fileUploadRepo;

//   UploadMultipleFilesUseCase({required this.fileUploadRepo});

//   @override
//   Future<Either<Failures, List<MediaTypeModel>>> call(
//     UploadMultipleFilesParams params,
//   ) async {
//     return await fileUploadRepo.uploadMultipleFiles(
//       params.files,
//       maxWidth: params.maxWidth,
//       quality: params.quality,
//     );
//   }
// }

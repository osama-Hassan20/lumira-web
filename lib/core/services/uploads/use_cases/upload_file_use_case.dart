// import 'package:dartz/dartz.dart';
// import '../../../errors/failures.dart';
// import '../../../uses cases/use_cases.dart';
// import '../presentation/media_type_model.dart';
// import '../repo/file_upload_repo.dart';

// /// Parameters for uploading a file
// class UploadFileParams {
//   final MediaTypeModel file;
//   final int maxWidth;
//   final int quality;

//   UploadFileParams({
//     required this.file,
//     this.maxWidth = 1920,
//     this.quality = 85,
//   });
// }

// class UploadFileUseCase implements UseCase<MediaTypeModel, UploadFileParams> {
//   final FileUploadRepo fileUploadRepo;

//   UploadFileUseCase({required this.fileUploadRepo});

//   @override
//   Future<Either<Failures, MediaTypeModel>> call(UploadFileParams params) async {
//     return await fileUploadRepo.uploadFile(
//       params.file,
//       maxWidth: params.maxWidth,
//       quality: params.quality,
//     );
//   }
// }

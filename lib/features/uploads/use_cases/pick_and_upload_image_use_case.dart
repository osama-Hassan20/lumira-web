// import 'package:beit_alnakha_admin/core/errors/failures.dart';
// import 'package:beit_alnakha_admin/features/uploads/models/file_upload_model.dart';
// import 'package:beit_alnakha_admin/features/uploads/repo/file_upload_repo.dart';
// import 'package:beit_alnakha_admin/core/use_case/use_case.dart';
// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';

// /// Parameters for picking and uploading an image
// class PickAndUploadImageParams {
//   final int maxWidth;
//   final int quality;

//   PickAndUploadImageParams({
//     this.maxWidth = 1024,
//     this.quality = 60,
//   });
// }

// @LazySingleton()
// class PickAndUploadImageUseCase
//     implements UseCase<FileUploadResult, PickAndUploadImageParams> {
//   final FileUploadRepo fileUploadRepo;

//   PickAndUploadImageUseCase({required this.fileUploadRepo});

//   @override
//   Future<Either<Failure, FileUploadResult>> call(
//     PickAndUploadImageParams params,
//   ) async {
//     return await fileUploadRepo.pickAndUploadImage(
//       maxWidth: params.maxWidth,
//       quality: params.quality,
//     );
//   }
// }

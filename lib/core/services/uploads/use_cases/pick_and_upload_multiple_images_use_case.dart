// import 'package:beit_alnakha_admin/core/errors/failures.dart';
// import 'package:beit_alnakha_admin/features/uploads/models/file_upload_model.dart';
// import 'package:beit_alnakha_admin/features/uploads/repo/file_upload_repo.dart';
// import 'package:beit_alnakha_admin/core/use_case/use_case.dart';
// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';

// /// Parameters for picking and uploading multiple images
// class PickAndUploadMultipleImagesParams {
//   final int maxWidth;
//   final int quality;

//   PickAndUploadMultipleImagesParams({
//     this.maxWidth = 1024,
//     this.quality = 60,
//   });
// }

// @LazySingleton()
// class PickAndUploadMultipleImagesUseCase
//     implements UseCase<MultiFileUploadResult, PickAndUploadMultipleImagesParams> {
//   final FileUploadRepo fileUploadRepo;

//   PickAndUploadMultipleImagesUseCase({required this.fileUploadRepo});

//   @override
//   Future<Either<Failure, MultiFileUploadResult>> call(
//     PickAndUploadMultipleImagesParams params,
//   ) async {
//     return await fileUploadRepo.pickAndUploadMultipleImages(
//       maxWidth: params.maxWidth,
//       quality: params.quality,
//     );
//   }
// }

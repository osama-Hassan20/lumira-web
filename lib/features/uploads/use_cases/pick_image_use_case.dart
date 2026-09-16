// import 'package:beit_alnakha_admin/core/errors/failures.dart';
// import 'package:beit_alnakha_admin/features/uploads/presentation/media_type_model.dart';
// import 'package:beit_alnakha_admin/features/uploads/repo/file_upload_repo.dart';
// import 'package:beit_alnakha_admin/core/use_case/use_case.dart';
// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';

// /// Parameters for picking an image
// class PickImageParams {
//   final int maxWidth;
//   final int quality;

//   PickImageParams({
//     this.maxWidth = 1024,
//     this.quality = 60,
//   });
// }

// @LazySingleton()
// class PickImageUseCase implements UseCase<MediaTypeModel, PickImageParams> {
//   final FileUploadRepo fileUploadRepo;

//   PickImageUseCase({required this.fileUploadRepo});

//   @override
//   Future<Either<Failure, MediaTypeModel>> call(PickImageParams params) async {
//     return await fileUploadRepo.pickImage(
//       maxWidth: params.maxWidth,
//       quality: params.quality,
//     );
//   }
// }

// import 'package:beit_alnakha_admin/core/errors/failures.dart';
// import 'package:beit_alnakha_admin/features/uploads/models/file_upload_model.dart';
// import 'package:beit_alnakha_admin/features/uploads/repo/file_upload_repo.dart';
// import 'package:beit_alnakha_admin/core/use_case/use_case.dart';
// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';

// @LazySingleton()
// class PickAndUploadVideoUseCase
//     implements UseCase<FileUploadResult, NoParams> {
//   final FileUploadRepo fileUploadRepo;

//   PickAndUploadVideoUseCase({required this.fileUploadRepo});

//   @override
//   Future<Either<Failure, FileUploadResult>> call(NoParams params) async {
//     return await fileUploadRepo.pickAndUploadVideo();
//   }
// }

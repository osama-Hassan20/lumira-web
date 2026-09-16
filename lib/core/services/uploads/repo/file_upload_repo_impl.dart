// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import '../../../errors/failures.dart';
// import '../data_sources/file_upload_data_source.dart';
// import '../presentation/media_type_model.dart';
// import 'file_upload_repo.dart';

// class FileUploadRepoImpl implements FileUploadRepo {
//   final FileUploadDataSource dataSource;

//   FileUploadRepoImpl({required this.dataSource});

//   @override
//   Future<Either<Failures, MediaTypeModel>> uploadFile(
//     MediaTypeModel file, {
//     int maxWidth = 1920,
//     int quality = 85,
//   }) async {
//     try {
//       final result = await dataSource.uploadFile(
//         file,
//         maxWidth: maxWidth,
//         quality: quality,
//       );

//       if (!(result.success ?? false)) {
//         return Left(
//           ServerFailure(errMessage: result.errorMessage ?? 'Upload failed'),
//         );
//       }

//       // Convert the upload result to a network MediaTypeModel
//       return Right(
//         MediaTypeModel(
//           type: MediaTypeEnum.network,
//           path: result.url!,
//           category: file.category,
//           filename: result.fileName ?? file.filename,
//         ),
//       );
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerFailure.fromDioException(dioException: e));
//       } else {
//         return Left(ServerFailure(errMessage: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failures, List<MediaTypeModel>>> uploadMultipleFiles(
//     List<MediaTypeModel> files, {
//     int maxWidth = 1920,
//     int quality = 85,
//   }) async {
//     try {
//       final result = await dataSource.uploadMultipleFiles(
//         files,
//         maxWidth: maxWidth,
//         quality: quality,
//       );

//       if (!result.allSuccess) {
//         return Left(
//           ServerFailure(
//             errMessage: 'Some files failed to upload: ${result.failureCount}',
//           ),
//         );
//       }

//       // Convert all results to network MediaTypeModels
//       final networkModels = (result.results ?? []).asMap().entries.map((entry) {
//         final uploadResult = entry.value;
//         final originalModel = files[entry.key];
//         return MediaTypeModel(
//           type: MediaTypeEnum.network,
//           path: uploadResult.url!,
//           category: originalModel.category,
//           filename: uploadResult.fileName ?? originalModel.filename,
//         );
//       }).toList();

//       return Right(networkModels);
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerFailure.fromDioException(dioException: e));
//       } else {
//         return Left(ServerFailure(errMessage: e.toString()));
//       }
//     }
//   }
// }

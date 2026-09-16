// import '../api/api_consumer.dart';
// import '../api/end_points.dart';
// import '../models/query_param_model.dart';
// import '../models/reference_data_model.dart';

// class GetSpecialtiesUseCase {
//   final ApiConsumer apiConsumer;

//   GetSpecialtiesUseCase(this.apiConsumer);

//   Future<List<ReferenceDataModel>> call({QueryParamModel? params}) async {
//     final response = await apiConsumer.get(
//       path: EndPoints.specialties,
//       queryParameters: params?.toQueryParameters(),
//     );
//     return (response as List)
//         .map((e) => ReferenceDataModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }
// }

// **************************************eslam***************************************
// class PaginationResult {
//   final num? currentPage;
//   final num? limit;
//   final num? numberOfPages;
//   PaginationResult({this.currentPage, this.limit, this.numberOfPages});
//   factory PaginationResult.fromJson(Map<String, dynamic> json) {
//     return PaginationResult(
//       currentPage: json['currentPage'] as num?,
//       limit: json['limit'] as num?,
//       numberOfPages: json['numberOfPages'] as num?,
//     );
//   }
// }

// **************************************Khalid***************************************

class PaginationResultModle {
  final num? count;
  PaginationResultModle({this.count});
  factory PaginationResultModle.fromJson(Map<String, dynamic> json) {
    return PaginationResultModle(count: json['count'] as num?);
  }
}

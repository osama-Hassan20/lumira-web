class ReferenceDataModel {
  final String id;
  final String name;

  const ReferenceDataModel({
    required this.id,
    required this.name,
  });

  factory ReferenceDataModel.fromJson(Map<String, dynamic> json) {
    return ReferenceDataModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

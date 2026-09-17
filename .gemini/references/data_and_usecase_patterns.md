# Data, Models & UseCase Patterns Reference

This reference documents how to structure generic models, dummy data, domain use cases, and repositories for home sections.

---

## 1. Universal Null-Safe Model Rules

To make models resilient across any domain or backend API:
1. **All fields MUST be nullable (`Type?`)**: Never assume the backend will return non-null values.
2. **NO `required` constructor parameters**: Every parameter in the constructor should be optional.
3. **Use `num?` for numbers**: Supports both `int` and `double` seamlessly from JSON.
4. **Safe Parsing in `fromJson`**:
   - Handle `json == null` safely.
   - Use `.toString()` for IDs and strings.
   - Parse numbers without force unwrapping (`(json['rating'] as num?)`).
5. **Conditional serialization in `toJson`**:
   - Use `if (field != null) 'key': field` to avoid sending unnecessary `null` values over the wire.
6. **Equatable Integration**: Include all fields in `props`.

### Generic Model Template
```dart
import 'package:equatable/equatable.dart';

class {Feature}Model extends Equatable {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final num? price;
  final num? rating;
  final Map<String, dynamic>? extra;

  const {Feature}Model({
    this.id,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.price,
    this.rating,
    this.extra,
  });

  factory {Feature}Model.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const {Feature}Model();
    return {Feature}Model(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? json['name'],
      subtitle: json['subtitle'] ?? json['description'],
      imageUrl: json['image'] ?? json['imageUrl'] ?? json['avatar'],
      price: json['price'],
      rating: json['rating'] as num?,
      extra: json['extra'] is Map<String, dynamic> ? json['extra'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (imageUrl != null) 'image': imageUrl,
      if (price != null) 'price': price,
      if (rating != null) 'rating': rating,
      if (extra != null) 'extra': extra,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        imageUrl,
        price,
        rating,
        extra,
      ];
}
```

---

## 2. Dummy Data Strategy (Prototyping Mode)

When building UI sections before backend endpoints are ready, create a mock data file or static list:

```dart
class Mock{Feature}Data {
  static const List<{Feature}Model> dummyList = [
    {Feature}Model(
      id: '1',
      title: 'عنصر تجريبي أول',
      subtitle: 'تفاصيل تجريبية',
      price: 150,
      rating: 4.8,
    ),
    {Feature}Model(
      id: '2',
      title: 'عنصر تجريبي ثاني',
      subtitle: 'تفاصيل تجريبية',
      price: 200,
      rating: 4.9,
    ),
  ];
}
```

### In Cubit:
```dart
Future<void> get{Section}() async {
  emit(state.copyWith({section}Status: RequestStatusEnum.loading));
  
  // Simulate network latency for smooth shimmer verification
  await Future.delayed(const Duration(milliseconds: 500));

  emit(
    state.copyWith(
      {section}Status: Mock{Feature}Data.dummyList.isEmpty
          ? RequestStatusEnum.empty
          : RequestStatusEnum.success,
      {section}List: Mock{Feature}Data.dummyList,
    ),
  );
}
```

---

## 3. Real API Strategy (Clean Architecture)

### 3.1 Repository Contract (`domain/repo/{feature}_repo.dart`)
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/uses_cases/params.dart';
import '../../data/models/{feature}_model.dart';

abstract class {Feature}Repo {
  Future<Either<Failures, List<{Feature}Model>>> get{Feature}s({
    PaginationParams? params,
  });
}
```

### 3.2 Repository Implementation (`data/repo/{feature}_repo_impl.dart`)
```dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/uses_cases/params.dart';
import '../../domain/repo/{feature}_repo.dart';
import '../models/{feature}_model.dart';

class {Feature}RepoImpl implements {Feature}Repo {
  final ApiConsumer apiConsumer;

  {Feature}RepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failures, List<{Feature}Model>>> get{Feature}s({
    PaginationParams? params,
  }) async {
    try {
      final response = await apiConsumer.get(
        path: EndPoints.{feature}Endpoint,
        queryParameters: params?.toJson(),
      );

      final dynamic dataNode = response['data']?['items'] ?? response['data'];
      final List<dynamic> itemsList = dataNode is List ? dataNode : [];

      final items = itemsList
          .map((item) => {Feature}Model.fromJson(item as Map<String, dynamic>?))
          .toList();

      return right(items);
    } on DioException catch (error) {
      return left(ServerFailure.fromDioException(dioException: error));
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      return left(ServerFailure(errMessage: error.toString()));
    }
  }
}
```

### 3.3 Use Case (`domain/use_cases/get_{feature}_use_case.dart`)
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/uses_cases/params.dart';
import '../../../../core/uses_cases/use_cases.dart';
import '../models/{feature}_model.dart';
import '../repo/{feature}_repo.dart';

class Get{Feature}UseCase extends UseCase<List<{Feature}Model>, PaginationParams?> {
  final {Feature}Repo repo;

  Get{Feature}UseCase(this.repo);

  @override
  Future<Either<Failures, List<{Feature}Model>>> call(PaginationParams? params) {
    return repo.get{Feature}s(params: params);
  }
}
```

### 3.4 Dependency Injection Setup (`lib/core/dependency_injection/dependency_injection.dart`)
```dart
// Repositories
getIt.registerLazySingleton<{Feature}Repo>(
  () => {Feature}RepoImpl(apiConsumer: getIt<ApiConsumer>()),
);

// Use Cases
getIt.registerLazySingleton<Get{Feature}UseCase>(
  () => Get{Feature}UseCase(getIt<{Feature}Repo>()),
);
```

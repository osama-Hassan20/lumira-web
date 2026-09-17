# Example: Adding an API-Driven Section ("{Section}")

This blueprint demonstrates how to add any generic, reusable section connected to a real API endpoint through Clean Architecture. Replace `{Section}` (PascalCase) and `{section}` (camelCase) with your feature name.

> **Rule**: All model fields are nullable (`Type?`, using `num?` for numbers) with NO `required` constructor parameters to guarantee null safety regardless of backend variations.

---

## 1. Generic Model
File: `lib/{layout}/home/data/models/{section}_model.dart`
```dart
import 'package:equatable/equatable.dart';

class {Section}Model extends Equatable {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final num? price;
  final num? rating;
  final Map<String, dynamic>? extra;

  const {Section}Model({
    this.id,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.price,
    this.rating,
    this.extra,
  });

  factory {Section}Model.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const {Section}Model();
    return {Section}Model(
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

## 2. Generic Domain Repository & Use Case
File: `lib/{layout}/home/domain/repo/{section}_repo.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/uses_cases/params.dart';
import '../data/models/{section}_model.dart';

abstract class {Section}Repo {
  Future<Either<Failures, List<{Section}Model>>> get{Section}s({
    PaginationParams? params,
  });
}
```

File: `lib/{layout}/home/domain/use_cases/get_{section}_use_case.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/uses_cases/params.dart';
import '../../../../core/uses_cases/use_cases.dart';
import '../data/models/{section}_model.dart';
import '../repo/{section}_repo.dart';

class Get{Section}UseCase extends UseCase<List<{Section}Model>, PaginationParams?> {
  final {Section}Repo repo;

  Get{Section}UseCase(this.repo);

  @override
  Future<Either<Failures, List<{Section}Model>>> call(PaginationParams? params) {
    return repo.get{Section}s(params: params);
  }
}
```

---

## 3. Generic Data Repository Implementation
File: `lib/{layout}/home/data/repo/{section}_repo_impl.dart`
```dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/uses_cases/params.dart';
import '../../domain/repo/{section}_repo.dart';
import '../models/{section}_model.dart';

class {Section}RepoImpl implements {Section}Repo {
  final ApiConsumer apiConsumer;

  {Section}RepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failures, List<{Section}Model>>> get{Section}s({
    PaginationParams? params,
  }) async {
    try {
      final response = await apiConsumer.get(
        path: EndPoints.{section}s,
        queryParameters: params?.toJson(),
      );

      final dynamic dataNode = response['data']?['items'] ?? response['data'];
      final List<dynamic> itemsList = dataNode is List ? dataNode : [];

      final items = itemsList
          .map((e) => {Section}Model.fromJson(e as Map<String, dynamic>?))
          .toList();

      return right(items);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioException(dioException: e));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
```

---

## 4. Register in Dependency Injection
File: `lib/core/dependency_injection/dependency_injection.dart`
```dart
// Register Repository
getIt.registerLazySingleton<{Section}Repo>(
  () => {Section}RepoImpl(apiConsumer: getIt<ApiConsumer>()),
);

// Register Use Case
getIt.registerLazySingleton<Get{Section}UseCase>(
  () => Get{Section}UseCase(getIt<{Section}Repo>()),
);
```

---

## 5. Wire into Cubit & State

### State (`home_state.dart`):
```dart
class HomeState extends Equatable {
  final RequestStatusEnum {section}Status;
  final List<{Section}Model> {section}List;
  final String? errMessage;

  const HomeState({
    this.{section}Status = RequestStatusEnum.initial,
    this.{section}List = const [],
    this.errMessage,
  });

  HomeState copyWith({
    RequestStatusEnum? {section}Status,
    List<{Section}Model>? {section}List,
    String? errMessage,
  }) {
    return HomeState(
      {section}Status: {section}Status ?? this.{section}Status,
      {section}List: {section}List ?? this.{section}List,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  @override
  List<Object?> get props => [{section}Status, {section}List, errMessage];
}
```

### Cubit (`home_cubit.dart`):
```dart
class HomeCubit extends SafeCubit<HomeState> {
  final Get{Section}UseCase get{Section}UseCase;

  HomeCubit({required this.get{Section}UseCase}) : super(const HomeState());

  Future<void> get{Section}() async {
    emit(state.copyWith({section}Status: RequestStatusEnum.loading));

    final result = await get{Section}UseCase(
      const PaginationParams(page: 1, limit: 10),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          {section}Status: RequestStatusEnum.failure,
          errMessage: failure.errMessage,
        ),
      ),
      (data) => emit(
        state.copyWith(
          {section}Status: data.isEmpty
              ? RequestStatusEnum.empty
              : RequestStatusEnum.success,
          {section}List: data,
        ),
      ),
    );
  }

  Future<void> loadHomeData() async {
    await Future.wait([
      get{Section}(),
      // other section fetch methods...
    ]);
  }
}
```

---

## 6. Sliver UI Presentation

```dart
BlocBuilder<HomeCubit, HomeState>(
  buildWhen: (previous, current) =>
      previous.{section}Status != current.{section}Status ||
      previous.{section}List != current.{section}List,
  builder: (context, state) {
    if (state.{section}Status == RequestStatusEnum.loading) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: IndividualShimmerRow(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => const CustomShimmerContainer(
                  width: 150,
                  height: 180,
                  borderRadius: 12,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (state.{section}Status == RequestStatusEnum.failure) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ErrorPage(
            errorMessage: state.errMessage ?? "",
            onPressed: () => context.read<HomeCubit>().get{Section}(),
          ),
        ),
      );
    } else if (state.{section}Status == RequestStatusEnum.empty ||
        state.{section}List.isEmpty) {
      return const SizedBox.shrink().toSliver();
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: SectionHeaderWithAction(
              title: '{عنوان القسم}',
              onPressed: () {
                // Navigate to full list
              },
            ),
          ),
        ),
        const SizedBox(height: 12).toSliver(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.{section}List.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = state.{section}List[index];
                return {Section}Card(item: item);
              },
            ),
          ),
        ),
      ],
    );
  },
),
const SizedBox(height: 24).toSliver(),
```

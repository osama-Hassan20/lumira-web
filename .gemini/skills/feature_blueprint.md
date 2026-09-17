# Feature Blueprint Skill

> When building a new admin feature, follow these patterns exactly.
> Two reference features exist: **admin_support** (CRUD + scroll pagination) and **admin_orders** (read-only + table pagination + search + filters).

---

## 1. Folder Structure

```
features/admin_{name}/
├── data/
│   ├── models/
│   │   └── admin_{name}_model.dart
│   └── repo/
│       └── admin_{name}_repo_impl.dart
├── domain/
│   ├── repo/
│   │   └── admin_{name}_repo.dart
│   └── use_cases/
│       └── admin_{name}_use_cases.dart
└── presentation/
    ├── manager/
    │   ├── admin_{name}_cubit.dart
    │   └── admin_{name}_state.dart
    ├── pages/
    │   └── admin_{name}_page.dart
    └── widgets/
        ├── add_edit_{name}.dart        # (if CRUD)
        └── {name}_actions_menu.dart    # (if has actions)
```

---

## 2. Domain Layer — Repository (Abstract)

File: `domain/repo/admin_{name}_repo.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/uses_cases/params.dart';
import '../../data/models/admin_{name}_model.dart';

abstract class Admin{Name}Repo {
  // GET ALL — always uses PaginationParams
  Future<Either<Failures, List<Admin{Name}Model>>> getAll{Name}s({
    required PaginationParams params,
  });

  // GET BY ID
  Future<Either<Failures, Admin{Name}Model>> get{Name}ById({
    required String id,
  });

  // CREATE — takes the model
  Future<Either<Failures, Admin{Name}Model>> create{Name}({
    required Admin{Name}Model data,
  });

  // UPDATE — takes the model
  Future<Either<Failures, Admin{Name}Model>> update{Name}({
    required Admin{Name}Model data,
  });

  // DELETE — takes id, returns message string
  Future<Either<Failures, String>> delete{Name}({required String id});
}
```

**Key rules:**
- Named parameters with `required`
- Return `Either<Failures, T>` always
- Delete returns `String` (success message)

---

## 3. Data Layer — Repository Implementation

File: `data/repo/admin_{name}_repo_impl.dart`

```dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/api/api_consumer.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/uses_cases/params.dart';
import '../../domain/repo/admin_{name}_repo.dart';
import '../models/admin_{name}_model.dart';

class Admin{Name}RepoImpl implements Admin{Name}Repo {
  final ApiConsumer apiConsumer;

  Admin{Name}RepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failures, List<Admin{Name}Model>>> getAll{Name}s({
    required PaginationParams params,
  }) async {
    try {
      final result = await apiConsumer.get(
        path: EndPoints.admin{Name}s,
        queryParameters: params.toJson(),
      );
      return right(
        (result['data']['items'] as List<dynamic>)
            .map((x) => Admin{Name}Model.fromJson(x))
            .toList(),
      );
    } on DioException catch (error) {
      return left(ServerFailure.fromDioException(dioException: error));
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      return left(ServerFailure(errMessage: error.toString()));
    }
  }

  // Same try/catch pattern for all other methods:
  // - DioException catch → ServerFailure.fromDioException
  // - generic catch → log stackTrace + ServerFailure

  @override
  Future<Either<Failures, String>> delete{Name}({required String id}) async {
    try {
      final result = await apiConsumer.delete(
        path: "${EndPoints.admin{Name}s}/$id",
      );
      return right(result['message'] ?? "{Name} deleted successfully");
    } on DioException catch (error) {
      return left(ServerFailure.fromDioException(dioException: error));
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      return left(ServerFailure(errMessage: error.toString()));
    }
  }
}
```

---

## 4. Domain Layer — Use Cases

File: `domain/use_cases/admin_{name}_use_cases.dart`

All use cases in **one file**. Each implements `UseCase<ReturnType, ParamType>`.

```dart
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/uses_cases/params.dart';
import '../../../../../core/uses_cases/use_cases.dart';
import '../../data/models/admin_{name}_model.dart';
import '../repo/admin_{name}_repo.dart';

// GET ALL
class GetAllAdmin{Name}sUseCase
    implements UseCase<List<Admin{Name}Model>, PaginationParams> {
  final Admin{Name}Repo repo;
  GetAllAdmin{Name}sUseCase({required this.repo});

  @override
  Future<Either<Failures, List<Admin{Name}Model>>> call(
    PaginationParams params,
  ) async {
    return await repo.getAll{Name}s(params: params);
  }
}

// GET BY ID — UseCase<Model, String>
class GetAdmin{Name}ByIdUseCase implements UseCase<Admin{Name}Model, String> {
  final Admin{Name}Repo repo;
  GetAdmin{Name}ByIdUseCase({required this.repo});

  @override
  Future<Either<Failures, Admin{Name}Model>> call(String id) async {
    return await repo.get{Name}ById(id: id);
  }
}

// CREATE — UseCase<Model, Model>
class CreateAdmin{Name}UseCase
    implements UseCase<Admin{Name}Model, Admin{Name}Model> {
  final Admin{Name}Repo repo;
  CreateAdmin{Name}UseCase({required this.repo});

  @override
  Future<Either<Failures, Admin{Name}Model>> call(Admin{Name}Model data) async {
    return await repo.create{Name}(data: data);
  }
}

// UPDATE — UseCase<Model, Model>
// DELETE — UseCase<String, String>
// Same pattern as above.
```

**Param types:**
- `PaginationParams` for list calls
- `NoParams` for no-argument calls
- `String` for by-id / delete
- `Model` for create/update

---

## 5. State Class

File: `presentation/manager/admin_{name}_state.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enums/request_status_enum.dart';
import '../../data/models/admin_{name}_model.dart';

class Admin{Name}State extends Equatable {
  // One RequestStatusEnum per independent async operation
  final RequestStatusEnum getAllStatus;       // fetch list
  final RequestStatusEnum createOrUpdateStatus; // add/edit (shared)
  final RequestStatusEnum deleteStatus;      // delete
  final String? errMessage;
  final List<Admin{Name}Model> items;
  // Add extra UI state (isActive toggle, selected filters, etc.)

  const Admin{Name}State({
    this.getAllStatus = RequestStatusEnum.initial,
    this.createOrUpdateStatus = RequestStatusEnum.initial,
    this.deleteStatus = RequestStatusEnum.initial,
    this.errMessage,
    this.items = const [],
  });

  Admin{Name}State copyWith({ /* all fields nullable */ }) {
    return Admin{Name}State(/* merge with ?? */);
  }

  @override
  List<Object?> get props => [/* all fields */];
}
```

**Rules:**
- `const` constructor, `const []` default for lists
- Extends `Equatable`, list all fields in `props`
- Create & Update share **one** status field (`createOrUpdateStatus`)
- `errMessage` is shared across operations

---

## 6. Cubit — Two Pagination Approaches

### 6A. Scroll-based Infinite Pagination (admin_support pattern)

Use `PaginationMixin` — for grid/list views with scroll controller.

```dart
class Admin{Name}Cubit extends SafeCubit<Admin{Name}State>
    with PaginationMixin {
  final GetAllAdmin{Name}sUseCase getAllUseCase;
  final CreateAdmin{Name}UseCase createUseCase;
  final UpdateAdmin{Name}UseCase updateUseCase;
  final DeleteAdmin{Name}UseCase deleteUseCase;

  Admin{Name}Cubit({required this.getAllUseCase, ...})
      : super(const Admin{Name}State());

  List<Admin{Name}Model> allItems = []; // local cache
  Admin{Name}Model addOrUpdate = Admin{Name}Model(); // form buffer

  void addListener() {
    addPaginationListener(
      getMore,
      isLoadingGetter: () =>
          state.getAllStatus == RequestStatusEnum.loading ||
          state.getAllStatus == RequestStatusEnum.loadingMore,
    );
  }

  // INITIAL FETCH
  Future<void> getAll() async {
    emit(state.copyWith(getAllStatus: RequestStatusEnum.loading));
    final result = await getAllUseCase(
      PaginationParams(page: currentPage, limit: limit),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        getAllStatus: RequestStatusEnum.failure,
        errMessage: failure.errMessage,
      )),
      (data) {
        hasReachedMax = data.length < limit;
        allItems = data;
        currentPage = 2;
        emit(state.copyWith(
          getAllStatus: RequestStatusEnum.success,
          items: data,
        ));
      },
    );
  }

  // LOAD MORE
  Future<void> getMore() async {
    if (state.getAllStatus == RequestStatusEnum.loadingMore ||
        hasReachedMax || state.items.isEmpty) return;

    emit(state.copyWith(getAllStatus: RequestStatusEnum.loadingMore));
    final result = await getAllUseCase(
      PaginationParams(page: currentPage, limit: limit),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        getAllStatus: RequestStatusEnum.failureMore,
        errMessage: failure.errMessage,
      )),
      (newItems) {
        hasReachedMax = newItems.length < limit;
        allItems.addAll(newItems);
        currentPage++;
        emit(state.copyWith(
          getAllStatus: RequestStatusEnum.successMore,
          items: allItems,
        ));
      },
    );
  }

  // CREATE — insert at index 0, emit new list
  // UPDATE — map & replace matching id, emit new list
  // DELETE — removeWhere by id, emit new list

  @override
  Future<void> close() {
    disposePagination();
    return super.close();
  }
}
```

### 6B. Table Pagination with Search & Filters (admin_orders pattern)

Use `SearchMixin` — for table views with page numbers.

```dart
class Admin{Name}Cubit extends SafeCubit<Admin{Name}State>
    with SearchMixin {
  final GetAllAdmin{Name}sUseCase getAllUseCase;

  Admin{Name}Cubit({required this.getAllUseCase, ...})
      : super(const Admin{Name}State());

  PaginationParams paginationParams = PaginationParams(page: 1, limit: 10);

  void addListener() {
    addSearchListener(() {
      getAll();
    });
  }

  Future<void> getAll() async {
    // Build filters from state + searchQuery
    paginationParams = paginationParams.copyWith(
      filterList: [
        if (searchQuery.isNotEmpty)
          FilterParam(key: 'search', value: searchQuery.trim()),
        if (state.selectedStatus != StatusEnum.all)
          FilterParam(key: 'status', value: state.selectedStatus.value),
      ],
    );
    emit(state.copyWith(status: RequestStatusEnum.loading));
    final result = await getAllUseCase(paginationParams);
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatusEnum.failure,
        errMessage: failure.errMessage,
      )),
      (data) => emit(state.copyWith(
        status: RequestStatusEnum.success,
        items: data.data,
      )),
    );
  }

  void changePage(int page) {
    paginationParams = paginationParams.copyWith(page: page);
    getAll();
  }

  void changeStatus(StatusEnum status) {
    emit(state.copyWith(selectedStatus: status));
    getAll();
  }

  @override
  Future<void> close() {
    disposeSearch();
    return super.close();
  }
}
```

---

## 7. Page — UI State Handling

### 7A. Scroll Pagination Page (admin_support)

```dart
class Admin{Name}Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<Admin{Name}Cubit>()
        ..getAll()
        ..addListener(),
      child: Column(
        children: [
          // Header row with Add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Title"),
              Builder(builder: (context) {
                return CustomPushButton(
                  onTap: () {
                    final cubit = context.read<Admin{Name}Cubit>();
                    showDialog(
                      context: context,
                      builder: (_) => AddEdit{Name}(cubit: cubit),
                    );
                  },
                  child: Text("Add"),
                );
              }),
            ],
          ),
          // Content with state handling
          Expanded(
            child: BlocBuilder<Admin{Name}Cubit, Admin{Name}State>(
              buildWhen: (p, c) => p.getAllStatus != c.getAllStatus,
              builder: (context, state) {
                if (state.getAllStatus == RequestStatusEnum.loading)
                  return ShimmerGrid();
                if (state.getAllStatus == RequestStatusEnum.failure)
                  return ErrorPage(
                    errorMessage: state.errMessage ?? "",
                    onPressed: () => context.read<Admin{Name}Cubit>().getAll(),
                  );
                if (state.getAllStatus == RequestStatusEnum.empty)
                  return CustomEmptyWidget();
                return GridView.builder(/* ... */);
              },
            ),
          ),
          // Loading more indicator
          BlocBuilder<Admin{Name}Cubit, Admin{Name}State>(
            buildWhen: (p, c) => p.getAllStatus != c.getAllStatus,
            builder: (context, state) {
              if (state.getAllStatus == RequestStatusEnum.loadingMore)
                return CupertinoActivityIndicator();
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
```

### 7B. Table Pagination Page (admin_orders)

```dart
class Admin{Name}Page extends StatefulWidget { ... }

class _State extends State<Admin{Name}Page> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<Admin{Name}Cubit>()
        ..getAll()
        ..addListener(),
      child: BlocBuilder<Admin{Name}Cubit, Admin{Name}State>(
        builder: (context, state) {
          final cubit = context.read<Admin{Name}Cubit>();
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    FilterSection(),
                    if (state.status == RequestStatusEnum.loading)
                      CustomTableShimmer(headers: [...]).toSliver()
                    else if (state.status == RequestStatusEnum.failure)
                      ErrorPage(onPressed: () => cubit.getAll()).toSliver()
                    else
                      SliverToBoxAdapter(child: DataTable(data: state.items)),
                  ],
                ),
              ),
              if (state.status == RequestStatusEnum.success)
                CustomPaginationTable(
                  onTapNext: () => cubit.changePage(cubit.paginationParams.page! + 1),
                  onTapPrevious: () => cubit.changePage(cubit.paginationParams.page! - 1),
                  onTapNumber: (v) => cubit.changePage(v),
                ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## 8. Actions Menu Widget (Edit / Delete / Status Toggle)

```dart
class {Name}ActionsMenu extends StatelessWidget {
  final Admin{Name}Cubit cubit;
  final Admin{Name}Model? model;

  Widget build(BuildContext context) {
    return CustomPopupMenu(
      items: [
        CustomPopupActionItem(label: "تعديل", onTap: () => _showEdit(context)),
        CustomPopupActionItem(label: "حذف", color: AppColors.red, onTap: () => _showDelete(context)),
      ],
    );
  }

  void _showDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: BlocConsumer<Admin{Name}Cubit, Admin{Name}State>(
          listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
          listener: (context, state) {
            if (state.deleteStatus == RequestStatusEnum.success) {
              CustomToast(context: context, header: "تم الحذف").showTopToast();
              context.pop();
            } else if (state.deleteStatus == RequestStatusEnum.failure) {
              CustomToast(context: context, header: state.errMessage ?? "").showErrorToast();
            }
          },
          builder: (context, state) => CustomFullScreenLoading(
            isLoading: state.deleteStatus == RequestStatusEnum.loading,
            child: CustomDeleteDialog(
              onConfirm: () => cubit.delete(model!.id!),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 9. Add/Edit Dialog Widget

```dart
class AddEdit{Name} extends StatefulWidget {
  final Admin{Name}Cubit cubit;
  final Admin{Name}Model? model; // null = add mode
  // ...
}

class _State extends State<AddEdit{Name}> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    if (widget.model != null) {
      widget.cubit.initForEdit(widget.model!);
      _nameController.text = widget.model!.name ?? "";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Form(
        key: _formKey,
        child: Dialog(
          child: BlocConsumer<Admin{Name}Cubit, Admin{Name}State>(
            listenWhen: (p, c) => p.createOrUpdateStatus != c.createOrUpdateStatus,
            listener: (context, state) {
              if (state.createOrUpdateStatus == RequestStatusEnum.success) {
                CustomToast(context: context, header: "تمت العملية بنجاح").showTopToast();
                context.pop();
              } else if (state.createOrUpdateStatus == RequestStatusEnum.failure) {
                CustomToast(context: context, header: state.errMessage ?? "").showErrorToast();
              }
            },
            builder: (context, state) => CustomFullScreenLoading(
              isLoading: state.createOrUpdateStatus == RequestStatusEnum.loading,
              child: Column(children: [
                // Form fields...
                CustomPushButton(onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  if (widget.model != null)
                    widget.cubit.update(/* ... */);
                  else
                    widget.cubit.create(/* ... */);
                }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 10. Dependency Injection Registration

In `core/di/dependency_injection.dart`:

```dart
// Admin{Name} Feature
// 1. Repo — registerLazySingleton
getIt.registerLazySingleton<Admin{Name}Repo>(
  () => Admin{Name}RepoImpl(apiConsumer: getIt<DioConsumer>()),
);

// 2. Use Cases — registerLazySingleton each
getIt.registerLazySingleton<GetAllAdmin{Name}sUseCase>(
  () => GetAllAdmin{Name}sUseCase(repo: getIt<Admin{Name}Repo>()),
);
// ... repeat for each use case

// 3. Cubit — registerFactory (new instance each time)
getIt.registerFactory<Admin{Name}Cubit>(
  () => Admin{Name}Cubit(
    getAllUseCase: getIt<GetAllAdmin{Name}sUseCase>(),
    createUseCase: getIt<CreateAdmin{Name}UseCase>(),
    // ...
  ),
);
```

**Rules:**
- Repo & UseCases → `registerLazySingleton`
- Cubit → `registerFactory` (fresh per screen)

---

## 11. RequestStatusEnum Values

```
initial → not started
loading → first fetch in progress
success → first fetch done
failure → first fetch failed
empty   → no data
loadingMore → pagination fetch (scroll only)
successMore → pagination done (scroll only)
failureMore → pagination failed (scroll only)
```

---

## 12. Mandatory Value Formatters & Utilities

1. **Date & Time Formatting (`DateTimeExtension`)**:
   - Location: `lib/core/utils/extensions/date_time_extentision.dart`
   - NEVER instantiate raw `DateFormat(...)` in widgets or presentation code.
   - ALWAYS use `DateTimeExtension` on `DateTime?` (`toShortDate`, `toTimeOnly`, `toLongDate`, `toShortDateTime`, `toCustomFormat`).
   - Pass language/locale optionally (`[String? locale]`), e.g. `orderDate.toShortDate(context.locale.languageCode)`.

2. **Price & Unit Price Formatting (`MonyHelper`)**:
   - Location: `lib/core/network/mony_helper.dart`
   - NEVER format prices manually with string interpolation (`$price L.E` or `price.toString()`).
   - ALWAYS use `MonyHelper.formatPrice(amount)` or `MonyHelper.formatUnitPrice(unitPrice, ...)`.

3. **Cubit Pagination (`PaginationMixin`)**:
   - Location: `lib/core/mixins/pagination_mixin.dart`
   - Any Cubit managing infinite-scrolling lists or grids MUST use `with PaginationMixin`.
   - Wire `addPaginationListener` using dynamic `isLoadingGetter: () => ...` to avoid stale state.
   - Call `resetPagination()` on initial load/refresh and `disposePagination()` on Cubit close.

---

## Quick Checklist for New Feature

1. [ ] Create folder structure under `features/admin_{name}/`
2. [ ] Write Model in `data/models/` (all fields nullable `Type?`, no `required` params)
3. [ ] Write abstract Repo in `domain/repo/`
4. [ ] Write Repo Impl in `data/repo/`
5. [ ] Write all Use Cases in `domain/use_cases/` (one file)
6. [ ] Write State class in `presentation/manager/`
7. [ ] Write Cubit with `SafeCubit` and `PaginationMixin` if paginated
8. [ ] Wire `addPaginationListener` with dynamic `isLoadingGetter` and call `disposePagination()` in `close()`
9. [ ] Format any dates/times via `DateTimeExtension` with optional `[locale]` (zero raw `DateFormat` calls)
10. [ ] Format any prices via `MonyHelper.formatPrice()` / `MonyHelper.formatUnitPrice()`
11. [ ] Write Page with state handling (loading/error/empty/success)
12. [ ] Write action widgets (AddEdit dialog, ActionsMenu) if CRUD
13. [ ] Register everything in `core/di/dependency_injection.dart`
14. [ ] Add route in router config

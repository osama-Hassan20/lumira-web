# Cubit & State Patterns Reference

This reference documents the state management architecture used for multi-section home pages (`HomeCubit`, `HomeState`, `SafeCubit`, `PaginationMixin`).

---

## 1. Why Granular Section States?

In a multi-section Home Dashboard, multiple asynchronous requests happen concurrently.

### ❌ Anti-Pattern: Monolithic State
```dart
// BAD: If one request fails or loads, the whole page enters loading or error state
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState { ... }
class HomeError extends HomeState { final String msg; ... }
```

### ✅ Clean Architecture Pattern: Granular Status per Section
```dart
// GOOD: Each section has its own RequestStatusEnum and data list
class HomeState extends Equatable {
  final RequestStatusEnum slidersStatus;
  final RequestStatusEnum categoriesStatus;
  final RequestStatusEnum {section}Status;

  final List<AdminSlidersModel> sliders;
  final List<AdminCategoriesModel> categories;
  final List<{Section}Model> {section}List;
  final String? errMessage;
  // ...
}
```

**Benefits**:
1. If one section fails due to a network error, other sections still display seamlessly.
2. The user can retry loading ONLY the failed section without re-fetching working sections.
3. Shimmer skeletons show only for sections that are actively loading.

---

## 2. SafeCubit Integration

All Cubits in this app extend `SafeCubit<T>` instead of raw `Cubit<T>`.

```dart
import '../../../../core/base/safe_cubit.dart';

class HomeCubit extends SafeCubit<HomeState> with PaginationMixin {
  HomeCubit({
    required this.get{Section}UseCase,
  }) : super(const HomeState());
  // ...
}
```

**Why**: `SafeCubit` overrides `emit` to verify `if (isClosed) return;`, preventing unmounted state emission exceptions when network calls complete after navigation.

---

## 3. RequestStatusEnum Matrix

Located in `lib/core/utils/enums/request_status_enum.dart`:
```dart
enum RequestStatusEnum {
  initial,
  loading,
  success,
  failure,
  empty,
  loadingMore,
  successMore,
  failureMore,
}
```

| Status | Usage in Section | UI Rendered |
| :--- | :--- | :--- |
| `initial` | Before any request starts | Often Shimmer or empty box |
| `loading` | Primary initial load | `CustomShimmerContainer` matching layout |
| `success` | Data returned with items | Content list/grid/carousel |
| `empty` | Data returned with 0 items | `CustomEmptyWidget` or `SizedBox.shrink().toSliver()` |
| `failure` | Exception or Dio error | `ErrorPage` with retry button |
| `loadingMore` | Infinite scroll fetching next page | Bottom loading spinner |
| `successMore` | Next page fetched and appended | Extended list |
| `failureMore` | Next page failed | Toast notification or retry row |

---

## 4. Parallel Loading with `Future.wait`

In `HomeCubit`:
```dart
Future<void> loadHomeData() async {
  await Future.wait([
    getSliders(),
    getCategories(),
    get{Section}(),
  ]);
}
```

**Rule**: Always use `Future.wait([...])` in `loadHomeData()`. Do not sequentially await section requests.

---

## 5. Section Fetch Method Template

```dart
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
```

---

## 6. PaginationMixin (Infinite Scroll Support)

Any Cubit that manages a list, grid, or infinite-scrolling feed MUST mix in `PaginationMixin` (`lib/core/mixins/pagination_mixin.dart`).

```dart
class {Feature}Cubit extends SafeCubit<{Feature}State> with PaginationMixin {
  final Get{Feature}ListUseCase get{Feature}ListUseCase;

  {Feature}Cubit({required this.get{Feature}ListUseCase})
      : super(const {Feature}State()) {
    limit = 20;
  }

  void initListeners() {
    addPaginationListener(
      getMore{Feature}s,
      // Dynamic getter prevents stale closure bugs
      isLoadingGetter: () =>
          state.{feature}Status == RequestStatusEnum.loading ||
          state.{feature}Status == RequestStatusEnum.loadingMore,
      triggerDistance: 250,
    );
  }

  Future<void> get{Feature}s({bool isRefresh = false}) async {
    resetPagination(); // Always reset page to 1 and hasReachedMax to false

    if (!isRefresh) {
      emit(state.copyWith({feature}Status: RequestStatusEnum.loading));
    }

    final result = await get{Feature}ListUseCase(
      PaginationParams(page: currentPage, limit: limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        {feature}Status: RequestStatusEnum.failure,
        errMessage: failure.errMessage,
      )),
      (items) {
        hasReachedMax = items.length < limit;
        currentPage = 2;
        emit(state.copyWith(
          {feature}Status: items.isEmpty
              ? RequestStatusEnum.empty
              : RequestStatusEnum.success,
          {feature}List: items,
        ));
      },
    );
  }

  Future<void> getMore{Feature}s() async {
    if (state.{feature}Status == RequestStatusEnum.loadingMore ||
        hasReachedMax ||
        state.{feature}List.isEmpty) {
      return;
    }

    emit(state.copyWith({feature}Status: RequestStatusEnum.loadingMore));

    final result = await get{Feature}ListUseCase(
      PaginationParams(page: currentPage, limit: limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        {feature}Status: RequestStatusEnum.failureMore,
        errMessage: failure.errMessage,
      )),
      (newItems) {
        hasReachedMax = newItems.length < limit;
        currentPage++;
        final updatedList = List<{Feature}Model>.from(state.{feature}List)
          ..addAll(newItems);
        emit(state.copyWith(
          {feature}Status: RequestStatusEnum.successMore,
          {feature}List: updatedList,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    disposePagination(); // Clean up listener and controller
    return super.close();
  }
}
```

---

## 7. Mandatory Shared Value Formatters

When building presentation widgets, cards, or section details:

1. **Date & Time Formatting**:
   - MUST use `DateTimeExtension` from `lib/core/utils/extensions/date_time_extentision.dart`.
   - Never instantiate raw `DateFormat(...)` in UI.
   - Accepts optional `[String? locale]`:
     - `date.toShortDate([locale])`
     - `date.toTimeOnly([locale])`
     - `date.toLongDate([locale])`
     - `date.toShortDateTime([locale])`

2. **Price & Unit Price Formatting**:
   - MUST use `MonyHelper` from `lib/core/network/mony_helper.dart`.
   - Never format prices using string interpolation (`$price L.E`).
   - Use `MonyHelper.formatPrice(amount)` or `MonyHelper.formatUnitPrice(unitPrice, ...)`.


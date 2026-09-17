# Formatting & Utility Architecture Rules

This reference documents the mandatory architectural standards for **Date/Time formatting**, **Price formatting**, and **Cubit Pagination** across the application.

---

## 1. Centralized Date & Time Formatting (`DateTimeExtension`)

### ❌ Anti-Pattern: Ad-Hoc DateFormat in Widgets
```dart
// BAD: Duplicating DateFormat directly inside UI widgets/presentation layer
Text(DateFormat('EEE, MMM d, yyyy', langCode).format(dateTime))
Text(DateFormat('h:mm a', langCode).format(dateTime))
Text(DateFormat('EEEE، d MMMM yyyy', langCode).format(dateTime))
```
- **Why this is bad**: Fragmented date formatting leads to inconsistent UX, missing null safety, duplicated intl instances, and high refactoring cost when changing localization or date patterns across the app.

### ✅ Clean Pattern: Centralized `DateTimeExtension`
Location: `lib/core/utils/extensions/date_time_extentision.dart`

```dart
import 'package:inservice/core/utils/extensions/date_time_extentision.dart';

// Short date (e.g. "Wed, Sep 16, 2026")
date.toShortDate(context.locale.languageCode);

// Time only (e.g. "10:00 AM")
date.toTimeOnly(context.locale.languageCode);

// Full localized date (e.g. "الأربعاء، 16 سبتمبر 2026")
date.toLongDate(context.locale.languageCode);

// Date with time (e.g. "16 Sep, 10:00 AM")
date.toShortDateTime(context.locale.languageCode);

// Standard date format (default: 'yyyy/MM/dd', en)
date.toCustomFormat(context.locale.languageCode);

// Standard date with time (default: 'yyyy/MM/dd - hh:mm a', ar)
date.toCustomFormatWithTime(context.locale.languageCode);
```

### Golden Rules:
1. **Never import `intl` in feature UI** just to format dates or times. Always import and use `DateTimeExtension`.
2. **Optional Locale Parameter**: Every method in `DateTimeExtension` accepts an optional `[String? locale]`. If omitted, standard defaults apply.
3. **Null-Safety Guaranteed**: `DateTimeExtension` is defined on `DateTime?` and returns `""` when the object is null, avoiding force unwraps (`date!`) and null check boilerplate in UI trees.

---

## 2. Centralized Price & Unit Price Formatting (`MonyHelper`)

### ❌ Anti-Pattern: Manual String Interpolation
```dart
// BAD: Hardcoding currency symbols and manual string concatenation
Text('$price L.E')
Text('${service.price} ج.م')
Text('${item.unitPrice} / قطعة')
```
- **Why this is bad**: Breaks when switching countries, currencies, multi-currency support, or custom number formatting.

### ✅ Clean Pattern: Centralized `MonyHelper`
Location: `lib/core/network/mony_helper.dart`

```dart
import 'package:inservice/core/network/mony_helper.dart';

// Standard total/service price (e.g. "222 L.E")
final priceLabel = MonyHelper.formatPrice(service.price);

// Unit price with optional unit (e.g. "50 L.E / piece")
final unitPriceLabel = MonyHelper.formatUnitPrice(
  item.unitPrice,
  unit: 'piece',
);

// Custom currency override if needed:
final customCurrency = MonyHelper.formatPrice(service.price, currency: 'SAR');
```

### Golden Rules:
1. **Single Source of Truth**: All price displays in Order Cards, Order Details, Service Details, Breakdowns, and Invoices MUST call `MonyHelper.formatPrice` or `MonyHelper.formatUnitPrice`.
2. **Nullable Input Safety**: If price can be null (e.g. pending quote), guard appropriately with fallback text (e.g. `'order_pricing_pending'.tr()`) before or inside presentation extensions.

---

## 3. Cubit Pagination Standard (`PaginationMixin`)

Any Cubit that manages a paginated list, grid, or infinite-scrolling feed MUST mix in `PaginationMixin`.

Location: `lib/core/mixins/pagination_mixin.dart`

### Architecture & Lifecycle Pattern

```dart
import 'package:inservice/core/base/safe_cubit.dart';
import 'package:inservice/core/mixins/pagination_mixin.dart';
import 'package:inservice/core/uses_cases/params.dart';
import 'package:inservice/core/utils/enums/request_status_enum.dart';

class {Feature}Cubit extends SafeCubit<{Feature}State> with PaginationMixin {
  final Get{Feature}ListUseCase get{Feature}ListUseCase;

  {Feature}Cubit({
    required this.get{Feature}ListUseCase,
  }) : super(const {Feature}State()) {
    limit = 20; // Default limit per page
  }

  /// 1. Initialize scroll listener
  void initListeners() {
    addPaginationListener(
      loadMoreItems,
      // Dynamic getter prevents stale closure bugs
      isLoadingGetter: () =>
          state.status == RequestStatusEnum.loading ||
          state.status == RequestStatusEnum.loadingMore,
      triggerDistance: 250.0, // Distance from bottom in px to trigger load
    );
  }

  /// 2. Initial Fetch / Refresh
  Future<void> getItems({bool isRefresh = false}) async {
    resetPagination(); // Resets currentPage = 1 and hasReachedMax = false

    if (!isRefresh) {
      emit(state.copyWith(status: RequestStatusEnum.loading));
    }

    final result = await get{Feature}ListUseCase(
      PaginationParams(page: currentPage, limit: limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatusEnum.failure,
        errMessage: failure.errMessage,
      )),
      (items) {
        hasReachedMax = items.length < limit;
        currentPage = 2;
        emit(state.copyWith(
          status: items.isEmpty ? RequestStatusEnum.empty : RequestStatusEnum.success,
          items: items,
        ));
      },
    );
  }

  /// 3. Load More (Next Page)
  Future<void> loadMoreItems() async {
    if (state.status == RequestStatusEnum.loadingMore ||
        hasReachedMax ||
        state.items.isEmpty) {
      return;
    }

    emit(state.copyWith(status: RequestStatusEnum.loadingMore));

    final result = await get{Feature}ListUseCase(
      PaginationParams(page: currentPage, limit: limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatusEnum.failureMore,
        errMessage: failure.errMessage,
      )),
      (newItems) {
        hasReachedMax = newItems.length < limit;
        currentPage++;
        final updatedList = List<{Feature}Item>.from(state.items)..addAll(newItems);
        emit(state.copyWith(
          status: RequestStatusEnum.successMore,
          items: updatedList,
        ));
      },
    );
  }

  /// 4. Dispose pagination resources safely
  @override
  Future<void> close() {
    disposePagination(); // Disposes scrollController and cleans up listener
    return super.close();
  }
}
```

### Golden Rules:
1. **Always use `isLoadingGetter`**: Pass a function `() => boolean` so that every scroll event evaluates the up-to-date state rather than capturing a stale snapshot at registration time.
2. **Always call `resetPagination()` on refresh**: When pull-to-refresh or filter change occurs, `resetPagination()` resets `currentPage = 1` and `hasReachedMax = false`.
3. **Attach `scrollController` to ListView/CustomScrollView**: Connect `cubit.scrollController` to the `ListView` or `CustomScrollView` in the UI widget.
4. **Dispose in `close()`**: Always call `disposePagination()` to avoid memory leaks with the underlying `ScrollController`.

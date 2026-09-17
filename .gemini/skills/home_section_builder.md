# Home Section Builder Skill (Blueprint)

> Complete blueprint for building, filling, or modifying sections on any Home Page (`customer_home_page.dart` / `StudentHomePage`, `TeacherHomePage`, and future home dashboards) following the **Clean Architecture + SafeCubit + Sliver** pattern established in this project.
> Complete skill package located at: `.agents/skills/home-section-builder/`

---

## 1. Discovery Checklist (Step 0)

Whenever a user requests to add, modify, or fill a section on the Home Page, systematically clarify:
1. **Section Identity & Purpose**:
   - Arabic & English title (e.g. `دورات مميزة` / "Featured Items", `الأكثر طلباً` / "Popular Items").
   - Action when an item is tapped (navigate to details, profile, etc.).
   - Is there a "See All" (`عرض الكل`) button? Where does it go?
2. **Visual Layout Pattern**:
   - Horizontal Carousel (banners/sliders)
   - Horizontal Scrolling List (cards)
   - Grid (2/3 columns or max cross-axis extent)
   - Vertical List
3. **Data Source**:
   - **Dummy / Mock Data** for UI prototyping, OR
   - **Real Backend API** (which endpoint in `EndPoints`?)
4. **Data Shape**:
   - Required fields (`id`, `title`, `image`, `price`, `rating`, etc.).

---

## 2. Core Architecture Rules

1. **Independent Reactive Sections**: Each section has its own `RequestStatusEnum {section}Status` and `List<{Section}Model> {section}List` in `HomeState`. Failure in one section NEVER breaks others.
2. **Parallel Fetching**: `loadHomeData()` must use `Future.wait([getSliders(), getCategories(), get{Section}()])`.
3. **100% Nullable Models & Domain-Agnostic**:
   - Every model field MUST be nullable (`Type?`), and constructor parameters must NEVER be `required`.
   - In `fromJson`, parse defensively (`if (json == null) return const {Model}();`).
   - Use generic placeholders (`{Section}`, `{Item}`, `{Feature}`) so the section blueprint transfers seamlessly to any project or domain without hardcoded concepts (e.g. no hardcoded teacher/student terminology).
4. **Strict 4-State UI Matrix**: Every section handles:
   - `loading`: `CustomShimmerContainer` skeleton matching card dimensions.
   - `failure`: `ErrorPage` with retry button invoking `cubit.get{Section}()`.
   - `empty`: `CustomEmptyWidget` or `SizedBox.shrink().toSliver()`.
   - `success`: `SectionHeaderWithAction` + cards list/grid.
5. **Slivers-Only**: In `CustomScrollView`, every widget is a sliver or converted with `.toSliver()`.
6. **Rebuild Isolation**: Always use `buildWhen` in `BlocBuilder<HomeCubit, HomeState>`:
   ```dart
   buildWhen: (prev, curr) =>
       prev.{section}Status != curr.{section}Status ||
       prev.{section}List != curr.{section}List
   ```
7. **Centralized Date & Time Formatting**: Always use `DateTimeExtension` (`lib/core/utils/extensions/date_time_extentision.dart`) with optional locale `[String? locale]`. Never create ad-hoc `DateFormat(...)` calls in presentation/widget layers.
8. **Centralized Price Formatting**: Always format prices via `MonyHelper.formatPrice(amount)` and unit prices via `MonyHelper.formatUnitPrice(unitPrice, ...)` (`lib/core/network/mony_helper.dart`).
9. **Cubit Pagination with `PaginationMixin`**: If a section or page supports pagination / infinite scrolling, its Cubit MUST mix in `PaginationMixin`, wire `addPaginationListener` with dynamic `isLoadingGetter`, reset pagination on refresh, and dispose it in `close()`.

---

## 3. Implementation Steps

1. **Model**: Extend `Equatable`, all fields nullable (`Type?`), constructor parameters optional (NO `required`), provide defensive `fromJson` and conditional `toJson`.
2. **Domain & Data (if API)**: Create `Repo`, `RepoImpl` with `ApiConsumer`, `UseCase<List<{Section}Model>, PaginationParams?>`, and register in `dependency_injection.dart`.
3. **State**: Add status and list to `HomeState` (`copyWith` + `props`).
4. **Cubit**: Add `get{Section}()` using `emit(state.copyWith(...))` and add to `Future.wait` in `loadHomeData()`.
5. **UI**: Create card widget, shimmer skeleton, and embed into page slivers list.

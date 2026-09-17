---
name: home-section-builder
description: >-
  Use this skill when adding, designing, or filling sections on any Flutter Home Page (e.g., StudentHomePage / customer_home_page.dart, TeacherHomePage), structuring multi-section sliver dashboards, creating domain-agnostic nullable models (dummy or API-driven), wiring use cases with Clean Architecture, and implementing SafeCubit state management.
---

# Home Page Section Builder Skill

This skill defines the authoritative procedure and architecture for adding, filling, and maintaining sections in Flutter Home Pages (e.g. `customer_home_page.dart`, `teacher_home_page.dart`, and similar dashboard pages) following the **Clean Architecture + SafeCubit + Sliver** pattern established in this project.

---

## 1. Golden Rules & Architectural Principles

1. **Independent Reactive Sections**:
   Each section on the Home Page must be completely autonomous in its lifecycle. Failure, loading, or empty states in one section must **never** break or block another section.

2. **Parallel Data Fetching**:
   All home sections are loaded in parallel via `Future.wait([getSliders(), getCategories(), ...])` inside `loadHomeData()`. Never waterfall or sequentially await section API calls unless one strictly depends on another.

3. **Strict 4-State UI Matrix**:
   Every section MUST handle all four states:
   - **Loading**: `CustomShimmerContainer` layout matching the exact card aspect ratio.
   - **Failure**: `ErrorPage(errorMessage: state.errMessage ?? "", onPressed: () => cubit.getSection())` with isolated retry.
   - **Empty**: `CustomEmptyWidget` or `SizedBox.shrink().toSliver()` (if optional).
   - **Success**: Section Header + Card List/Grid/Carousel.

4. **Sliver-First Presentation**:
   The entire Home page is a single `CustomScrollView`. Every section component must be a Sliver or convert via `.toSliver()`.

5. **Granular BlocBuilder**:
   Always isolate section rebuilds using `buildWhen`:
   ```dart
   buildWhen: (previous, current) =>
       previous.{section}Status != current.{section}Status ||
       previous.{section}List != current.{section}List
   ```

6. **100% Nullable Models & Domain-Agnostic Naming**:
   - Every model field MUST be nullable (`Type?`, e.g. `String?`, `num?`), and constructor parameters must NEVER be `required`.
   - In `fromJson`, parse defensively (`if (json == null) return const {Model}();`).
   - Use generic placeholders (`{Section}`, `{Item}`, `{Feature}`) so the blueprint applies cleanly to any idea (e-commerce, education, delivery, real estate, medical, dashboard, etc.) without hardcoded domain names.

7. **Centralized Date & Time Formatting (`DateTimeExtension`)**:
   - NEVER instantiate `DateFormat(...)` directly in widgets or presentation code.
   - ALWAYS use `DateTimeExtension` (`lib/core/utils/extensions/date_time_extentision.dart`) on `DateTime?`.
   - Pass language/locale optionally (`[String? locale]`), e.g. `toShortDate()`, `toTimeOnly()`, `toLongDate()`, `toShortDateTime()`.

8. **Centralized Price & Unit Price Formatting (`MonyHelper`)**:
   - NEVER format prices manually with string interpolation (`$price L.E` or `price.toString()`).
   - ALWAYS route prices through `MonyHelper.formatPrice(amount)` and unit prices through `MonyHelper.formatUnitPrice(unitPrice, ...)`.

9. **Mandatory PaginationMixin for Paginated Cubits**:
   - Any Cubit managing infinite scrolling or paginated lists MUST use `with PaginationMixin` (`lib/core/mixins/pagination_mixin.dart`).
   - Wire `addPaginationListener` with dynamic `isLoadingGetter: () => ...` to avoid stale closure state.
   - Always call `resetPagination()` on initial load/refresh and `disposePagination()` on Cubit close.

---

## 2. Interactive Discovery Questionnaire (Step 0)

Whenever asked to create, add, or fill a section on the Home page, **DO NOT START CODING IMMEDIATELY**. Run through this discovery checklist with the user:

### Questions to Ask:
1. **Section Identity & Purpose**:
   - What is the section title in Arabic & English? (e.g. `دورات مميزة` / "Featured Items", `الأكثر طلباً` / "Popular Items")
   - What is its purpose, and what happens when an item is tapped?
   - Is there a **"See All" (عرض الكل)** button? Where does it navigate?
2. **Visual Layout Pattern**:
   - Is it a **Horizontal Carousel** (like sliders/banners)?
   - Is it a **Horizontal Scrolling List** (cards with horizontal scroll)?
   - Is it a **Grid** (e.g., 2 columns or `SliverGridDelegateWithMaxCrossAxisExtent`)?
   - Is it a **Vertical List** (e.g., `SliverList.separated`)?
3. **Data Source Strategy**:
   - Is this section using **Dummy / Mock Data** for UI prototyping, or a **Real Backend API**?
   - If Real API: what is the endpoint in `EndPoints`?
4. **Data Shape & Model Properties**:
   - What fields are needed? (e.g., `id`, `title`, `subtitle`, `imageUrl`, `price`, `rating`, `extra`)

---

## 3. Step-by-Step Implementation Procedure

### Step 1: Define the Data Model
- **All fields must be nullable (`Type?`)** and constructor parameters must be optional (NO `required`).
- Use `num?` for numbers (prices, ratings, counters) to accept both int and double safely.
- Provide safe `fromJson` with null checks and conditional `toJson` (`if (field != null) 'key': field`).
- If **Dummy Data**: Add a static `dummyList` on the model or mock class. See [references/data_and_usecase_patterns.md](./references/data_and_usecase_patterns.md).
- If **Real API**: Place under `lib/{layout}/{feature}/data/models/{feature}_model.dart`.

### Step 2: Define Domain & Use Case (If API-driven)
1. In `domain/repo/{feature}_repo.dart`:
   ```dart
   abstract class {Feature}Repo {
     Future<Either<Failures, List<{Feature}Model>>> get{Feature}s({
       PaginationParams? params,
     });
   }
   ```
2. In `data/repo/{feature}_repo_impl.dart`:
   Use `ApiConsumer` + try/catch with `ServerFailure.fromDioException`.
3. In `domain/use_cases/get_{feature}_use_case.dart`:
   Extend `UseCase<List<{Feature}Model>, PaginationParams?>` or `NoParams`.
4. Register in `lib/core/dependency_injection/dependency_injection.dart`:
   ```dart
   getIt.registerLazySingleton<{Feature}Repo>(() => {Feature}RepoImpl(apiConsumer: getIt()));
   getIt.registerLazySingleton<Get{Feature}UseCase>(() => Get{Feature}UseCase(getIt()));
   ```

### Step 3: Update Home State (`home_state.dart`)
Add section status and data list to `HomeState`:
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
  List<Object?> get props => [
    {section}Status,
    {section}List,
    errMessage,
  ];
}
```

### Step 4: Update Home Cubit (`home_cubit.dart`)
1. Inject the use case (or mock service) into `HomeCubit`.
2. Add fetch method:
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
3. Add to `loadHomeData()`:
```dart
Future<void> loadHomeData() async {
  await Future.wait([
    get{Section}(),
    // other section fetch methods...
  ]);
}
```

### Step 5: Build UI Widgets
1. **Item Card Widget**: Create in `presentation/widgets/{section}_card.dart` or `shared/widgets/custom_cards/`.
2. **Shimmer Placeholder**: Build a skeleton layout matching the card dimensions with `CustomShimmerContainer`.
3. **Section in Page**: Add to `CustomerHomePage` / `StudentHomeView` sliver list.

---

## 4. Standard Sliver UI Templates

### Template A: Horizontal Scrolling List Section
```dart
// ─── {Section} Section ──────────────────────────────────────────────────
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
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => const CustomShimmerContainer(
                  width: 150,
                  height: 190,
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
                // Navigate to See All screen
              },
            ),
          ),
        ),
        const SizedBox(height: 12).toSliver(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 190,
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

### Template B: Responsive Grid Section
```dart
SliverPadding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  sliver: BlocBuilder<HomeCubit, HomeState>(
    buildWhen: (previous, current) =>
        previous.{section}Status != current.{section}Status ||
        previous.{section}List != current.{section}List,
    builder: (context, state) {
      if (state.{section}Status == RequestStatusEnum.loading) {
        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 120,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => const Column(
            children: [
              CustomShimmerContainer(width: 80, height: 80, borderRadius: 8),
              SizedBox(height: 8),
              CustomShimmerContainer(width: 60, height: 12, borderRadius: 4),
            ],
          ),
        );
      } else if (state.{section}Status == RequestStatusEnum.failure) {
        return ErrorPage(
          errorMessage: state.errMessage ?? "",
          onPressed: () => context.read<HomeCubit>().get{Section}(),
        ).toSliver();
      } else if (state.{section}Status == RequestStatusEnum.empty ||
          state.{section}List.isEmpty) {
        return const CustomEmptyWidget(title: 'لا توجد عناصر').toSliver();
      }

      return SliverMainAxisGroup(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 12),
            sliver: SliverToBoxAdapter(
              child: SectionHeaderWithAction(
                title: '{عنوان القسم}',
                onPressed: () {
                  // Navigate to All page
                },
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 120,
            ),
            itemCount: state.{section}List.length,
            itemBuilder: (context, index) {
              final item = state.{section}List[index];
              return {Section}GridCard(item: item);
            },
          ),
        ],
      );
    },
  ),
),
const SizedBox(height: 24).toSliver(),
```

---

## 5. Verification Checklist

Before considering the section complete, verify:
- [ ] **Pull to Refresh**: Dragging down triggers `loadHomeData()`, which refreshes this section alongside other sections.
- [ ] **Individual Retry**: Pressing retry on `ErrorPage` triggers ONLY `cubit.get{Section}()`.
- [ ] **No Cross Rebuilds**: Verify that another section updating does NOT rebuild this section (guaranteed by `buildWhen`).
- [ ] **RTL Support**: Icons (`Icons.arrow_forward_ios` or back arrows) and text align properly in RTL Arabic.
- [ ] **Memory Safety**: `SafeCubit` handles unmounted state safely during async emits.
- [ ] **Date & Time Formatting**: Any dates or times use `DateTimeExtension` (`toShortDate`, `toTimeOnly`, `toLongDate`, etc.) with optional locale. Zero raw `DateFormat` calls in widgets.
- [ ] **Price Formatting**: All prices and unit prices are routed through `MonyHelper.formatPrice()` or `MonyHelper.formatUnitPrice()`.
- [ ] **Pagination Safety**: If the section/page paginates, the Cubit uses `PaginationMixin`, evaluates dynamic `isLoadingGetter`, and disposes pagination in `close()`.

---

## 6. References & Examples
- [Formatting & Utility Architecture Rules](./references/formatting_and_utility_rules.md)
- [Cubit & State Patterns Reference](./references/cubit_and_state_patterns.md)
- [Sliver UI Patterns Reference](./references/sliver_ui_patterns.md)
- [Data, Models & UseCase Patterns Reference](./references/data_and_usecase_patterns.md)
- [End-to-End Dummy Data Example](./examples/dummy_section_example.md)
- [End-to-End API Section Example](./examples/api_section_example.md)

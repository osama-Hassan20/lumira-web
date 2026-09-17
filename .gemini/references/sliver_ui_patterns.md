# Sliver UI Patterns Reference

This reference documents how to construct UI sections within the `CustomScrollView` on any Home Page.

---

## 1. Page Shell Architecture

The outer shell must always follow this structure:

```dart
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          context.read<HomeCubit>().loadHomeData();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SizedBox(height: 16).toSliver(),
            
            // Search Bar Sliver
            // Section 1
            // Section 2
            // Section 3
            
            const SizedBox(height: 24).toSliver(),
          ],
        ),
      ),
    );
  }
}
```

### Key Rules:
- `physics: const AlwaysScrollableScrollPhysics()` ensures pull-to-refresh works even when content fits on a single screen.
- Use `import '../../../../core/utils/extensions/sliver_extentions.dart';` to enable `.toSliver()` on standard widgets.

---

## 2. The Section Header (`SectionHeaderWithAction`)

Located in `lib/shared/widgets/custom_header_section_with_action.dart`:
```dart
SectionHeaderWithAction(
  title: 'عنوان القسم',
  showButton: true, // defaults to true
  onPressed: () {
    // Navigate to See All page
  },
)
```

- In RTL, title aligns to right, "عرض الكل" + arrow aligns to left.
- If no see-all page is required, set `showButton: false`.

---

## 3. Shimmer Skeletons by Section Type

### A. Horizontal Carousel Shimmer (Banners)
```dart
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: CustomShimmerContainer(
      height: 180,
      width: double.infinity,
      borderRadius: 16,
    ),
  ),
)
```

### B. Horizontal List Shimmer (Cards)
```dart
SliverToBoxAdapter(
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
)
```

### C. Grid Shimmer (Tiles / Cards)
```dart
SliverGrid.builder(
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 100,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    mainAxisExtent: 120,
  ),
  itemCount: 8,
  itemBuilder: (context, index) {
    return const Column(
      children: [
        CustomShimmerContainer(
          width: 80,
          height: 80,
          borderRadius: 8,
        ),
        SizedBox(height: 8),
        CustomShimmerContainer(
          width: 60,
          height: 12,
          borderRadius: 4,
        ),
      ],
    );
  },
)
```

---

## 4. Section Grouping with `SliverMainAxisGroup`

When a section contains a Header and a Grid/List, group them into a single `SliverMainAxisGroup`:

```dart
return SliverMainAxisGroup(
  slivers: [
    SliverPadding(
      padding: const EdgeInsets.only(bottom: 12),
      sliver: SliverToBoxAdapter(
        child: SectionHeaderWithAction(
          title: '{عنوان القسم}',
          onPressed: () { ... },
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
        return {Section}GridCard(item: state.{section}List[index]);
      },
    ),
  ],
);
```

---

## 5. Error & Empty State In Slivers

### Error State:
```dart
return SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      height: 160,
      child: ErrorPage(
        errorMessage: state.errMessage ?? "",
        onPressed: () {
          context.read<HomeCubit>().get{Section}();
        },
      ),
    ),
  ),
);
```

### Empty State:
```dart
// Option 1: Collapsible (silently hides if empty)
return const SizedBox.shrink().toSliver();

// Option 2: Friendly empty illustration
return const CustomEmptyWidget(
  title: 'لا توجد عناصر حالياً',
).toSliver();
```

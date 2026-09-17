# Example: Adding a Dummy Data Section ("{Section}")

This example walks through adding a generic, reusable horizontal scrolling section to any Home Page using mock/dummy data.

> **Rule**: All model fields are nullable (`Type?`) and constructor parameters are optional (NO `required`). This allows safely prototyping with any data structure without breaking on missing keys.

---

## 1. Generic Model & Mock Data
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

  const {Section}Model({
    this.id,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.price,
    this.rating,
  });

  factory {Section}Model.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const {Section}Model();
    return {Section}Model(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? json['name'],
      subtitle: json['subtitle'] ?? json['description'],
      imageUrl: json['image'] ?? json['imageUrl'],
      price: json['price'],
      rating: (json['rating'] as num?)?.toDouble(),
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
    };
  }

  static const List<{Section}Model> dummyList = [
    {Section}Model(
      id: '1',
      title: 'عنصر تجريبي أول',
      subtitle: 'وصف مختصر إضافي',
      price: 150,
      rating: 4.9,
    ),
    {Section}Model(
      id: '2',
      title: 'عنصر تجريبي ثاني',
      subtitle: 'وصف مختصر إضافي',
      price: 200,
      rating: 4.8,
    ),
    {Section}Model(
      id: '3',
      title: 'عنصر تجريبي ثالث',
      subtitle: 'وصف مختصر إضافي',
      price: 320,
      rating: 5.0,
    ),
  ];

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, price, rating];
}
```

---

## 2. Update `HomeState`
File: `lib/{layout}/home/presentation/manager/home_state.dart`
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

---

## 3. Update `HomeCubit`
File: `lib/{layout}/home/presentation/manager/home_cubit.dart`
```dart
Future<void> get{Section}() async {
  emit(state.copyWith({section}Status: RequestStatusEnum.loading));
  
  // Simulate 500ms network delay to test shimmer smoothly
  await Future.delayed(const Duration(milliseconds: 500));

  emit(
    state.copyWith(
      {section}Status: {Section}Model.dummyList.isEmpty
          ? RequestStatusEnum.empty
          : RequestStatusEnum.success,
      {section}List: {Section}Model.dummyList,
    ),
  );
}

// In loadHomeData():
Future<void> loadHomeData() async {
  await Future.wait([
    get{Section}(),
    // other section fetch methods...
  ]);
}
```

---

## 4. Create Card Widget (Safe Null Handling)
File: `lib/{layout}/home/presentation/widgets/{section}_card.dart`
```dart
import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/custom_app_font_styles.dart';
import '../../data/models/{section}_model.dart';

class {Section}Card extends StatelessWidget {
  final {Section}Model? item;
  final VoidCallback? onTap;

  const {Section}Card({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = item?.title ?? '';
    final subtitle = item?.subtitle ?? '';
    final price = item?.price;
    final rating = item?.rating;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.category_outlined, size: 36, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            if (title.isNotEmpty)
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomAppFontStyle.semiBold14,
              ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomAppFontStyle.regular12.copyWith(color: Colors.grey),
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (price != null)
                  Text(
                    '$price د.ع',
                    style: CustomAppFontStyle.bold14.copyWith(color: AppColors.primary),
                  ),
                if (rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text('$rating', style: CustomAppFontStyle.regular12),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 5. Add to Slivers List
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
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => const CustomShimmerContainer(
                  width: 200,
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
                // Navigate to see all
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

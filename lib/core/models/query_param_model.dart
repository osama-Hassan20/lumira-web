import 'package:equatable/equatable.dart';
import '../utils/phone_utils.dart';

// ─── Base Params ──────────────────────────────────────────────────────────────

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}

class Params extends Equatable {
  const Params();
  @override
  List<Object?> get props => [];
}

// ─── Query Parameter Model ───────────────────────────────────────────────────

class QueryParamModel extends Equatable {
  final int? page;
  final int? limit;
  final String? type;
  final String? keyword;
  final String? sort;
  final String? category;
  final String? status;
  final String? phone;
  final num? pointLte;
  final num? pointGte;
  final List<String>? productIds;
  final String? plan;
  final String? planAgentInventory; // sent as 'agentPlanInventory.plan'
  final String? excludeId;
  final bool? isActive;
  final bool? isDeleted;
  final String? code;
  final String? createdAtGte;
  final String? createdAtLte;
  final String? scheduledAtGte;
  final String? scheduledAtLte;
  final String? populate;
  final String? from;
  final String? to;
  final String? search;
  final String? patient;
  final String? consultation;
  final int? year;
  final String? role;
  final bool? stats;
  final String? activeSubscription;
  final String? subscriptionStatus;
  final int? totalSubscriptions;
  final String? subscriptionExpiresAtGte;
  final String? subscriptionExpiresAtLte;
  final String? user;
  final String? mode;
  final Map<String, dynamic> filters;

  const QueryParamModel({
    this.page,
    this.limit,
    this.type,
    this.keyword,
    this.sort,
    this.category,
    this.status,
    this.phone,
    this.pointLte,
    this.pointGte,
    this.productIds,
    this.plan,
    this.planAgentInventory,
    this.excludeId,
    this.isActive,
    this.isDeleted,
    this.code,
    this.createdAtGte,
    this.createdAtLte,
    this.scheduledAtGte,
    this.scheduledAtLte,
    this.populate,
    this.from,
    this.to,
    this.search,
    this.patient,
    this.consultation,
    this.year,
    this.role,
    this.stats,
    this.activeSubscription,
    this.subscriptionStatus,
    this.totalSubscriptions,
    this.subscriptionExpiresAtGte,
    this.subscriptionExpiresAtLte,
    this.user,
    this.mode,
    this.filters = const {},
  });

  Map<String, dynamic> toQueryParameters() {
    final map = <String, dynamic>{...filters};
    if (page != null) map['page'] = page;
    if (limit != null) map['limit'] = limit;
    if (type != null) map['type'] = type;
    if (keyword != null) map['keyword'] = keyword;
    if (sort != null) map['sort'] = sort;
    if (category != null) map['category'] = category;
    if (status != null) map['status'] = status;
    if (phone != null) map['phone'] = PhoneUtils.toInternationalFormat(phone!);
    if (pointLte != null) map['point[gte]'] = pointLte;
    if (pointGte != null) map['point[lte]'] = pointGte;
    if (productIds != null && productIds!.isNotEmpty) {
      map['productIds'] = productIds!.join(',');
    }
    if (plan != null) map['plan'] = plan;
    if (planAgentInventory != null) map['agentPlanInventory.plan'] = planAgentInventory;
    if (excludeId != null) map['_id[ne]'] = excludeId;
    if (isActive != null) map['isActive'] = isActive;
    if (isDeleted != null) map['isDeleted'] = isDeleted;
    if (code != null && code!.isNotEmpty) map['code'] = code;
    if (createdAtGte != null) map['createdAt[gte]'] = createdAtGte;
    if (createdAtLte != null) map['createdAt[lte]'] = createdAtLte;
    if (scheduledAtGte != null) map['scheduledAt[gte]'] = scheduledAtGte;
    if (scheduledAtLte != null) map['scheduledAt[lte]'] = scheduledAtLte;
    if (populate != null) map['populate'] = populate;
    if (from != null) map['from'] = from;
    if (to != null) map['to'] = to;
    if (patient != null) map['patient'] = patient;
    if (consultation != null) map['consultation'] = consultation;
    if (search != null) map['search'] = search;
    if (year != null) map['year'] = year;
    if (role != null) map['role'] = role;
    if (stats != null) map['stats'] = stats;
    if (activeSubscription != null) map['activeSubscription'] = activeSubscription;
    if (subscriptionStatus != null) map['subscriptionStatus'] = subscriptionStatus;
    if (totalSubscriptions != null) map['totalSubscriptions'] = totalSubscriptions;
    if (subscriptionExpiresAtGte != null) map['subscriptionExpiresAt[gte]'] = subscriptionExpiresAtGte;
    if (subscriptionExpiresAtLte != null) map['subscriptionExpiresAt[lte]'] = subscriptionExpiresAtLte;
    if (user != null) map['user'] = user;
    if (mode != null) map['mode'] = mode;
    return map;
  }

  QueryParamModel copyWith({
    int? page,
    int? limit,
    String? type,
    String? keyword,
    String? sort,
    String? category,
    String? status,
    String? phone,
    num? pointLte,
    num? pointGte,
    List<String>? productIds,
    String? plan,
    String? planAgentInventory,
    String? excludeId,
    bool? isActive,
    bool? isDeleted,
    String? code,
    String? createdAtGte,
    String? createdAtLte,
    String? scheduledAtGte,
    String? scheduledAtLte,
    String? populate,
    String? from,
    String? to,
    String? search,
    String? patient,
    String? consultation,
    int? year,
    String? role,
    bool? stats,
    String? activeSubscription,
    String? subscriptionStatus,
    int? totalSubscriptions,
    String? subscriptionExpiresAtGte,
    String? subscriptionExpiresAtLte,
    String? user,
    String? mode,
    Map<String, dynamic>? filters,
  }) {
    return QueryParamModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      type: type ?? this.type,
      keyword: keyword ?? this.keyword,
      sort: sort ?? this.sort,
      category: category ?? this.category,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      pointLte: pointLte ?? this.pointLte,
      pointGte: pointGte ?? this.pointGte,
      productIds: productIds ?? this.productIds,
      plan: plan ?? this.plan,
      planAgentInventory: planAgentInventory ?? this.planAgentInventory,
      excludeId: excludeId ?? this.excludeId,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      code: code ?? this.code,
      createdAtGte: createdAtGte ?? this.createdAtGte,
      createdAtLte: createdAtLte ?? this.createdAtLte,
      scheduledAtGte: scheduledAtGte ?? this.scheduledAtGte,
      scheduledAtLte: scheduledAtLte ?? this.scheduledAtLte,
      populate: populate ?? this.populate,
      from: from ?? this.from,
      to: to ?? this.to,
      search: search ?? this.search,
      patient: patient ?? this.patient,
      consultation: consultation ?? this.consultation,
      year: year ?? this.year,
      role: role ?? this.role,
      stats: stats ?? this.stats,
      activeSubscription: activeSubscription ?? this.activeSubscription,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      totalSubscriptions: totalSubscriptions ?? this.totalSubscriptions,
      subscriptionExpiresAtGte: subscriptionExpiresAtGte ?? this.subscriptionExpiresAtGte,
      subscriptionExpiresAtLte: subscriptionExpiresAtLte ?? this.subscriptionExpiresAtLte,
      user: user ?? this.user,
      mode: mode ?? this.mode,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [
    page,
    limit,
    type,
    keyword,
    sort,
    category,
    status,
    phone,
    pointLte,
    pointGte,
    productIds,
    plan,
    planAgentInventory,
    excludeId,
    isActive,
    isDeleted,
    code,
    createdAtGte,
    createdAtLte,
    scheduledAtGte,
    scheduledAtLte,
    populate,
    from,
    to,
    search,
    patient,
    consultation,
    year,
    role,
    stats,
    activeSubscription,
    subscriptionStatus,
    totalSubscriptions,
    subscriptionExpiresAtGte,
    subscriptionExpiresAtLte,
    user,
    mode,
    filters,
  ];
}

// ─── Other Params from params.dart ──────────────────────────────────────────

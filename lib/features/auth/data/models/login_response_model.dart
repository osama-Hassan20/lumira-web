class LoginResponseModel {
  final String? id;
  final String? uuid;
  final String? displayName;
  final String? role;
  final UserLocation? location;
  final String? username;
  final LoginPermissions? permissions;
  final String? accessToken;
  final String? refreshToken;
  final String? image;

  LoginResponseModel({
    this.id,
    this.uuid,
    this.displayName,
    this.role,
    this.location,
    this.username,
    this.permissions,
    this.accessToken,
    this.refreshToken,
    this.image,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['_id'] as String?,
      uuid: json['uuid'] as String?,
      displayName: json['displayName'] as String?,
      role: json['role'] as String?,
      location: json['location'] != null
          ? UserLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      username: json['username'] as String?,
      permissions: json['permissions'] != null
          ? LoginPermissions.fromJson(json['permissions'] as Map<String, dynamic>)
          : null,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'uuid': uuid,
      'displayName': displayName,
      'role': role,
      if (location != null) 'location': location!.toJson(),
      'username': username,
      if (permissions != null) 'permissions': permissions!.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'image': image,
    };
  }
}

class UserLocation {
  final String? type;
  final List<double>? coordinates;

  UserLocation({this.type, this.coordinates});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (coordinates != null) 'coordinates': coordinates,
    };
  }
}

class LoginPermissions {
  final bool addProducts;
  final bool approveProducts;
  final bool deleteProducts;
  final bool manageUsers;
  final bool manageStores;
  final bool manageOrders;
  final bool viewDrivers;
  final bool addCategory;
  final bool sendNotifications;
  final bool manageBanners;
  final bool manageGovernorates;

  LoginPermissions({
    this.addProducts = false,
    this.approveProducts = false,
    this.deleteProducts = false,
    this.manageUsers = false,
    this.manageStores = false,
    this.manageOrders = false,
    this.viewDrivers = false,
    this.addCategory = false,
    this.sendNotifications = false,
    this.manageBanners = false,
    this.manageGovernorates = false,
  });

  factory LoginPermissions.fromJson(Map<String, dynamic> json) {
    return LoginPermissions(
      addProducts: json['addProducts'] as bool? ?? false,
      approveProducts: json['approveProducts'] as bool? ?? false,
      deleteProducts: json['deleteProducts'] as bool? ?? false,
      manageUsers: json['manageUsers'] as bool? ?? false,
      manageStores: json['manageStores'] as bool? ?? false,
      manageOrders: json['manageOrders'] as bool? ?? false,
      viewDrivers: json['viewDrivers'] as bool? ?? false,
      addCategory: json['addCategory'] as bool? ?? false,
      sendNotifications: json['sendNotifications'] as bool? ?? false,
      manageBanners: json['manageBanners'] as bool? ?? false,
      manageGovernorates: json['manageGovernorates'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addProducts': addProducts,
      'approveProducts': approveProducts,
      'deleteProducts': deleteProducts,
      'manageUsers': manageUsers,
      'manageStores': manageStores,
      'manageOrders': manageOrders,
      'viewDrivers': viewDrivers,
      'addCategory': addCategory,
      'sendNotifications': sendNotifications,
      'manageBanners': manageBanners,
      'manageGovernorates': manageGovernorates,
    };
  }
}

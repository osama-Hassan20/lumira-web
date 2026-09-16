// import '../utils/phone_utils.dart';

// class UserData {
//   final String? id;
//   final String? code;
//   final String? userName;
//   final String? phone;
//   final String? password;
//   final String? profileImg;
//   final String? city;
//   final bool? active;
//   final String? role;
//   final String? agent;
//   final List<dynamic>? permition;
//   final num? points;
//   final num? numberOfTransactions;
//   final num? numberOfOrders;
//   final List<dynamic>? addresses;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final num? v;

//   UserData({
//     this.id,
//     this.code,
//     this.userName,
//     this.phone,
//     this.password,
//     this.profileImg,
//     this.city,
//     this.active,
//     this.role,
//     this.agent,
//     this.permition,
//     this.points,
//     this.numberOfTransactions,
//     this.numberOfOrders,
//     this.addresses,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['_id']?.toString(),
//       code: json['code']?.toString(),
//       userName: json['userName']?.toString(),
//       phone: PhoneUtils.toLocalFormat(json['phone']?.toString() ?? ''),
//       password: json['password']?.toString(),
//       profileImg: json['profileImg']?.toString(),      city: json['city']?.toString(),
//       active: json['active'] as bool?,
//       role: json['role']?.toString(),
//       agent: json['agent']?.toString(),
//       permition: json['permition'] as List<dynamic>?,
//       points: json['points'] as num?,
//       numberOfTransactions: json['numberOfTransactions'] as num?,
//       numberOfOrders: json['numberOfOrders'] as num?,
//       addresses: json['addresses'] as List<dynamic>?,
//       createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
//       updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
//       v: json['__v'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'code': code,
//       'userName': userName,
//       'phone': phone,
//       'password': password,
//       'profileImg': profileImg,
//       'city': city,
//       'active': active,
//       'role': role,
//       'agent': agent,
//       'permition': permition,
//       'points': points,
//       'numberOfTransactions': numberOfTransactions,
//       'numberOfOrders': numberOfOrders,
//       'addresses': addresses,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       '__v': v,
//     };
//   }
// }

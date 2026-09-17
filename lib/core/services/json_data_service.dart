import 'dart:convert';
import 'package:flutter/services.dart';

class JsonDataService {
  static Map<String, dynamic>? _cachedData;

  static Future<Map<String, dynamic>> _readFromBundle() async {
    final String response = await rootBundle.loadString('js.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> _getJsonData() async {
    if (_cachedData != null) return _cachedData!;
    _cachedData = await _readFromBundle();
    return _cachedData!;
  }

  static Future<List<dynamic>> getGovernorates() async {
    final data = await _getJsonData();
    return (data['governorates'] as List<dynamic>?) ?? [];
  }

  static Future<List<dynamic>> getAreasByGovernorateId(String governorateId) async {
    final data = await _getJsonData();
    final key = 'areas?governorateId=$governorateId';
    return (data[key] as List<dynamic>?) ?? [];
  }

//   static Future<Map<String, dynamic>> _refreshJsonData() async {
//     _cachedData = await _readFromBundle();
//     return _cachedData!;
//   }

//   static Future<Map<String, dynamic>> getDashboardStats() async {
//     final data = await _getJsonData();
//     return (data['dashboardStats'] as Map<String, dynamic>?) ?? {};
//   }

//   static Future<List<dynamic>> getSubscriptions() async {
//     final data = await _getJsonData();
//     return (data['subscriptions'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getVisits() async {
//     final data = await _getJsonData();
//     return (data['visits'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getUserGrowth() async {
//     final data = await _getJsonData();
//     return (data['userGrowth'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getSubscriptionBars() async {
//     final data = await _getJsonData();
//     return (data['subscriptionBars'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getDoctorsByGovernorate() async {
//     final data = await _getJsonData();
//     return (data['doctorsByGovernorate'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getDoctorsBySpecialty() async {
//     final data = await _getJsonData();
//     return (data['doctorsBySpecialty'] as List<dynamic>?) ?? [];
//   }

//   /// Returns the dedicated specialties list: each entry has `_id` and `name`.
//   static Future<List<dynamic>> getSpecialties() async {
//     final data = await _getJsonData();
//     return (data['specialties'] as List<dynamic>?) ?? [];
//   }

//   static Future<Map<String, dynamic>?> getUserInfo() async {
//     final data = await _getJsonData();
//     return data['userInfo'] as Map<String, dynamic>?;
//   }

//   static Future<List<dynamic>> getHomePatients() async {
//     final data = await _getJsonData();
//     return (data['homePatients'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getHomeConsultations() async {
//     final data = await _getJsonData();
//     return (data['homeConsultations'] as List<dynamic>?) ?? [];
//   }

//   static Future<int> getConsultationsPaginationCount() async {
//     final data = await _getJsonData();
//     final result =
//         data['consultationsPaginationResult'] as Map<String, dynamic>?;
//     return (result?['count'] as int?) ?? 0;
//   }

//   static Future<List<dynamic>> getWeeklyReservations() async {
//     final data = await _getJsonData();
//     return (data['weeklyReservations'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getFeatureRecords(String key) async {
//     var data = await _getJsonData();
//     var records = data[key] as List<dynamic>?;

//     if (records != null && records.isNotEmpty) {
//       return records;
//     }

//     data = await _refreshJsonData();
//     records = data[key] as List<dynamic>?;

//     if (records != null && records.isNotEmpty) {
//       return records;
//     }

//     return _fallbackFeatureRecords(key);
//   }

//   static List<Map<String, dynamic>> _fallbackFeatureRecords(String key) {
//     final now = DateTime.now();
//     final stamp = '${now.year}-${now.month}-${now.day}';

//     switch (key) {
//       case 'featureEmployees':
//         return [
//           {
//             'id': 'fallback-emp-1',
//             'name': 'د. علي سالم',
//             'secondary': 'طبيب عام',
//             'meta': 'تحديث: $stamp',
//             'status': 'active',
//           },
//           {
//             'id': 'fallback-emp-2',
//             'name': 'سارة نزار',
//             'secondary': 'استقبال',
//             'meta': 'تحديث: $stamp',
//             'status': 'pending',
//           },
//         ];
//       case 'featureServicePricing':
//         return [
//           {
//             'id': 'fallback-srv-1',
//             'name': 'كشفية عامة',
//             'secondary': '30,000 IQD',
//             'meta': 'تحديث: $stamp',
//             'status': 'active',
//           },
//           {
//             'id': 'fallback-srv-2',
//             'name': 'استشارة تخصصية',
//             'secondary': '45,000 IQD',
//             'meta': 'تحديث: $stamp',
//             'status': 'active',
//           },
//         ];
//       case 'featureDrugAdministration':
//       case 'featureRadiologyTests':
//       case 'featureLaboratoryTests':
//       case 'featureChronicDiseases':
//       case 'featureAllergies':
//       case 'featureSettings':
//       case 'featureSupport':
//         return [
//           {
//             'id': 'fallback-1-$key',
//             'name': 'عنصر رئيسي',
//             'secondary': 'بيانات تجريبية',
//             'meta': 'تحديث: $stamp',
//             'status': 'active',
//           },
//           {
//             'id': 'fallback-2-$key',
//             'name': 'عنصر إضافي',
//             'secondary': 'بيانات تجريبية',
//             'meta': 'تحديث: $stamp',
//             'status': 'pending',
//           },
//         ];
//       default:
//         return const [];
//     }
//   }

//   static Future<List<dynamic>> getAppointments() async {
//     final data = await _getJsonData();
//     return (data['appointments'] as List<dynamic>?) ?? [];
//   }

//   static Future<Map<String, dynamic>> getDailyAppointments() async {
//     final data = await _getJsonData();
//     return (data['dailyAppointments'] as Map<String, dynamic>?) ?? {};
//   }

//   static Future<List<dynamic>> getAuthPlans() async {
//     final data = await _getJsonData();
//     return (data['authPlans'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getAuthPaymentMethods() async {
//     final data = await _getJsonData();
//     return (data['authPaymentMethods'] as List<dynamic>?) ?? [];
//   }

//   static Future<Map<String, dynamic>> getAuthVoucherPromo() async {
//     final data = await _getJsonData();
//     return (data['authVoucherPromo'] as Map<String, dynamic>?) ?? {};
//   }

//   /// Returns the total record count for a given [endpoint].
//   ///
//   /// —— substitute json server ——
//   /// Reads [PaginationResult.count] from the local JSON bundle.
//   /// Replace with a real API call once the backend is ready.
//   static Future<int> getPaginationCount(String endpoint) async {
//     /* remove json server
//     final response = await _apiClient.get('$endpoint/count');
//     return (response['count'] as int?) ?? 0;
//     */

//     //! substitute json server
//     final data = await _getJsonData();
//     final result = data['PaginationResult'] as Map<String, dynamic>?;
//     return (result?['count'] as int?) ?? 0;
//     //!=======================
//   }

//   static Future<List<dynamic>> getFaqs() async {
//     final data = await _getJsonData();
//     return (data['faqs'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getSupportMethods() async {
//     final data = await _getJsonData();
//     return (data['supportMethods'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getEmployees() async {
//     final data = await _getJsonData();
//     return (data['employees'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getServices() async {
//     final data = await _getJsonData();
//     return (data['services'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getMedicines() async {
//     final data = await _getJsonData();
//     return (data['medicines'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getMedicineSections() async {
//     final data = await _getJsonData();
//     return (data['medicineSections'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getPrescriptions() async {
//     final data = await _getJsonData();
//     return (data['prescriptions'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getLabTests() async {
//     final data = await _getJsonData();
//     return (data['labTests'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getLabTestBundles() async {
//     final data = await _getJsonData();
//     return (data['labTestBundles'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getRadiologyTests() async {
//     final data = await _getJsonData();
//     return (data['radiologyTests'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getRadiologyTestBundles() async {
//     final data = await _getJsonData();
//     return (data['radiologyTestBundles'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getAllergies() async {
//     final data = await _getJsonData();
//     return (data['allergies'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getChronicDiseases() async {
//     final data = await _getJsonData();
//     return (data['chronicDiseases'] as List<dynamic>?) ?? [];
//   }

//   static Future<Map<String, dynamic>> getVisitMedicalRecord(String id) async {
//     final data = await _getJsonData();
//     // In JSON server we might store a list or a map. Assuming we have `visitMedicalRecords` as a map or list.
//     // Let's check `visitMedicalRecords` list and find by id, or return a specific key like `VisitMedicalRecord1`.
//     // The prompt says "في ملف ال js.json هتعمل لكل زياره id بتاعها يعني VisitMedicalRecord1, VisitMedicalRecord2".
//     final recordKey = 'VisitMedicalRecord$id';
//     return (data[recordKey] as Map<String, dynamic>?) ?? {};
//   }

//   static Future<List<dynamic>> getSurgeries() async {
//     final data = await _getJsonData();
//     return (data['surgeries'] as List<dynamic>?) ?? [];
//   }

//   // ─── Dashboard Two Methods ────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> getDashboardTwoOrderCounts() async {
//     final data = await _getJsonData();
//     return (data['dashboardTwoOrderCounts'] as Map<String, dynamic>?) ?? {};
//   }

//   static Future<List<dynamic>> getDashboardTwoCurrentOrders() async {
//     final data = await _getJsonData();
//     return (data['dashboardTwoCurrentOrders'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getDashboardTwoBestSellerDrivers() async {
//     final data = await _getJsonData();
//     return (data['dashboardTwoBestSellerDrivers'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getDashboardTwoBestSellerProducts() async {
//     final data = await _getJsonData();
//     return (data['dashboardTwoBestSellerProducts'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getDashboardTwoBestSellerStores() async {
//     final data = await _getJsonData();
//     return (data['dashboardTwoBestSellerStores'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<dynamic>> getDashboardTwoNewSubscriptionsChart() async {
//     final data = await _getJsonData();
//     return (data['dashboardTwoNewSubscriptionsChart'] as List<dynamic>?) ?? [];
//   }

//   static Future<List<Map<String, dynamic>>> getAgents() async {
//     return [
//       {
//         "_id": "agent1",
//         "displayName": "منى محمد",
//         "username": "mona_market",
//         "phone": "07722284111",
//         "soldSubscriptions": 50,
//         "revenue": 200000.0,
//         "availablePackages": 5,
//         "isActive": true,
//         "location": {
//           "type": "بغداد، الكرادة، شارع 62",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-05-10T12:00:00.000Z"
//       },
//       {
//         "_id": "agent2",
//         "displayName": "أحمد الكعبي",
//         "username": "alnoor_shop",
//         "phone": "07812345678",
//         "soldSubscriptions": 30,
//         "revenue": 150000.0,
//         "availablePackages": 3,
//         "isActive": false,
//         "location": {
//           "type": "بغداد، محطة القطار",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-04-25T12:00:00.000Z"
//       },
//       {
//         "_id": "agent3",
//         "displayName": "بسمة محمد",
//         "username": "basma_store",
//         "phone": "07598765432",
//         "soldSubscriptions": 70,
//         "revenue": 300000.0,
//         "availablePackages": 7,
//         "isActive": true,
//         "location": {
//           "type": "بغداد، المنصور",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-04-25T12:00:00.000Z"
//       },
//       {
//         "_id": "agent4",
//         "displayName": "زين العابدين",
//         "username": "zain_bazar",
//         "phone": "07733445566",
//         "soldSubscriptions": 45,
//         "revenue": 250000.0,
//         "availablePackages": 6,
//         "isActive": true,
//         "location": {
//           "type": "بغداد، الجادرية",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-06-01T12:00:00.000Z"
//       },
//       {
//         "_id": "agent5",
//         "displayName": "رياض علي",
//         "username": "riyadh_mart",
//         "phone": "07844332211",
//         "soldSubscriptions": 20,
//         "revenue": 100000.0,
//         "availablePackages": 2,
//         "isActive": false,
//         "location": {
//           "type": "بغداد، الكرادة",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-07-05T12:00:00.000Z"
//       },
//       {
//         "_id": "agent6",
//         "displayName": "الهدى للتسوق",
//         "username": "alhuda_shop",
//         "phone": "07755667788",
//         "soldSubscriptions": 80,
//         "revenue": 400000.0,
//         "availablePackages": 8,
//         "isActive": true,
//         "location": {
//           "type": "بغداد، الجامعة",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-05-10T12:00:00.000Z"
//       },
//       {
//         "_id": "agent7",
//         "displayName": "نور ماركت",
//         "username": "noor_market",
//         "phone": "07866554433",
//         "soldSubscriptions": 35,
//         "revenue": 180000.0,
//         "availablePackages": 4,
//         "isActive": true,
//         "location": {
//           "type": "بغداد، العامرية",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-06-01T12:00:00.000Z"
//       },
//       {
//         "_id": "agent8",
//         "displayName": "صفاء بوتيك",
//         "username": "safa_boutique",
//         "phone": "07788990011",
//         "soldSubscriptions": 10,
//         "revenue": 90000.0,
//         "availablePackages": 1,
//         "isActive": false,
//         "location": {
//           "type": "بغداد، الكرادة",
//           "coordinates": [44.3852566, 33.4222599]
//         },
//         "createdAt": "2025-07-20T12:00:00.000Z"
//       }
//     ];
//   }
}

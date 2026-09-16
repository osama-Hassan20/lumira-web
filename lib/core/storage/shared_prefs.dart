import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPrefHelper {
  // Private constructor لمنع إنشاء نسخة (Instance) من الكلاس
  SharedPrefHelper._();

  static SharedPreferences? _prefs;
  // static FlutterSecureStorage? _secure;

  static bool debugLogs = false;

  static void _log(String msg, {Object? error}) {
    if (debugLogs) log(msg, name: "AppStorage", error: error);
  }

  static bool get isReady => _prefs != null;

  static Future<void> init({bool enableLogs = false}) async {
    if (isReady) return;
    debugLogs = enableLogs;

    _prefs = await SharedPreferences.getInstance();
    // _secure = const FlutterSecureStorage(
    //   aOptions: AndroidOptions(encryptedSharedPreferences: true),
    //   iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    // );

    // await _prefs!.clear(); // للتجربة فقط، امسح هذا السطر في الإنتاج

    _log("✅ Initialized successfully");
  }

  static void _guard() {
    if (!isReady) {
      throw Exception("AppStorage not initialized. Call init() first.");
    }
  }

  // ============================================
  // Normal Storage (SharedPreferences)
  // ============================================

  static Future<bool> saveData<T>({
    required String key,
    required T value,
  }) async {
    _guard();
    try {
      if (value is String) return await _prefs!.setString(key, value);
      if (value is int) return await _prefs!.setInt(key, value);
      if (value is bool) return await _prefs!.setBool(key, value);
      if (value is double) return await _prefs!.setDouble(key, value);
      if (value is List<String>) return await _prefs!.setStringList(key, value);

      _log("❌ Unsupported type for $key");
      return false;
    } catch (e) {
      _log("❌ Error saveData($key)", error: e);
      return false;
    }
  }

  static dynamic getData({required String key}) {
    _guard();
    return _prefs?.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    _guard();
    try {
      return await _prefs!.remove(key);
    } catch (e) {
      _log("❌ Error removeData($key)", error: e);
      return false;
    }
  }

  static Future<bool> clearAllData() async {
    _guard();
    try {
      return await _prefs!.clear();
    } catch (e) {
      _log("❌ Error clearAllData", error: e);
      return false;
    }
  }

  static bool containsKey({required String key}) {
    _guard();
    return _prefs!.containsKey(key);
  }

  static Set<String> getAllKeys() {
    _guard();
    return _prefs!.getKeys();
  }

  // ============================================
  // JSON Objects (String Encode/Decode)
  // ============================================

  static Future<bool> saveObject({
    required String key,
    required Map<String, dynamic> json,
  }) async {
    try {
      // log("Saving object for key: $key, data: $json");
      return await saveData(key: key, value: jsonEncode(json));
    } catch (e) {
      _log("❌ Error saveObject($key)", error: e);
      return false;
    }
  }

  static Map<String, dynamic>? getObject({required String key}) {
    try {
      final data = getData(key: key); //img-1772363456711.jpeg
      // log("Retrieved object for key: $key, raw data: $data");
      if (data == null || data.toString().isEmpty) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      _log("❌ Error getObject($key)", error: e);
      return null;
    }
  }

  static Future<bool> saveObjectList(
    String key,
    List<Map<String, dynamic>> list,
  ) async {
    try {
      return await saveData(key: key, value: jsonEncode(list));
    } catch (e) {
      _log("❌ Error saveObjectList($key)", error: e);
      return false;
    }
  }

  static List<Map<String, dynamic>>? getObjectList({required String key}) {
    try {
      final data = getData(key: key);
      if (data == null || data.isEmpty) return null;

      final decoded = jsonDecode(data);
      if (decoded is! List) return null;

      return List<Map<String, dynamic>>.from(
        decoded.map((item) => item as Map<String, dynamic>),
      );
    } catch (e) {
      _log("❌ Error getObjectList($key)", error: e);
      return null;
    }
  }

  // ============================================
  // Secure Storage (Tokens, Passwords, Secrets)
  // ============================================

  // static Future<bool> saveSecureData({
  //   required String key,
  //   required String value,
  // }) async {
  //   _guard();
  //   try {
  //     await _secure!.write(key: key, value: value);
  //     _log("✅ Secure data saved: $key");
  //     return true;
  //   } catch (e) {
  //     _log("❌ saveSecureData($key)", error: e);
  //     return false;
  //   }
  // }

  // static Future<String?> getSecureData({required String key}) async {
  //   _guard();
  //   try {
  //     return await _secure!.read(key: key);
  //   } catch (e) {
  //     _log("❌ getSecureData($key)", error: e);
  //     return null;
  //   }
  // }

  // static Future<bool> removeSecureData({required String key}) async {
  //   _guard();
  //   try {
  //     await _secure!.delete(key: key);
  //     return true;
  //   } catch (e) {
  //     _log("❌ removeSecureData($key)", error: e);
  //     return false;
  //   }
  // }

  // static Future<bool> clearSecureData() async {
  //   _guard();
  //   try {
  //     await _secure!.deleteAll();
  //     _log("✅ All secure data cleared");
  //     return true;
  //   } catch (e) {
  //     _log("❌ clearSecureData", error: e);
  //     return false;
  //   }
  // }

  // static Future<bool> saveSecureObject({
  //   required String key,
  //   required Map<String, dynamic> json,
  // }) async {
  //   try {
  //     return await saveSecureData(key: key, value: jsonEncode(json));
  //   } catch (e) {
  //     _log("❌ Error saveSecureObject($key)", error: e);
  //     return false;
  //   }
  // }

  // static Future<Map<String, dynamic>?> getSecureObject({
  //   required String key,
  // }) async {
  //   try {
  //     final data = await getSecureData(key: key);
  //     if (data == null || data.isEmpty) return null;
  //     return jsonDecode(data) as Map<String, dynamic>;
  //   } catch (e) {
  //     _log("❌ Error getSecureObject($key)", error: e);
  //     return null;
  //   }
  // }

  // ============================================
  // Multiple Operations
  // ============================================

  static Future<bool> saveMultiple({required Map<String, dynamic> data}) async {
    _guard();
    try {
      for (var entry in data.entries) {
        await saveData(key: entry.key, value: entry.value);
      }
      _log("✅ Multiple save completed: ${data.length} items");
      return true;
    } catch (e) {
      _log("❌ saveMultiple failed", error: e);
      return false;
    }
  }

  static Future<Map<String, dynamic>> getMultiple({
    required List<String> keys,
  }) async {
    _guard();
    final result = <String, dynamic>{};

    for (var key in keys) {
      final value = getData(key: key);
      if (value != null) result[key] = value;
    }

    return result;
  }

  // ============================================
  // Full Reset
  // ============================================

  static Future<void> fullReset() async {
    await clearAllData();
    // await clearSecureData();
    _log("🔄 Full reset completed");
  }
}

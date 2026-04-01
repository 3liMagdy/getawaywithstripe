

import 'package:shared_preferences/shared_preferences.dart';

class CustomerStorage {
  static const String _key = "customer_id";

  Future<void> saveCustomerId(String customerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, customerId);
  }

  Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
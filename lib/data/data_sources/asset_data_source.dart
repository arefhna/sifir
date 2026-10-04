import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/errors/app_exception.dart';

class AssetDataSource {
  const AssetDataSource();

  Future<List<Map<String, dynamic>>> loadJsonList(String path) async {
    try {
      final raw = await rootBundle.loadString(path);
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      throw DataException('Data yüklənmədi ($path): $e');
    }
  }

  Future<Map<String, dynamic>> loadJsonObject(String path) async {
    try {
      final raw = await rootBundle.loadString(path);
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      throw DataException('Data yüklənmədi ($path): $e');
    }
  }
}

import 'dart:convert';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../models/player_state_model.dart';
import 'hive_boxes.dart';

class GameStorage {
  const GameStorage();

  Future<void> savePlayer(PlayerState state) async {
    try {
      final json = jsonEncode(state.toJson());
      await HiveBoxes.saveBox.put(AppConstants.currentSaveKey, json);
    } catch (e) {
      throw StorageException('Oyun yadda saxlanılmadı: $e');
    }
  }

  Future<PlayerState?> loadPlayer() async {
    try {
      final raw = HiveBoxes.saveBox.get(AppConstants.currentSaveKey);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return PlayerState.fromJson(json);
    } catch (e) {
      throw StorageException('Oyun yüklənmədi: $e');
    }
  }

  Future<bool> hasSave() async {
    return HiveBoxes.saveBox.containsKey(AppConstants.currentSaveKey);
  }

  Future<void> deleteSave() async {
    await HiveBoxes.saveBox.delete(AppConstants.currentSaveKey);
  }

  Future<void> saveSettings(String key, String value) async {
    await HiveBoxes.settingsBox.put(key, value);
  }

  String? loadSetting(String key) => HiveBoxes.settingsBox.get(key);
}

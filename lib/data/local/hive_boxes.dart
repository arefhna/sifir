import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';

class HiveBoxes {
  HiveBoxes._();

  static late Box<String> saveBox;
  static late Box<String> settingsBox;

  static Future<void> openAll() async {
    saveBox = await Hive.openBox<String>(AppConstants.saveBoxName);
    settingsBox = await Hive.openBox<String>(AppConstants.settingsBoxName);
  }

  static Future<void> clearAll() async {
    await saveBox.clear();
    await settingsBox.clear();
  }
}

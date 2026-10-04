import '../data_sources/asset_data_source.dart';
import '../models/achievement_model.dart';

abstract class AchievementRepository {
  Future<List<Achievement>> loadAchievements();
}

class AchievementRepositoryImpl implements AchievementRepository {
  AchievementRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<Achievement>> loadAchievements() async {
    final list = await _source.loadJsonList('assets/data/achievements.json');
    return list.map(Achievement.fromJson).toList();
  }
}

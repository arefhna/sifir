import '../data_sources/asset_data_source.dart';
import '../models/challenge_model.dart';

abstract class ChallengeRepository {
  Future<List<DailyChallenge>> loadChallenges();
}

class ChallengeRepositoryImpl implements ChallengeRepository {
  ChallengeRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<DailyChallenge>> loadChallenges() async {
    final list = await _source.loadJsonList('assets/data/challenges.json');
    return list.map(DailyChallenge.fromJson).toList();
  }
}

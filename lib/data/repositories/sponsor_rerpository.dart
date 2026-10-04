import '../data_sources/asset_data_source.dart';
import '../models/sponsor_model.dart';

abstract class SponsorRepository {
  Future<List<Sponsor>> loadSponsors();
  Future<List<Sponsor>> loadActiveSponsors({String? placement});
}

class SponsorRepositoryImpl implements SponsorRepository {
  SponsorRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<Sponsor>> loadSponsors() async {
    final list = await _source.loadJsonList('assets/data/sponsors.json');
    return list.map(Sponsor.fromJson).toList();
  }

  @override
  Future<List<Sponsor>> loadActiveSponsors({String? placement}) async {
    final all = await loadSponsors();
    final now = DateTime.now();
    return all.where((s) {
      if (!s.isActiveOn(now)) return false;
      if (placement == null) return true;
      return s.placements.contains(placement);
    }).toList();
  }
}

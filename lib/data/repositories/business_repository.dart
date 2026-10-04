import '../data_sources/asset_data_source.dart';
import '../models/business_model.dart';

abstract class BusinessRepository {
  Future<List<Business>> loadBusinesses();
}

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<Business>> loadBusinesses() async {
    final list = await _source.loadJsonList('assets/data/businesses.json');
    return list.map(Business.fromJson).toList();
  }
}

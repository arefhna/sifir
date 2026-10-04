import '../data_sources/asset_data_source.dart';
import '../models/market_condition_model.dart';
import '../models/product_model.dart';

abstract class MarketRepository {
  Future<List<Product>> loadProducts();
  Future<List<MarketCondition>> loadConditions();
}

class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<Product>> loadProducts() async {
    final list = await _source.loadJsonList('assets/data/products.json');
    return list.map(Product.fromJson).toList();
  }

  @override
  Future<List<MarketCondition>> loadConditions() async {
    final list =
        await _source.loadJsonList('assets/data/market_conditions.json');
    return list.map(MarketCondition.fromJson).toList();
  }
}

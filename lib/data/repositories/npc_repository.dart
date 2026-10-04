import '../data_sources/asset_data_source.dart';
import '../models/npc_model.dart';

abstract class NpcRepository {
  Future<List<Npc>> loadNpcs();
}

class NpcRepositoryImpl implements NpcRepository {
  NpcRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<Npc>> loadNpcs() async {
    final list = await _source.loadJsonList('assets/data/npcs.json');
    return list.map(Npc.fromJson).toList();
  }
}

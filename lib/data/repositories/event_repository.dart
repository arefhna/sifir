import '../data_sources/asset_data_source.dart';
import '../models/event_model.dart';

abstract class EventRepository {
  Future<List<GameEvent>> loadEvents();
}

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl(this._source);

  final AssetDataSource _source;

  @override
  Future<List<GameEvent>> loadEvents() async {
    final list = await _source.loadJsonList('assets/data/events.json');
    return list.map(GameEvent.fromJson).toList();
  }
}

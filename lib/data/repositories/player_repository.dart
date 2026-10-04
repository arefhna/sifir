import '../local/game_storage.dart';
import '../models/player_state_model.dart';

abstract class PlayerRepository {
  Future<PlayerState?> load();
  Future<void> save(PlayerState state);
  Future<void> delete();
  Future<bool> hasSave();
}

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this._storage);

  final GameStorage _storage;

  @override
  Future<PlayerState?> load() => _storage.loadPlayer();

  @override
  Future<void> save(PlayerState state) => _storage.savePlayer(state);

  @override
  Future<void> delete() => _storage.deleteSave();

  @override
  Future<bool> hasSave() => _storage.hasSave();
}

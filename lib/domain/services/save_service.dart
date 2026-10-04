import '../../data/models/player_state_model.dart';
import '../../data/repositories/player_repository.dart';

class SaveService {
  SaveService(this._repository);

  final PlayerRepository _repository;

  Future<void> save(PlayerState state) => _repository.save(state);

  Future<PlayerState?> load() => _repository.load();

  Future<void> delete() => _repository.delete();

  Future<bool> hasSave() => _repository.hasSave();
}

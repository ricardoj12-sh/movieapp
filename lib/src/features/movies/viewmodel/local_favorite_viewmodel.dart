import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/shared/services/local_favorite_service.dart';

final localFavoriteViewModelProvider =
    AsyncNotifierProvider<LocalFavoriteViewModel, Set<int>>(LocalFavoriteViewModel.new);

class LocalFavoriteViewModel extends AsyncNotifier<Set<int>> {
  final LocalFavoriteService _service = LocalFavoriteService();

  @override
  Future<Set<int>> build() async {
    final favorites = await _service.loadFavorites();
    return Set<int>.from(favorites);
  }

  Future<void> toggleFavorite(int movieId) async {
    final isFav = state.value?.contains(movieId) ?? false;

    if (isFav) {
      await _service.removeFavorite(movieId);
      state = AsyncValue.data({...state.value!}..remove(movieId));
    } else {
      await _service.addFavorite(movieId);
      state = AsyncValue.data({...state.value!, movieId});
    }
  }

  bool isFavorite(int movieId) => state.value?.contains(movieId) ?? false;
}

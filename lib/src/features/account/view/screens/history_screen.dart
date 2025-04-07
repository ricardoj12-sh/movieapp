import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/features/movies/view/screens/movie_details_screen.dart';
import 'package:movies/src/features/movies/viewmodel/movies_viewmodel.dart';
import 'package:movies/src/features/movies/models/movie_details.dart';
import 'package:movies/src/core/constants/app_sizes.dart';
import 'package:movies/src/shared/services/local_history_service.dart';

final historyProvider = FutureProvider<List<MovieDetails>>((ref) async {
  final ids = await localHistoryService.loadHistory();
  final movies = <MovieDetails>[];
  for (final id in ids) {
    final details = await ref.read(detailsProvider(id).future);
    movies.add(details);
  }
  return movies;
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recently Viewed')),
      body: history.when(
        data: (movies) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final posterUrl = ref.watch(imageProvider(movie.posterPath));
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movie.id),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 100,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: movie.posterPath.isEmpty
                          ? Image.asset('assets/images/empty_poster.png', height: 100)
                          : Image.network(posterUrl, height: 100),
                    ),
                    gapW12,
                    Expanded(
                      child: Text(
                        movie.title,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

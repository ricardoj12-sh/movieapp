import 'package:movies/src/features/account/repository/firestore_repository.dart';
import 'package:movies/src/features/account/viewmodel/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ← aún necesario para el tipo `User`

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton(this.movieId, {super.key});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreRepositoryProvider);

    // ✅ Usamos el provider desacoplado en vez de FirebaseAuth.instance directamente
    final currentUser = ref.watch(currentUserProvider);
    final userStream = ref.watch(
      userStreamProvider(currentUser?.uid ?? ""),
    );

    return userStream.when(
      data: (user) {
        if (user == null) {
          return IconButton(
            onPressed: null,
            icon: const Icon(Icons.favorite_border),
          );
        }

        final isAdded = user.favorites.contains(movieId);

        return IconButton(
          onPressed: () {
            if (user.uid.isNotEmpty) {
              isAdded
                  ? firestore.removeFromFavorites(user.uid, movieId)
                  : firestore.addToFavorites(user.uid, movieId);
            }
          },
          icon: Icon(
            isAdded ? Icons.favorite : Icons.favorite_border,
            color: isAdded
                ? const Color(0xFFFF8888)
                : Theme.of(context).colorScheme.secondary,
          ),
        );
      },
      error: (error, stackTrace) => IconButton(
        onPressed: null,
        icon: const Icon(Icons.favorite_border),
      ),
      loading: () => IconButton(
        onPressed: null,
        icon: const Icon(Icons.favorite_border),
      ),
    );
  }
}

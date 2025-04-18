import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/core/constants/app_sizes.dart';
import 'package:movies/src/features/account/view/screens/history_screen.dart';
import 'package:movies/src/features/account/view/screens/movie_grid.dart';
import 'package:movies/src/features/account/view/widgets/list_tile.dart';
import 'package:movies/src/features/account/viewmodel/account_viewmodel.dart';
import 'package:movies/src/features/auth/view/screens/welcome_screen.dart';
import 'package:movies/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:movies/src/shared/view/screens/error_screen.dart';
import 'package:movies/src/shared/view/screens/loading_screen.dart';
// 🔥 AGREGADO: importar pantalla de edición de perfil
import 'package:movies/src/features/account/view/screens/edit_profile_screen.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      });
      return const LoadingScreen();
    }

    final userStream = ref.watch(userStreamProvider(currentUser.uid));

    return userStream.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("User not found. Please log in again."),
                  gapH16,
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authViewmodelProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text("Go to Login"),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await ref.read(authViewmodelProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      (route) => false,
                    );
                  }
                },
                label: const Text('Logout'),
                style: TextButton.styleFrom(
                  iconColor: const Color(0xFFFFB1B1),
                  foregroundColor: const Color(0xFFFFB1B1),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      foregroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? NetworkImage(user.photoUrl!)
                          : const AssetImage('assets/images/profile_pic.png') as ImageProvider,
                      radius: 24,
                    ),
                    gapW12,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                gapH32,
                AccountListTile(
                  leading: const Icon(Icons.favorite, color: Color(0xFFFF8888)),
                  title: 'Favorites',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieGrid(title: 'Favorites', movieIds: user.favorites),
                      ),
                    );
                  },
                ),
                gapH8,
                AccountListTile(
                  leading: const Icon(Icons.bookmark, color: Color(0xFF86CBFC)),
                  title: 'Watchlist',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieGrid(title: 'Watchlist', movieIds: user.watchlist),
                      ),
                    );
                  },
                ),
                gapH8,
                AccountListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: 'Recently Viewed',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                ),
                gapH8,
                // 🔥 AGREGADO: opción para editar perfil
                AccountListTile(
                  leading: const Icon(Icons.edit, color: Colors.amber),
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => ErrorScreen(error),
      loading: () => const LoadingScreen(),
    );
  }
}

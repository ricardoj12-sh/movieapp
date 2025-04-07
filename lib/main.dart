import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/firebase_options.dart';
import 'package:movies/src/core/theme/app_theme.dart';
import 'package:movies/src/core/view/main_screen.dart';
import 'package:movies/src/features/auth/view/screens/welcome_screen.dart';
import 'package:movies/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:movies/src/shared/view/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MoviesApp()));
}

class MoviesApp extends ConsumerStatefulWidget {
  const MoviesApp({super.key});

  @override
  ConsumerState<MoviesApp> createState() => _MoviesAppState();
}

class _MoviesAppState extends ConsumerState<MoviesApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    await ref.read(authViewmodelProvider.notifier).restoreSessionIfPossible();
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewmodelProvider);

    if (!_initialized || authState.isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      theme: AppTheme.themeData,
      home: authState.value != null ? const MainScreen() : const WelcomeScreen(),
    );
  }
}
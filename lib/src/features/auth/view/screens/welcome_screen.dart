import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/src/core/constants/app_sizes.dart';
import 'package:movies/src/core/view/main_screen.dart'; // ruta corregida
import 'package:movies/src/features/auth/view/screens/login_screen.dart';
import 'package:movies/src/features/auth/view/screens/sign_up_screen.dart';
import 'package:movies/src/features/auth/view/widgets/auth_button.dart';
import 'package:movies/src/shared/services/session_service.dart'; // ruta corregida

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final sessionService = SessionService();
    final isLoggedIn = await sessionService.hasSession();
    if (!mounted) return;

    if (isLoggedIn) {
      debugPrint('[WelcomeScreen] Usuario ya logueado, navegando a MainScreen');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      debugPrint('[WelcomeScreen] Usuario no logueado, permaneciendo en WelcomeScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/logo58px.svg'),
                  gapH16,
                  Text(
                    'Discover the latest movies',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7), // aún no es obligatorio cambiar
                        ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthButton(
                  onPressed: () {
                    debugPrint('[WelcomeScreen] Navegando a SignupScreen');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Text('Sign up'),
                ),
                gapH12,
                AuthButton(
                  onPressed: () {
                    debugPrint('[WelcomeScreen] Navegando a LoginScreen');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  borderColor: Colors.white.withOpacity(0.5),
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
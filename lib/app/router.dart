import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/home_placeholder_screen.dart';
import 'package:flutter_sanaa_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter_sanaa_app/features/splash/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

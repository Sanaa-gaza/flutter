import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/account_type_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/customer_signup_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/goal_screen.dart';
import 'package:flutter_sanaa_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter_sanaa_app/features/welcome/presentation/welcome_screen.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String goal = '/signup/goal';
  static const String _accountType = '/signup/account-type';
  static const String customerSignup = '/signup/customer';

  static String accountType(SignupGoal goal) => '$_accountType/${goal.name}';
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
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.goal,
        builder: (context, state) => const GoalScreen(),
      ),
      GoRoute(
        path: '${AppRoutes._accountType}/:goal',
        // An unknown goal in the path goes back to the goal screen.
        redirect: (context, state) =>
            _goalFromPath(state.pathParameters['goal']) == null
            ? AppRoutes.goal
            : null,
        builder: (context, state) => AccountTypeScreen(
          goal: _goalFromPath(state.pathParameters['goal'])!,
        ),
      ),
      GoRoute(
        path: AppRoutes.customerSignup,
        builder: (context, state) => const CustomerSignupScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

SignupGoal? _goalFromPath(String? name) {
  for (final goal in SignupGoal.values) {
    if (goal.name == name) return goal;
  }
  return null;
}

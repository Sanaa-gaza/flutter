import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/login_screen.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/verify_code_screen.dart';
import 'package:flutter_sanaa_app/features/home/presentation/home_placeholder_screen.dart';
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
  static const String login = '/login';
  static const String goal = '/signup/goal';
  static const String _accountType = '/signup/account-type';
  static const String customerSignup = '/signup/customer';

  /// Needs a [VerifyCodeArgs] as `extra`. The email stays out of the URL.
  static const String verifyCode = '/verify-code';

  /// Needs the signed-in [UserRole] as `extra`.
  static const String home = '/home';

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
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
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
      GoRoute(
        path: AppRoutes.verifyCode,
        // `extra` is lost if the app restarts on this route: start over.
        redirect: (context, state) =>
            state.extra is VerifyCodeArgs ? null : AppRoutes.welcome,
        builder: (context, state) {
          final args = state.extra! as VerifyCodeArgs;
          return VerifyCodeScreen(email: args.email, purpose: args.purpose);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) =>
            state.extra is UserRole ? null : AppRoutes.welcome,
        builder: (context, state) =>
            HomePlaceholderScreen(role: state.extra! as UserRole),
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

typedef VerifyCodeArgs = ({String email, VerificationPurpose purpose});

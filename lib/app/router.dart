import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/home_placeholder_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePlaceholderScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

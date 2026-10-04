import 'package:go_router/go_router.dart';

import '../../presentation/screens/businesses/businesses_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/main_menu_screen.dart';
import '../../presentation/screens/main_shell.dart';
import '../../presentation/screens/market/market_screen.dart';
import '../../presentation/screens/new_game_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/relationships/relationships_screen.dart';
import '../../presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String mainMenu = '/menu';
  static const String newGame = '/new-game';
  static const String dashboard = '/dashboard';
  static const String market = '/market';
  static const String businesses = '/businesses';
  static const String relationships = '/relationships';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: mainMenu,
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: newGame,
        builder: (context, state) => const NewGameScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: market,
            builder: (context, state) => const MarketScreen(),
          ),
          GoRoute(
            path: businesses,
            builder: (context, state) => const BusinessesScreen(),
          ),
          GoRoute(
            path: relationships,
            builder: (context, state) => const RelationshipsScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

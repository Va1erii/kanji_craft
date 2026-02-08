import 'package:go_router/go_router.dart';
import 'package:kanji_craft_admin/presentation/pages/dashboard_page.dart';
import 'package:kanji_craft_admin/presentation/pages/data_pipeline_page.dart';
import 'package:kanji_craft_admin/presentation/pages/placeholder_page.dart';
import 'package:kanji_craft_admin/presentation/widgets/admin_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/pipeline',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DataPipelinePage(),
          ),
        ),
        GoRoute(
          path: '/review',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PlaceholderPage(title: 'Review'),
          ),
        ),
        GoRoute(
          path: '/browser',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PlaceholderPage(title: 'Browser'),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PlaceholderPage(title: 'Settings'),
          ),
        ),
      ],
    ),
  ],
);

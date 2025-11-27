import 'package:taskflow_app/features/tasks/presentation/pages/task_elements_screen.dart';
import 'package:taskflow_app/shared/screens/app_shell_screen.dart';
import 'package:taskflow_app/shared/screens/home_screen.dart';
import 'package:taskflow_app/features/tasks/presentation/pages/new_task_screen.dart';
import 'package:taskflow_app/shared/screens/settings_screen.dart';
import 'package:taskflow_app/shared/screens/splash_screen.dart';
import 'package:taskflow_app/features/debug/presentation/pages/mock_error_control_screen.dart';
import 'package:taskflow_app/features/tasks/presentation/pages/task_overview_screen.dart';
import 'package:taskflow_app/features/tasks/presentation/pages/task_tracking_screen.dart';
import 'package:taskflow_app/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/products/presentation/pages/product_details_screen.dart';
import 'package:taskflow_app/features/products/presentation/pages/products_list_screen.dart';
import 'package:taskflow_app/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow_app/features/tasks/presentation/pages/task_history_screen.dart';
import 'package:taskflow_app/shared/screens/camera/camera_screen.dart';
import 'package:taskflow_app/shared/screens/camera/image_gallery_screen.dart';
import 'package:taskflow_app/shared/screens/qr/qr_scanner_screen.dart';
import 'package:taskflow_app/shared/screens/connectivity_check_screen.dart';
import 'package:taskflow_app/shared/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
// Add a separate key for the shell navigator
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey, // Add this line
      builder: (context, state, child) {
        return ConnectivityCheckScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const SignInScreen(),
        ),

        // Main shell route with bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            // This shell will contain the bottom navigation and timer banner
            return AppShellScreen(child: child);
          },
          routes: [
            // Routes that should show bottom navigation
            GoRoute(
              path: '/main',
              pageBuilder:
                  (context, state) =>
                      AppPageTransitions.fade(context, state, HomeScreen()),
            ),
            GoRoute(
              path: '/products-list',
              pageBuilder: (context, state) {
                final params = state.extra as Map<String, dynamic>? ?? {};
                var function =
                    params['onProductSelected'] as Function(ProductEntity);
                var locationCode = params['locationCode'] as String;
                var showOnlyAvailable =
                    params['showOnlyAvailable'] as bool? ?? false;
                return AppPageTransitions.fade(
                  context,
                  state,
                  ProductsListScreen(
                    onProductSelected: function,
                    locationCode: locationCode,
                    showOnlyAvailable: showOnlyAvailable,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/task-history',
              pageBuilder:
                  (context, state) => AppPageTransitions.fade(
                    context,
                    state,
                    TaskHistoryScreen(),
                  ),
            ),
            GoRoute(
              path: '/settings',
              pageBuilder:
                  (context, state) =>
                      AppPageTransitions.fade(context, state, SettingsScreen()),
            ),
            GoRoute(
              path: '/task-overview',
              pageBuilder:
                  (context, state) => AppPageTransitions.none(
                    context,
                    state,
                    TaskOverviewScreen(task: state.extra as TaskEntity),
                  ),
            ),
            GoRoute(
              path: '/task-elements',
              pageBuilder:
                  (context, state) => AppPageTransitions.none(
                    context,
                    state,
                    TaskElementsScreen(taskEntity: state.extra as TaskEntity),
                  ),
            ),
            GoRoute(
              path: '/product-details',
              pageBuilder:
                  (context, state) => AppPageTransitions.none(
                    context,
                    state,
                    ProductDetailsScreen(product: state.extra as ProductEntity),
                  ),
            ),
            GoRoute(
              path: '/debug',
              builder: (context, state) => const MockErrorControlScreen(),
            ),
          ],
        ),

        // Routes without bottom navigation
        GoRoute(
          path: '/new-task',
          builder: (context, state) => const NewTaskScreen(),
        ),
        GoRoute(
          path: '/camera',
          builder: (context, state) => const CameraScreen(),
        ),
        GoRoute(
          path: '/image-gallery',
          builder: (context, state) {
            final Map<String, dynamic> params =
                state.extra as Map<String, dynamic>? ?? {};
            return ImageGalleryScreen(
              photos: params['photos'] ?? [],
              initialIndex: params['initialIndex'] ?? 0,
            );
          },
        ),
        GoRoute(
          path: '/task-tracking',
          pageBuilder:
              (context, state) => AppPageTransitions.horizontal(
                context,
                state,
                TaskTrackingScreen(taskEntity: state.extra as TaskEntity),
              ),
        ),
        // Add QR scanner route
        GoRoute(
          path: '/qr-scanner',
          builder: (context, state) => const QrScannerScreen(),
        ),
      ],
    ),
  ],
);

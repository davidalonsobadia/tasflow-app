import 'package:taskflow_app/core/extensions/context_extensions.dart';
import 'package:taskflow_app/features/products/domain/entities/product_entity.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskflow_app/shared/widgets/navbar/custom_bottom_navbar.dart';
import 'package:taskflow_app/shared/widgets/navbar/navbar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppShellScreen extends StatefulWidget {
  final Widget child;

  const AppShellScreen({super.key, required this.child});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  var _selectedBarItem = NavbarItems.home;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Initialize products and tasks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskCubit>().refreshTasks(context.getUserLocationCode());
    });

    // Add app lifecycle listener
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which tab is active based on the current route
    _updateSelectedTab(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // SafeArea with dynamic background color
          Expanded(
            child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
          ),
          // Bottom navigation
          _buildBottomNavBar(context, _selectedBarItem),
        ],
      ),
    );
  }

  void _updateSelectedTab(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.contains('/main')) {
      _selectedBarItem = NavbarItems.home;
    } else if (location.contains('/products-list')) {
      _selectedBarItem = NavbarItems.products;
    } else if (location.contains('/task-history')) {
      _selectedBarItem = NavbarItems.history;
    } else if (location.contains('/settings')) {
      _selectedBarItem = NavbarItems.settings;
    } else if (location.contains('/debug')) {
      _selectedBarItem = NavbarItems.debug;
    }
  }

  Future<void> _animateToPage(
    BuildContext context,
    String route, {
    Object? extra,
  }) async {
    // Start fade out animation
    await _animationController.reverse();
    // // Navigate to the new page
    if (!mounted) return;
    if (extra != null) {
      context.go(route, extra: extra);
    } else {
      context.go(route);
    }
    // // Start fade in animation after a short delay to ensure the new page is ready
    if (mounted) {
      _animationController.forward();
    }
  }

  Widget _buildBottomNavBar(BuildContext context, NavbarItems barItem) {
    return CustomBottomNavBar(
      selectedBarItem: barItem,
      onTap: (item) {
        // If we're already on this tab, don't animate again
        if (item == _selectedBarItem) return;

        setState(() {
          _selectedBarItem = item;
        });

        // Check if we're currently on a main tab route
        final location = GoRouterState.of(context).uri.path;
        final isOnMainTab =
            location.contains('/main') ||
            location.contains('/products-list') ||
            location.contains('/task-history') ||
            location.contains('/settings') ||
            location.contains('/debug');

        if (isOnMainTab) {
          _navigateWithAnimation(context, item);
        } else {
          _navigateDirectly(context, item);
        }
      },
    );
  }

  void _navigateWithAnimation(BuildContext context, NavbarItems item) {
    switch (item) {
      case NavbarItems.home:
        _animateToPage(context, '/main');
        break;
      case NavbarItems.products:
        _animateToPage(
          context,
          '/products-list',
          extra: {
            'onProductSelected': (ProductEntity product) {
              _animationController.forward(from: 0.5);
              context.push('/product-details', extra: product);
            },
            'locationCode': context.getUserLocationCode(),
            'showOnlyAvailable': false,
          },
        );
        break;
      case NavbarItems.history:
        _animateToPage(context, '/task-history');
        break;
      case NavbarItems.settings:
        _animateToPage(context, '/settings');
        break;
      case NavbarItems.debug:
        _animateToPage(context, '/debug');
        break;
    }
  }

  void _navigateDirectly(BuildContext context, NavbarItems item) {
    switch (item) {
      case NavbarItems.home:
        context.go('/main');
        break;
      case NavbarItems.products:
        context.go(
          '/products-list',
          extra: {
            'onProductSelected': (ProductEntity product) {
              context.push('/product-details', extra: product);
            },
            'locationCode': context.getUserLocationCode(),
            'showOnlyAvailable': false,
          },
        );
        break;
      case NavbarItems.history:
        context.go('/task-history');
        break;
      case NavbarItems.settings:
        context.go('/settings');
        break;
      case NavbarItems.debug:
        context.go('/debug');
        break;
    }
  }
}

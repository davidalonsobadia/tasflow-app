import 'package:taskflow_app/core/di/service_locator.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/collaborations/presentation/cubit/collaboration_cubit.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_count_cubit.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_count_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_count_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_list_cubit.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that provides all the application's BloCs/Cubits to its children
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => sl<AuthCubit>()),
        BlocProvider<TaskCubit>(create: (context) => sl<TaskCubit>()),
        BlocProvider<ProductDetailsCubit>(
          create: (context) => sl<ProductDetailsCubit>(),
        ),
        BlocProvider<ProductTaskCubit>(
          create: (context) => sl<ProductTaskCubit>(),
        ),
        BlocProvider<ProductListCubit>(
          create: (context) => sl<ProductListCubit>(),
        ),
        BlocProvider<CommentCubit>(create: (context) => sl<CommentCubit>()),
        BlocProvider<CollaborationCubit>(
          create: (context) => sl<CollaborationCubit>(),
        ),
        BlocProvider<ImageCubit>(create: (context) => sl<ImageCubit>()),
        BlocProvider<ProductsTaskCountCubit>(
          create: (context) => sl<ProductsTaskCountCubit>(),
        ),
        BlocProvider<ImageCountCubit>(
          create: (context) => sl<ImageCountCubit>(),
        ),
        BlocProvider<CommentCountCubit>(
          create: (context) => sl<CommentCountCubit>(),
        ),
        // Add more BlocProviders here as needed
      ],
      child: child,
    );
  }
}

import 'package:taskflow_app/config/app_config.dart';
import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/services/crashlytics_service.dart';
import 'package:taskflow_app/features/images/data/data_sources/image_remote_data_source.dart';
import 'package:taskflow_app/features/images/data/data_sources/image_mock_data_source.dart';
import 'package:taskflow_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:taskflow_app/features/auth/data/data_sources/auth_mock_data_source.dart';
import 'package:taskflow_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskflow_app/features/auth/domain/usecases/check_device_registered.dart';
import 'package:taskflow_app/features/auth/domain/usecases/register_device.dart';
import 'package:taskflow_app/features/auth/domain/usecases/unbind_device.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow_app/features/collaborations/data/data_sources/collaboration_remote_data_source.dart';
import 'package:taskflow_app/features/collaborations/data/repositories/collaboration_repository_impl.dart';
import 'package:taskflow_app/features/collaborations/domain/repositories/collaboration_repository.dart';
import 'package:taskflow_app/features/collaborations/domain/usecases/upload_collaboration.dart';
import 'package:taskflow_app/features/collaborations/presentation/cubit/collaboration_cubit.dart';
import 'package:taskflow_app/features/collaborations/data/data_sources/collaboration_mock_data_source.dart';
import 'package:taskflow_app/features/comments/data/data_sources/comment_remote_data_source.dart';
import 'package:taskflow_app/features/comments/data/data_sources/comment_mock_data_source.dart';
import 'package:taskflow_app/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:taskflow_app/features/comments/domain/repositories/comment_repository.dart';
import 'package:taskflow_app/features/comments/domain/usecases/add_comment.dart';
import 'package:taskflow_app/features/comments/domain/usecases/delete_comment.dart';
import 'package:taskflow_app/features/comments/domain/usecases/get_comments.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_count_cubit.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:taskflow_app/features/images/data/repositories/image_repository_impl.dart';
import 'package:taskflow_app/features/images/domain/repositories/image_repository.dart';
import 'package:taskflow_app/features/images/domain/usecases/add_images.dart';
import 'package:taskflow_app/features/images/domain/usecases/delete_images.dart';
import 'package:taskflow_app/features/images/domain/usecases/get_images.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_count_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_cubit.dart';
import 'package:taskflow_app/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:taskflow_app/features/products/data/data_sources/product_mock_data_source.dart';
import 'package:taskflow_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:taskflow_app/features/products/domain/repositories/product_repository.dart';
import 'package:taskflow_app/features/products/domain/usecases/add_products.dart';
import 'package:taskflow_app/features/products/domain/usecases/delete_products.dart';
import 'package:taskflow_app/features/products/domain/usecases/get_products.dart';
import 'package:taskflow_app/features/products/domain/usecases/transfer_products.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_count_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/products_task_cubit.dart';
import 'package:taskflow_app/features/products/presentation/cubit/product_list_cubit.dart';
import 'package:taskflow_app/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:taskflow_app/features/tasks/data/data_sources/task_mock_data_source.dart';
import 'package:taskflow_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskflow_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskflow_app/features/tasks/domain/usecases/edit_tasks.dart';
import 'package:taskflow_app/features/tasks/domain/usecases/get_tasks.dart';
import 'package:taskflow_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Determine if we should use mock data
  final useMockData = AppConfig.instance.useMockData;

  // Core Services
  sl.registerLazySingleton<DioApiClient>(() => DioApiClient());
  // Use MockCrashlyticsService since Firebase is not configured yet
  // When Firebase is enabled, change this to FirebaseCrashlyticsService()
  sl.registerLazySingleton<CrashlyticsService>(() => MockCrashlyticsService());

  // Data Sources - Register mock or real implementations based on config
  if (useMockData) {
    // Mock implementations
    sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthMockDataSource());
    sl.registerLazySingleton<TaskRemoteDataSource>(() => TaskMockDataSource());
    sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductMockDataSource(),
    );
    sl.registerLazySingleton<CommentRemoteDataSource>(
      () => CommentMockDataSource(),
    );
    sl.registerLazySingleton<CollaborationRemoteDataSource>(
      () => CollaborationMockDataSource(),
    );
    sl.registerLazySingleton<ImageRemoteDataSource>(
      () => ImageMockDataSource(),
    );
  } else {
    // Real API implementations
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<DioApiClient>()),
    );
    sl.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(sl<DioApiClient>()),
    );
    sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(sl<DioApiClient>()),
    );
    sl.registerLazySingleton<CommentRemoteDataSource>(
      () => CommentRemoteDataSourceImpl(sl<DioApiClient>()),
    );
    sl.registerLazySingleton<CollaborationRemoteDataSource>(
      () => CollaborationRemoteDataSourceImpl(sl<DioApiClient>()),
    );
    sl.registerLazySingleton<ImageRemoteDataSource>(
      () => ImageRemoteDataSourceImpl(sl<DioApiClient>()),
    );
  }

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl<TaskRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () =>
        ProductRepositoryImpl(remoteDataSource: sl<ProductRemoteDataSource>()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () =>
        CommentRepositoryImpl(remoteDataSource: sl<CommentRemoteDataSource>()),
  );
  sl.registerLazySingleton<CollaborationRepository>(
    () => CollaborationRepositoryImpl(
      remoteDataSource: sl<CollaborationRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<ImageRepository>(
    () =>
        ImageRepositoryImpl(imageRemoteDataSource: sl<ImageRemoteDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton(
    () => CheckDeviceRegisteredUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => RegisterDeviceUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UnbindDeviceUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetTasksUseCase(sl<TaskRepository>()));
  sl.registerLazySingleton(() => EditTasksUseCase(sl<TaskRepository>()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(
    () => AddProductUseCase(sl<ProductRepository>(), sl<TaskRepository>()),
  );
  sl.registerLazySingleton(() => DeleteProductUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl<CommentRepository>()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl<CommentRepository>()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(sl<CommentRepository>()));
  sl.registerLazySingleton(
    () => UploadCollaborationUseCase(sl<CollaborationRepository>()),
  );
  sl.registerLazySingleton(() => GetImagesUseCase(sl<ImageRepository>()));
  sl.registerLazySingleton(() => AddImagesUseCase(sl<ImageRepository>()));
  sl.registerLazySingleton(() => DeleteImageUseCase(sl<ImageRepository>()));
  sl.registerLazySingleton(
    () => TransferProductsUseCase(sl<ProductRepository>()),
  );

  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      sl<CheckDeviceRegisteredUseCase>(),
      sl<RegisterDeviceUseCase>(),
      sl<UnbindDeviceUseCase>(),
    ),
  );
  sl.registerFactory(
    () => TaskCubit(sl<GetTasksUseCase>(), sl<EditTasksUseCase>()),
  );
  sl.registerFactory(() => ProductDetailsCubit(sl<GetProductsUseCase>()));
  sl.registerFactory(() => ProductListCubit(sl<GetProductsUseCase>()));
  sl.registerFactory(
    () => ProductTaskCubit(
      sl<GetProductsUseCase>(),
      sl<AddProductUseCase>(),
      sl<DeleteProductUseCase>(),
      sl<TransferProductsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => CommentCubit(
      sl<GetCommentsUseCase>(),
      sl<AddCommentUseCase>(),
      sl<DeleteCommentUseCase>(),
    ),
  );
  sl.registerFactory(
    () => CollaborationCubit(sl<UploadCollaborationUseCase>()),
  );
  sl.registerFactory(
    () => ImageCubit(
      sl<GetImagesUseCase>(),
      sl<AddImagesUseCase>(),
      sl<DeleteImageUseCase>(),
    ),
  );
  sl.registerFactory(() => ProductsTaskCountCubit(sl<GetProductsUseCase>()));
  sl.registerFactory(() => ImageCountCubit(sl<GetImagesUseCase>()));
  sl.registerFactory(() => CommentCountCubit(sl<GetCommentsUseCase>()));
}

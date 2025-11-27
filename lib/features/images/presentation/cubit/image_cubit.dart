import 'dart:typed_data';

import 'package:taskflow_app/core/mixins/error_reporting_mixin.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:taskflow_app/features/images/domain/usecases/add_images.dart';
import 'package:taskflow_app/features/images/domain/usecases/delete_images.dart';
import 'package:taskflow_app/features/images/domain/usecases/get_images.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCubit extends Cubit<ImageState> with ErrorReportingMixin {
  final GetImagesUseCase getImagesUseCase;
  final AddImagesUseCase addImagesUseCase;
  final DeleteImageUseCase deleteImagesUseCase;

  ImageCubit(
    this.getImagesUseCase,
    this.addImagesUseCase,
    this.deleteImagesUseCase,
  ) : super(ImageInitial());

  Future<void> getImages(String taskId) async {
    if (state is ImageLoading) {
      return;
    }

    emit(ImageLoading());
    try {
      final imagesCount = await getImagesUseCase.getImagesCount(taskId);
      final imageUploadingPlaceholders = List.generate(
        imagesCount,
        (index) => ImageEntity(
          taskId: taskId,
          fileName: '',
          fileExtension: '',
          imageData: Uint8List(0), // Empty placeholder
          systemId: '',
          isUploading: true,
        ),
      );
      emit(ImageLoaded(imageUploadingPlaceholders));

      final images = await getImagesUseCase.getImages(taskId);
      emit(ImageLoaded(images));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report all operations
        context: 'getImages',
      );
      emit(ImageFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> addImage(String taskId, String filePath) async {
    try {
      // Repository handles optimistic updates internally
      await addImagesUseCase.addImageFromTaskIdAndFilePath(taskId, filePath);

      // Get updated images from repository cache
      final updatedImages = await getImagesUseCase.getImages(taskId);
      emit(ImageLoaded(updatedImages));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - mutation operation
        context: 'addImage',
      );
      emit(ImageFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> deleteImage(String taskId, String systemId) async {
    try {
      // Repository handles optimistic updates internally
      await deleteImagesUseCase.deleteImage(systemId, taskId);

      // Get updated images from repository cache
      final updatedImages = await getImagesUseCase.getImages(taskId);
      emit(ImageLoaded(updatedImages));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - mutation operation
        context: 'deleteImage',
      );
      emit(ImageFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> refreshImages(String taskId) async {
    if (state is ImageLoading) {
      return;
    }

    emit(ImageLoading());
    try {
      final imagesCount = await getImagesUseCase.getImagesCount(taskId);
      final imageUploadingPlaceholders = List.generate(
        imagesCount,
        (index) => ImageEntity(
          taskId: taskId,
          fileName: '',
          fileExtension: '',
          imageData: Uint8List(0), // Empty placeholder
          systemId: '',
          isUploading: true,
        ),
      );
      emit(ImageLoaded(imageUploadingPlaceholders));

      final images = await getImagesUseCase.refreshImages(taskId);
      emit(ImageLoaded(images));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report all operations
        context: 'refreshImages',
      );
      emit(ImageFailure(ErrorHandler.handle(exception)));
    }
  }
}

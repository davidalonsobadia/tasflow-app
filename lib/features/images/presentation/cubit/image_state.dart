import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<ImageEntity> images;

  ImageLoaded(this.images);
}

class ImageFailure extends ImageState {
  final AppError error;

  ImageFailure(this.error);
}

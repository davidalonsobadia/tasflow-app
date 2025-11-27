import 'package:taskflow_app/core/utils/error_handler.dart';

abstract class ImageCountState {}

class ImageCountInitial extends ImageCountState {}

class ImageCountLoading extends ImageCountState {}

class ImageCountLoaded extends ImageCountState {
  final int count;

  ImageCountLoaded(this.count);
}

class ImageCountFailure extends ImageCountState {
  final AppError error;

  ImageCountFailure(this.error);
}

import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/images/domain/usecases/get_images.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_count_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCountCubit extends Cubit<ImageCountState> {
  final GetImagesUseCase getImagesUseCase;

  ImageCountCubit(this.getImagesUseCase) : super(ImageCountInitial());

  Future<void> getImagesCount(String taskId) async {
    emit(ImageCountLoading());
    try {
      final count = await getImagesUseCase.getImagesCount(taskId);
      emit(ImageCountLoaded(count));
    } catch (exception) {
      emit(ImageCountFailure(ErrorHandler.handle(exception)));
    }
  }
}

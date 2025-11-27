import 'package:taskflow_app/features/comments/domain/usecases/get_comments.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_count_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentCountCubit extends Cubit<CommentCountState> {
  final GetCommentsUseCase getCommentsUseCase;

  CommentCountCubit(this.getCommentsUseCase) : super(CommentCountInitial());

  Future<void> getCommentsCount(String taskId) async {
    emit(CommentCountLoading());

    try {
      final count = await getCommentsUseCase.getCommentsCount(taskId);
      emit(CommentCountLoaded(count));
    } catch (exception) {
      emit(CommentCountFailure(exception.toString()));
    }
  }
}

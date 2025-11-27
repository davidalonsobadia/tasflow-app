import 'package:taskflow_app/core/mixins/error_reporting_mixin.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/comments/domain/usecases/add_comment.dart';
import 'package:taskflow_app/features/comments/domain/usecases/delete_comment.dart';
import 'package:taskflow_app/features/comments/domain/usecases/get_comments.dart';
import 'package:taskflow_app/features/comments/presentation/cubit/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CommentCubit extends Cubit<CommentsState> with ErrorReportingMixin {
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  CommentCubit(
    this.getCommentsUseCase,
    this.addCommentUseCase,
    this.deleteCommentUseCase,
  ) : super(CommentsInitial());

  Future<void> addComment(String taskId, String message) async {
    try {
      emit(CommentsLoading());
      // Add the comment using the use case
      await addCommentUseCase.addComment(taskId, message);
      // Get updated comments list
      final updatedComments = await getCommentsUseCase.getComments(taskId);
      emit(CommentsLoaded(updatedComments));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report mutations to Crashlytics
        context: 'addComment',
      );
      emit(CommentsFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> deleteComment(String taskId, String? systemId) async {
    if (systemId == null) {
      emit(
        CommentsFailure(
          AppError(
            message: translate('systemIdIsNull'),
            type: ErrorType.unknown,
          ),
        ),
      );
      return;
    }

    emit(CommentsLoading());
    try {
      await deleteCommentUseCase.deleteComment(systemId, taskId);
      // Get updated comments
      final comments = await getCommentsUseCase.getComments(taskId);
      emit(CommentsLoaded(comments));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report mutations to Crashlytics
        context: 'deleteComment',
      );
      emit(CommentsFailure(ErrorHandler.handle(exception)));
    }
  }

  // Fetch comments from the repository (which handles caching)
  Future<void> getComments(String taskId) async {
    try {
      emit(CommentsLoading());
      final comments = await getCommentsUseCase.getComments(taskId);
      emit(CommentsLoaded(comments));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report all operations
        context: 'getComments',
      );
      emit(CommentsFailure(ErrorHandler.handle(exception)));
    }
  }

  // Refresh comments from the server
  Future<void> refreshComments(String taskId) async {
    try {
      emit(CommentsLoading());
      final comments = await getCommentsUseCase.refreshComments(taskId);
      emit(CommentsLoaded(comments));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report all operations
        context: 'refreshComments',
      );
      emit(CommentsFailure(ErrorHandler.handle(exception)));
    }
  }
}

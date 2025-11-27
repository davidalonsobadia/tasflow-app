import 'package:taskflow_app/core/mixins/error_reporting_mixin.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/collaborations/domain/entities/collaboration_entity.dart';
import 'package:taskflow_app/features/collaborations/domain/usecases/upload_collaboration.dart';
import 'package:taskflow_app/features/collaborations/presentation/cubit/collaboration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollaborationCubit extends Cubit<CollaborationState>
    with ErrorReportingMixin {
  final UploadCollaborationUseCase uploadCollaborationsUseCase;

  CollaborationCubit(this.uploadCollaborationsUseCase)
    : super(CollaborationInitial());

  Future<void> uploadCollaborations(
    String taskId,
    String userId,
    String startingDateTime,
    String endingDateTime,
    String comment,
  ) async {
    emit(CollaborationLoading());

    try {
      CollaborationEntity collaboration = CollaborationEntity(
        taskId: taskId,
        userId: userId,
        startingDateTime: startingDateTime,
        endingDateTime: endingDateTime,
        comment: comment,
      );
      await uploadCollaborationsUseCase.uploadCollaboration(collaboration);
      emit(CollaborationLoaded(collaboration));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - business critical time tracking
        context: 'uploadCollaborations',
      );
      emit(CollaborationFailure(ErrorHandler.handle(exception)));
    }
  }
}

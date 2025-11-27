import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/collaborations/domain/entities/collaboration_entity.dart';

abstract class CollaborationState {}

class CollaborationInitial extends CollaborationState {}

class CollaborationLoading extends CollaborationState {}

class CollaborationLoaded extends CollaborationState {
  final CollaborationEntity collaboration;
  CollaborationLoaded(this.collaboration);
}

class CollaborationFailure extends CollaborationState {
  final AppError error;
  CollaborationFailure(this.error);
}

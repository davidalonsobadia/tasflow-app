abstract class CommentCountState {}

class CommentCountInitial extends CommentCountState {}

class CommentCountLoading extends CommentCountState {}

class CommentCountLoaded extends CommentCountState {
  final int count;
  CommentCountLoaded(this.count);
}

class CommentCountFailure extends CommentCountState {
  final String error;
  CommentCountFailure(this.error);
}

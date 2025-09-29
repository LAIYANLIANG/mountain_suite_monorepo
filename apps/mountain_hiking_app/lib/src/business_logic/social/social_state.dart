part of 'social_bloc.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

// State for when the main feed of posts is loaded
class SocialLoaded extends SocialState {
  final List<SocialPost> posts;
  final bool hasReachedMax; // For pagination

  SocialLoaded({
    this.posts = const [],
    this.hasReachedMax = false,
  });

  SocialLoaded copyWith({
    List<SocialPost>? posts,
    bool? hasReachedMax,
  }) {
    return SocialLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// State for when a single post is updated (e.g., like count)
// This can help avoid rebuilding the entire list
class SocialPostUpdated extends SocialState {
  final SocialPost updatedPost;
  SocialPostUpdated(this.updatedPost);
}

// State for when comments for a post are loaded
class SocialCommentsLoaded extends SocialState {
  final String postId;
  final List<Comment> comments;
  SocialCommentsLoaded({required this.postId, required this.comments});
}

class SocialError extends SocialState {
  final String message;
  SocialError(this.message);
}

class SocialLoadingComments extends SocialState {
  final String postId;
  SocialLoadingComments(this.postId);
}

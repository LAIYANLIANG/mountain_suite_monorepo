part of 'social_bloc.dart';

@immutable
abstract class SocialEvent {}

// Fired to fetch the initial batch or subsequent pages of posts
class FetchSocialPosts extends SocialEvent {}

// Fired when a user creates a new post
class CreatePost extends SocialEvent {
  final String content;
  final File? image;
  CreatePost({required this.content, this.image});
}

// Fired when a user likes or unlikes a post
class ToggleLikePost extends SocialEvent {
  final String postId;
  ToggleLikePost({required this.postId});
}

// Fired to fetch all comments for a given post
class FetchComments extends SocialEvent {
  final String postId;
  FetchComments({required this.postId});
}

// Fired when a user adds a new comment
class AddComment extends SocialEvent {
  final String postId;
  final String text;
  AddComment({required this.postId, required this.text});
}
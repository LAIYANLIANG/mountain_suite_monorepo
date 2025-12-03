import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/social_post_model.dart';
import 'package:mountain_hiking_app/src/data/services/social_api_service.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialApiService _socialApiService;
  final AuthBloc _authBloc;

  SocialBloc({
    required SocialApiService socialApiService,
    required AuthBloc authBloc,
  })  : _socialApiService = socialApiService,
        _authBloc = authBloc,
        super(SocialInitial()) {
    on<FetchSocialPosts>(_onFetchSocialPosts);
    on<CreatePost>(_onCreatePost);
    on<ToggleLikePost>(_onToggleLikePost);
    on<FetchComments>(_onFetchComments);
    on<AddComment>(_onAddComment);
  }

  Future<void> _onFetchSocialPosts(FetchSocialPosts event, Emitter<SocialState> emit) async {
    if (state is SocialLoaded && (state as SocialLoaded).hasReachedMax) {
      return; // No more posts to fetch
    }

    try {
      if (state is SocialInitial || state is! SocialLoaded) {
        emit(SocialLoading());
        final posts = await _socialApiService.getSocialPosts();
        emit(SocialLoaded(posts: posts, hasReachedMax: posts.isEmpty));
      } else {
        // Pagination: Fetch more posts
        final currentState = state as SocialLoaded;
        final lastDocId = currentState.posts.last.id;
        final lastDoc = await _socialApiService.getPostDocument(lastDocId);

        final posts = await _socialApiService.getSocialPosts(lastDoc: lastDoc);
        emit(posts.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : currentState.copyWith(
                posts: List.of(currentState.posts)..addAll(posts),
                hasReachedMax: false,
              ));
      }
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<SocialState> emit) async {
    final authState = _authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(SocialError("使用者未登入，無法發布貼文。"));
      return;
    }

    try {
      emit(SocialLoading()); // Consider a more specific "Posting" state
      await _socialApiService.createPost(
        userId: authState.userId,
        // In a real app, fetch user profile for name and avatar
        userName: authState.userId, // Placeholder
        userAvatarUrl: '', // Placeholder
        content: event.content,
        image: event.image,
      );
      add(FetchSocialPosts()); // Refresh the post list
    } catch (e) {
      emit(SocialError("建立貼文失敗: ${e.toString()}"));
    }
  }

  Future<void> _onToggleLikePost(ToggleLikePost event, Emitter<SocialState> emit) async {
    final authState = _authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(SocialError("請先登入才能點讚。"));
      return;
    }

    if (state is! SocialLoaded) return;

    final currentState = state as SocialLoaded;
    final List<SocialPost> currentPosts = List.from(currentState.posts);
    final int postIndex = currentPosts.indexWhere((p) => p.id == event.postId);
    if (postIndex == -1) return;

    final postToUpdate = currentPosts[postIndex];
    final bool isLiked = await _socialApiService.isPostLikedByUser(postId: event.postId, userId: authState.userId);

    // Optimistic UI update
    final updatedPost = postToUpdate.copyWith(
      likeCount: isLiked ? postToUpdate.likeCount - 1 : postToUpdate.likeCount + 1,
    );
    currentPosts[postIndex] = updatedPost;
    emit(currentState.copyWith(posts: currentPosts));

    try {
      await _socialApiService.toggleLikePost(postId: event.postId, userId: authState.userId);
      // Optionally, refetch the single post to ensure data consistency
    } catch (e) {
      // Revert on error
      currentPosts[postIndex] = postToUpdate;
      emit(currentState.copyWith(posts: currentPosts));
      emit(SocialError("點讚失敗: ${e.toString()}"));
    }
  }

  Future<void> _onFetchComments(FetchComments event, Emitter<SocialState> emit) async {
    emit(SocialLoadingComments(event.postId));
    try {
      final comments = await _socialApiService.getComments(event.postId);
      emit(SocialCommentsLoaded(postId: event.postId, comments: comments));
    } catch (e) {
      emit(SocialError(e.toString()));
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<SocialState> emit) async {
    final authState = _authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(SocialError("請先登入才能留言。"));
      return;
    }

    try {
      await _socialApiService.addComment(
        postId: event.postId,
        userId: authState.userId,
        // In a real app, fetch user profile for name and avatar
        userName: authState.userId, // Placeholder
        userAvatarUrl: '', // Placeholder
        text: event.text,
      );
      // After adding a comment, refetch the comments for that post
      add(FetchComments(postId: event.postId));
      // Also, refetch the main posts to update the comment count
      add(FetchSocialPosts());
    } catch (e) {
      emit(SocialError("留言失敗: ${e.toString()}"));
    }
  }
}
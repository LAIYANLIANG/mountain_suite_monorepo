import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/social/social_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/social_post_model.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';
import 'package:intl/intl.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The BLoC is already provided higher up in the widget tree (main.dart)
    // So we can directly use it.
    return const _SocialView();
  }
}

class _SocialView extends StatefulWidget {
  const _SocialView();

  @override
  State<_SocialView> createState() => _SocialViewState();
}

class _SocialViewState extends State<_SocialView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial fetch
    context.read<SocialBloc>().add(FetchSocialPosts());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<SocialBloc>().add(FetchSocialPosts());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: AppBar(
        title: const Text('社群分享'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<SocialBloc, SocialState>(
        builder: (context, state) {
          if (state is SocialInitial || (state is SocialLoading && state is! SocialLoaded)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SocialError) {
            return Center(child: Text('錯誤: ${state.message}'));
          }
          if (state is SocialLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('還沒有任何貼文，快來分享吧！'));
            }
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final post = state.posts[index];
                return _buildSocialPostCard(context, post);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSocialPostCard(BuildContext context, SocialPost post) {
    final authState = context.watch<AuthBloc>().state;
    final currentUserId = authState is AuthAuthenticated ? authState.userId : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(post.userAvatarUrl.isNotEmpty ? post.userAvatarUrl : 'https://i.pravatar.cc/50?u=${post.userId}')),
                const SizedBox(width: 8.0),
                Text(post.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(DateFormat('MMM dd, HH:mm').format(post.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
              ],
            ),
            const SizedBox(height: 12.0),
            // Content
            Text(post.content, style: const TextStyle(fontSize: 16.0)),
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Image.network(post.imageUrl!, fit: BoxFit.cover, width: double.infinity, height: 200, errorBuilder: (c, e, s) => const SizedBox.shrink()),
              ),
            const SizedBox(height: 12.0),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: currentUserId != null ? () => context.read<SocialBloc>().add(ToggleLikePost(postId: post.id)) : null,
                  icon: const Icon(Icons.thumb_up_alt_outlined), // Icon state can be improved later
                  label: Text('${post.likeCount} 讚'),
                ),
                TextButton.icon(
                  onPressed: () => _showCommentsDialog(context, post.id, post.commentCount),
                  icon: const Icon(Icons.comment_outlined),
                  label: Text('${post.commentCount} 評論'),
                ),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.share_outlined), label: const Text('分享')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    File? selectedImage;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('建立新貼文'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: contentController, decoration: const InputDecoration(hintText: '分享你的想法...'), maxLines: 5),
                  const SizedBox(height: 10),
                  if (selectedImage != null) Image.file(selectedImage!, height: 100),
                  TextButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('選擇圖片'),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setDialogState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('取消')),
            TextButton(
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  context.read<SocialBloc>().add(CreatePost(content: contentController.text, image: selectedImage));
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('發佈'),
            ),
          ],
        );
      },
    );
  }

  void _showCommentsDialog(BuildContext context, String postId, int initialCommentCount) {
    final TextEditingController commentController = TextEditingController();
    final socialBloc = context.read<SocialBloc>();
    socialBloc.add(FetchComments(postId: postId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: socialBloc,
          child: SizedBox(
            height: MediaQuery.of(dialogContext).size.height * 0.75,
            child: Column(
              children: [
                AppBar(title: Text('$initialCommentCount 則評論'), automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(dialogContext))]),
                Expanded(
                  child: BlocBuilder<SocialBloc, SocialState>(
                    builder: (context, state) {
                      if (state is SocialLoadingComments) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SocialCommentsLoaded && state.postId == postId) {
                        return ListView.builder(
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            return ListTile(
                              leading: CircleAvatar(backgroundImage: NetworkImage(comment.userAvatarUrl.isNotEmpty ? comment.userAvatarUrl : 'https://i.pravatar.cc/50?u=${comment.userId}')),
                              title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(comment.text),
                              trailing: Text(DateFormat('HH:mm').format(comment.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                            );
                          },
                        );
                      }
                      return const Center(child: Text('載入留言中...'));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(dialogContext).viewInsets.bottom, left: 8, right: 8, top: 8),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: commentController, decoration: const InputDecoration(hintText: '新增評論...', border: OutlineInputBorder()))),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {
                            socialBloc.add(AddComment(postId: postId, text: commentController.text));
                            commentController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

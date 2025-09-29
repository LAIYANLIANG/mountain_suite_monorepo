import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mountain_hiking_app/src/data/models/social_post_model.dart';

class SocialApiService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  SocialApiService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  // --- Post Management ---

  Future<void> createPost({
    required String userId,
    required String userName,
    required String userAvatarUrl,
    required String content,
    File? image,
  }) async {
    String? imageUrl;
    if (image != null) {
      final imageRef = _storage.ref().child('post_images/${DateTime.now().millisecondsSinceEpoch}');
      await imageRef.putFile(image);
      imageUrl = await imageRef.getDownloadURL();
    }

    final newPost = SocialPost(
      id: '', // Firestore will generate this
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      content: content,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
    );

    await _firestore.collection('posts').add(newPost.toFirestore());
  }

  Future<List<SocialPost>> getSocialPosts({DocumentSnapshot? lastDoc, int limit = 10}) async {
    Query query = _firestore.collection('posts').orderBy('timestamp', descending: true).limit(limit);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => SocialPost.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostDocument(String postId) async {
    return await _firestore.collection('posts').doc(postId).get();
  }

  // --- Comment Management ---

  Future<void> addComment({
    required String postId,
    required String userId,
    required String userName,
    required String userAvatarUrl,
    required String text,
  }) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final commentRef = postRef.collection('comments').doc();

    final newComment = Comment(
      id: commentRef.id,
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      text: text,
      timestamp: DateTime.now(),
    );

    // Use a transaction to ensure atomicity
    await _firestore.runTransaction((transaction) async {
      transaction.set(commentRef, newComment.toFirestore());
      transaction.update(postRef, {'commentCount': FieldValue.increment(1)});
    });
  }

  Future<List<Comment>> getComments(String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .get();
    return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
  }

  // --- Like Management ---

  Future<void> toggleLikePost({required String postId, required String userId}) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);

      if (likeDoc.exists) {
        // User has already liked the post, so unlike it.
        transaction.delete(likeRef);
        transaction.update(postRef, {'likeCount': FieldValue.increment(-1)});
      } else {
        // User has not liked the post, so like it.
        transaction.set(likeRef, {'likedAt': FieldValue.serverTimestamp()});
        transaction.update(postRef, {'likeCount': FieldValue.increment(1)});
      }
    });
  }
  
  Future<bool> isPostLikedByUser({required String postId, required String userId}) async {
      final likeDoc = await _firestore.collection('posts').doc(postId).collection('likes').doc(userId).get();
      return likeDoc.exists;
  }
}
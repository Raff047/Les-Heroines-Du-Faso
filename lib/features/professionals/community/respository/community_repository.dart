import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/core/providers/firebase_providers.dart';
import 'package:health_app/core/type_defs.dart';

import 'package:health_app/models/Community.dart';
import 'package:health_app/models/post_model.dart';

import '../../../../models/comment_model.dart';

// CLASS PROVIDER
final professionalCommunityRepositoryProvider = Provider(
    (ref) => ProfessionalCommunityRepository(ref.read(firestoreProvider)));

class ProfessionalCommunityRepository {
  final FirebaseFirestore _firestore;

  ProfessionalCommunityRepository(this._firestore);

  CollectionReference get _post => _firestore.collection('posts');
  CollectionReference get communities => _firestore.collection('community');

  // getCommunitiesData
  Future<List<Community>> getCommunities() async {
    final snapshot = await _firestore.collection('community').get();

    List<Community> communities = [];
    for (var doc in snapshot.docs) {
      communities.add(Community.fromMap(doc.data()));
    }

    return communities;
  }

  // add post
  FutureVoid uploadPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // delete post
  FutureVoid deletePost(String postId, BuildContext context) async {
    try {
      return right(await _post.doc(postId).delete());
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // update post
  FutureVoid updatePost(String postId, String postContent) async {
    try {
      return right(
          await _post.doc(postId).update({'description': postContent}));
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // like posts
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _post.doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _post.doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // post a comment
  FutureEither<String> postComment(CommunityComment comment) async {
    try {
      await _post
          .doc(comment.postId)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toMap());

      return right('Comment posted.');
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // load stream of comments
  Stream<List<CommunityComment>> loadComments(String postId) {
    return _post
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((event) {
      final List<CommunityComment> comments = [];
      for (var doc in event.docs) {
        var comment =
            CommunityComment.fromMap(doc.data() as Map<String, dynamic>);
        comments.add(comment);
      }
      return comments;
    });
  }

  // load stream of postsById
  Stream<Post> getPostById(String postId) {
    return _post
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  // load posts to communites
  Stream<List<Post>> loadPosts(Community selectedCommunity) {
    return _post
        .where('communityName', isEqualTo: selectedCommunity.name)
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((event) {
      final List<Post> posts = [];
      for (var doc in event.docs) {
        var post = Post.fromMap(doc.data() as Map<String, dynamic>);
        posts.add(post);
      }
      return posts;
    });
  }
}
  



// final snapshot = _post.snapshots().map((event) {
//       final List<Post> posts = [];
//       for (var doc in event.docs) {
//         var post = Post.fromMap(doc.data() as Map<String, dynamic>);
//         posts.add(post);
//       }
//       return posts;
//     });
//     return snapshot;

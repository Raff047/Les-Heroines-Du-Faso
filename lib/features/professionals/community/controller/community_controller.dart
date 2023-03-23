import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/professionals/community/respository/community_repository.dart';
import 'package:health_app/features/public_user/community/screens/community_main.dart';
import 'package:health_app/models/Community.dart';
import 'package:health_app/models/post_model.dart';
import '../../../../core/common/widgets/show_snack_bar.dart';
import '../../../../core/type_defs.dart';
import '../../../../models/comment_model.dart';
import '../../../auth/controller/auth_controller.dart';

// CLASS PROVIDER
final professionalCommunityControllerProvider =
    Provider((ref) => ref.read(professionalCommunityRepositoryProvider));

// getCommmunities Provider
final getCommunitiesProvider = FutureProvider<List<Community>>((ref) {
  final professionalCommunityController =
      ref.read(professionalCommunityControllerProvider);
  return professionalCommunityController.getCommunities();
});

// load posts provider
final loadPostsStreamProvider =
    StreamProvider.family((ref, Community selectedCommunity) {
  final professionalCommunityController =
      ref.watch(professionalCommunityControllerProvider);

  return professionalCommunityController.loadPosts(selectedCommunity);
});

// get postById Stream provider
final getPostByIdStreamProvider = StreamProvider.family((ref, String postId) {
  final professionalCommunityController =
      ref.read(professionalCommunityControllerProvider);

  return professionalCommunityController.getPostById(postId);
});

// get comments stream provider
final getCommentsStreamProvider = StreamProvider.family((ref, String postId) {
  final professionalCommunityController =
      ref.read(professionalCommunityControllerProvider);

  return professionalCommunityController.loadComments(postId);
});

class ProfessionalCommunityController {
  final ProfessionalCommunityRepository _professionalCommunityRepository;
  final ProviderRef ref;

  ProfessionalCommunityController(
      this._professionalCommunityRepository, this.ref);

  // getCommunitiesData
  Future<List<Community>> getCommunities() async {
    final communities = await _professionalCommunityRepository.getCommunities();
    return communities;
  }

  // add post
  void uploadPost(Post post, BuildContext context) {
    try {
      _professionalCommunityRepository.uploadPost(post);
      showSnackBar(context: context, content: 'Posted!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // delete post
  void deletePost(String postId, BuildContext context) async {
    final res =
        await _professionalCommunityRepository.deletePost(postId, context);

    res.fold((l) => null,
        (r) => showSnackBar(context: context, content: 'Post deleted'));
  }

  // update post
  void updatePost(
      String postId, String postContent, BuildContext context) async {
    final res =
        await _professionalCommunityRepository.updatePost(postId, postContent);

    res.fold((l) => null,
        (r) => showSnackBar(context: context, content: 'Post deleted'));
  }

  // like posts
  Future<void> likePost(String postId, String uid, List likes) {
    return _professionalCommunityRepository.likePost(postId, uid, likes);
  }

  // post comment
  FutureEither<String> postComment(CommunityComment comment) async {
    return _professionalCommunityRepository.postComment(comment);
  }

  // load stream of comments
  Stream<List<CommunityComment>> loadComments(String postId) {
    return _professionalCommunityRepository.loadComments(postId);
  }

  // load posts to communities
  Stream<List<Post>> loadPosts() {
    // print(_professionalCommunityRepository.loadPosts());
    final selectedCommunity = ref.watch(selectedCommunityProvider);

    return _professionalCommunityRepository.loadPosts(selectedCommunity);
  }

  // load post by Id
  // load stream of postsById
  Stream<Post> getPostById(String postId) {
    return _professionalCommunityRepository.getPostById(postId);
  }

  ///////////////////////////////////////////////////////
  ///
  _getUserRole() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final tokenResult = await currentUser.getIdTokenResult();
        final userRole = tokenResult.claims?['role'];
        if (userRole == 'manager') {
          return ref.read(managerUserProvider);
        } else if (userRole == 'professional') {
          return ref.read(professionalUserProvider);
        } else if (userRole == '') {
          return ref.read(publicUserProvider);
        }
      }
    } catch (e) {
      print('Error getting user role: $e');
    }
  }
}

//////////////////////////////////////////////////////////////



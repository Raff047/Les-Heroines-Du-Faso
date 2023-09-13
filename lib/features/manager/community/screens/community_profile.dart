// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/no_posts.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:uuid/uuid.dart';

import 'package:health_app/core/common/repositories/common_firebase_storage_methods.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/core/common/widgets/pick_image.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/manager/community/screens/post_page.dart';
import 'package:health_app/features/professionals/community/controller/community_controller.dart';
import 'package:health_app/features/public_user/community/screens/community_main.dart';
import 'package:health_app/models/post_model.dart';
import 'package:health_app/theme/pallete.dart';

import '../../../../core/common/repositories/utils.dart';
import '../../../../core/common/widgets/expanded_text.dart';

final communityProvider =
    Provider((ref) => ref.watch(selectedCommunityProvider));

class ManagerCommunityProfileScreen extends ConsumerStatefulWidget {
  const ManagerCommunityProfileScreen({super.key});

  // const ManagerCommunityProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerCommunityProfileScreenState();
}

class _ManagerCommunityProfileScreenState
    extends ConsumerState<ManagerCommunityProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final community = ref.watch(selectedCommunityProvider);
    final manager = ref.watch(managerUserProvider);

    final postsStream =
        ref.watch(professionalCommunityControllerProvider).loadPosts(community);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          // sliver app bar
          SliverAppBar(
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_sharp)),
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              background: Image.asset(
                community.banner,
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              ),
              title: Text(
                community.name,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),

          // add post box
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Pallete.blackColor,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(manager!.profilePic),
                      radius: 20,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        onTap: () {
                          Future(() => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return const ShowAddPostScreen();
                              }));
                        },
                        readOnly: true,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'À quoi penses-tu ?'),
                      ),
                    ),
                    const Icon(
                      Icons.image,
                      color: Colors.green,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // stream posts
          StreamBuilder<List<Post>>(
            stream: postsStream, // your stream of post data
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot == null) {
                // Show a message if there is no data or if the data is empty
                return const SliverToBoxAdapter(
                  child: Loader(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: NoPosts(),
                  ),
                );
              }

              final posts = snapshot.data!;
              final List<Post> unPinnedPosts = [];
              final List<Post> pinnedPosts = [];
              for (final post in posts) {
                if (post.isPinned) {
                  pinnedPosts.add(post);
                } else {
                  unPinnedPosts.add(post);
                }
              }

              return MultiSliver(pushPinnedChildren: true, children: <Widget>[
                // pinned posts
                pinnedPosts.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12.0, top: 10.0),
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Icon(
                                    MdiIcons.pin,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: pinnedPosts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemExtent:
                                      MediaQuery.of(context).size.width * .8,
                                  itemBuilder: ((context, index) {
                                    final post = pinnedPosts[index];

                                    return PostCard(
                                      border: Border.all(
                                          width: 1, color: Pallete.greenColor),
                                      borderRadius: BorderRadius.circular(16.0),
                                      // bgColor: Pallete.bgLighterShade,
                                      profilePic: post.userProfilePic,
                                      name: post.username,
                                      content: post.description,
                                      likes: post.likes,
                                      commentCount:
                                          post.commentCount.toString(),
                                      imagePost: post.image,
                                      createdAt: post.postedAt,
                                      postUserUid: post.userUid,
                                      postId: post.id,
                                      authorRole: post.userRole,
                                      isPinned: post.isPinned,
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),

                // regular posts
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = unPinnedPosts[index];

                      return IntrinsicHeight(
                        child: PostCard(
                          border: Border(
                            bottom: BorderSide(
                              width: .5,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          bgColor: Pallete.blackColor,
                          profilePic: post.userProfilePic,
                          name: post.username,
                          content: post.description,
                          likes: post.likes,
                          commentCount: post.commentCount.toString(),
                          imagePost: post.image,
                          createdAt: post.postedAt,
                          postUserUid: post.userUid,
                          postId: post.id,
                          authorRole: post.userRole,
                          isPinned: post.isPinned,
                        ),
                      );
                    },
                    childCount: unPinnedPosts.length,
                  ),
                )
              ]);
            },
          ),
        ],
      ),
    );
  }
}

// post card
class PostCard extends ConsumerStatefulWidget {
  PostCard(
      {Key? key,
      required this.profilePic,
      required this.name,
      required this.content,
      required this.likes,
      required this.commentCount,
      required this.imagePost,
      required this.createdAt,
      required this.postUserUid,
      required this.authorRole,
      required this.postId,
      required this.isPinned,
      this.bgColor,
      this.borderRadius,
      this.border});

  final String profilePic;
  final String name;
  final String content;
  final List<String> likes;
  final String commentCount;
  final String imagePost;
  final DateTime createdAt;
  final String postUserUid;
  final String authorRole;
  final String postId;
  bool? isPinned;
  Post? post;
  final Color? bgColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool isLiked = false;
  int likeCount = 0;

  // delete post
  void deletePost(String postId) {
    ref
        .read(professionalCommunityControllerProvider)
        .deletePost(widget.postId, context);
    Navigator.pop(context);
  }

  // update post
  void updatePost(String postId, String content, BuildContext context) {
    ref
        .read(professionalCommunityControllerProvider)
        .updatePost(widget.postId, widget.content);
    Navigator.pop(context);
  }

  void pinPost() async {
    final docRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    await docRef.update({
      'isPinned': !(widget.isPinned!),
    });

    setState(() {
      widget.isPinned = !widget.isPinned!;
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  bool isManager() {
    final role = ref.read(userRoleProvider).value;

    return (role == 'manager') ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(managerUserProvider);

    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: widget.bgColor,
          border: widget.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.profilePic,
                ),
                radius: 20,
              ),
              const SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RichText(
                  //     text: TextSpan(text: widget.name, children: [
                  //   (isManager() && widget.authorRole == 'manager')
                  //       ? const TextSpan(
                  //           text: ' - Gestionnaire',
                  //           style: TextStyle(
                  //               fontSize: 12.0, color: Colors.white54))
                  //       : const TextSpan(),
                  // ])),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    'il y a ${getTimeDifference(widget.createdAt)}',
                    style: const TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((context) {
                          return Container(
                            width: double.infinity,
                            color: Pallete.bgDarkerShade,
                            height: 120,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(widget.isPinned!
                                      ? MdiIcons.pinOff
                                      : MdiIcons.pin),
                                  title: widget.isPinned!
                                      ? const Text('Unpin')
                                      : const Text('Pin'),
                                  onTap: () {
                                    pinPost();
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Supprimer'),
                                  onTap: () => deletePost(widget.postId),
                                ),
                              ],
                            ),
                          );
                        }));
                  },
                  icon: const Icon(Icons.more_horiz)),
            ],
          ),
          //Post Image
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.imagePost != ''
                    ? Expanded(
                        child: Container(
                          height: 220,
                          margin: const EdgeInsets.only(top: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: NetworkImage(widget.imagePost),
                                  fit: BoxFit.cover)),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 15.0),
                widget.content.length >= 140
                    ? FittedBox(
                        child: Expanded(
                          child: ExpandableText(
                            text: widget.content,
                            maxLength: widget.content.length ~/ 2,
                          ),
                        ),
                      )
                    : IntrinsicHeight(
                        child: Text(
                          widget.content,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: LikeButton(
                  isLiked: isLiked,
                  likeCount: widget.likes.length,
                  onTap: (isLiked) async {
                    await ref
                        .watch(professionalCommunityControllerProvider)
                        .likePost(widget.postId, manager!.uid, widget.likes);
                    setState(() {
                      this.isLiked = !this.isLiked;
                      this.isLiked ? likeCount++ : likeCount--;
                    });
                    return Future.value(!isLiked);
                  },
                ),
              ),

              const SizedBox(width: 10.0),
              // comments
              FittedBox(
                child: LikeButton(
                  likeBuilder: (isLiked) {
                    return Icon(
                      Icons.comment,
                      color: Colors.green.shade300,
                    );
                  },
                  onTap: (isLiked) {
                    return Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ManagerCommunityPostScreen(
                                widget.postId, widget.imagePost))));
                  },
                ),
              ),
              const SizedBox(width: 4.0),
              Text(widget.commentCount),
              Expanded(child: Container()),
              FittedBox(
                child: Text(
                  DateFormat.yMd().add_Hms().format(widget.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ), // comments
            ],
          )
        ],
      ),
    );
  }
}

//show bottom sheet modal (posting)

class ShowAddPostScreen extends ConsumerStatefulWidget {
  const ShowAddPostScreen({
    super.key,
  });
  @override
  _ShowPostScreenState createState() => _ShowPostScreenState();
}

@override
ConsumerState<ConsumerStatefulWidget> createState() => _ShowPostScreenState();

class _ShowPostScreenState extends ConsumerState<ShowAddPostScreen> {
  File? _imagePost;
  static String? _postContent;
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  //for selecting profile image
  void pickImage() async {
    _imagePost = await selectImage(context);
    setState(() {});
  }

  void uploadPost() async {
    _postController.clear();
    imageCache.clear();
    Navigator.pop(context);

    final community = ref.watch(selectedCommunityProvider);
    final manager = ref.watch(managerUserProvider);
    if (_postContent != null) {
      const postId = Uuid();
      Post newPost = Post(
          id: postId.v4(),
          description: _postContent!,
          image: _imagePost == null
              ? ''
              : await ref
                  .read(commonFirebaseStorageMethodsProvider)
                  .storeFileToFirebase('Posts/${postId.v4()}', _imagePost!),
          communityName: community.name,
          likes: [],
          commentCount: 0,
          username: manager!.name,
          userUid: manager.uid,
          userProfilePic: manager.profilePic,
          postedAt: DateTime.now(),
          userRole: manager.role,
          isPinned: false);

      //pass newPost to the controller;
      ref.watch(professionalCommunityControllerProvider).uploadPost(newPost);
      _postContent = null;
    } else {
      showSnackBar(
          context: context, content: 'Vous devez remplir le champ de texte ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(managerUserProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var heightOfModalBottomSheet = screenHeight * 0.92;
    return Container(
      padding: const EdgeInsets.all(25),
      width: screenWidth,
      height: heightOfModalBottomSheet,
      color: Pallete.blackColor,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Pallete.blackColor,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(manager!.profilePic),
                  radius: 20,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Text(
                  manager.name,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    pickImage();
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.image,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _imagePost != null
              ? Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: FileImage(_imagePost!), fit: BoxFit.cover)),
                  ),
                )
              : Container(),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _postContent = value;
                });
              },
              controller: _postController,
              maxLines: 8,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  isCollapsed: true,
                  hintText: 'À quoi penses-tu ?'),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 4, backgroundColor: yellowish),
              onPressed: uploadPost,
              child: const Text('Post'))
        ],
      ),
    );
  }
}

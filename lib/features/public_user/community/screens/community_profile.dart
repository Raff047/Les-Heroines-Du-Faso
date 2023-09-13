// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/repositories/utils.dart';
import 'package:health_app/core/common/widgets/expanded_text.dart';
import 'package:health_app/core/common/widgets/no_posts.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/features/public_user/community/screens/community_main.dart';
import 'package:health_app/features/public_user/community/screens/post_page.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:uuid/uuid.dart';
import 'package:health_app/core/common/repositories/common_firebase_storage_methods.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/core/common/widgets/pick_image.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/community/controller/community_controller.dart';
import 'package:health_app/models/post_model.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:like_button/like_button.dart';

final communityProvider =
    Provider((ref) => ref.watch(selectedCommunityProvider));

class PublicUserCommunityProfileScreen extends ConsumerStatefulWidget {
  const PublicUserCommunityProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessionalCommunityScreenState();
}

class _ProfessionalCommunityScreenState
    extends ConsumerState<PublicUserCommunityProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final community = ref.watch(selectedCommunityProvider);
    final pubUser = ref.watch(publicUserProvider);
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
                      backgroundImage: NetworkImage(pubUser!.profilePic),
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
          // Stream Builder
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
  final String postId;
  final String authorRole;
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

  final currentUser = FirebaseAuth.instance.currentUser;

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

  @override
  Widget build(BuildContext context) {
    // Determine if the current user is the same as the user who posted the post
    final isPostOwner = widget.postUserUid == currentUser?.uid;
    final pubUser = ref.watch(publicUserProvider);
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
              isPostOwner
                  ? IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((context) {
                              return Container(
                                width: double.infinity,
                                height: 120,
                                color: Pallete.bgDarkerShade,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Modifier'),
                                      onTap: () {},
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
                      icon: const Icon(Icons.more_horiz))
                  : const SizedBox()
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
                        .likePost(widget.postId, pubUser!.uid, widget.likes);
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
                            builder: ((context) =>
                                PublicUserCommunityPostScreen(
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
  const ShowAddPostScreen({super.key});
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
    final publicUer = ref.watch(publicUserProvider);
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
          username: publicUer!.name,
          userUid: publicUer.uid,
          userProfilePic: publicUer.profilePic,
          postedAt: DateTime.now(),
          userRole: publicUer.role,
          isPinned: false);

      //pass newPost to the controller;
      ref.watch(professionalCommunityControllerProvider).uploadPost(newPost);
    } else {
      showSnackBar(
          context: context, content: 'vous devez remplir le champ de texte ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final community = ref.watch(selectedCommunityProvider);
    final proUser = ref.watch(publicUserProvider);
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
                  backgroundImage: NetworkImage(proUser!.profilePic),
                  radius: 20,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Text(
                  proUser.name,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    pickImage();
                    // heightOfModalBottomSheet = heightOfModalBottomSheet * 2;
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
              ? Container(
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: FileImage(_imagePost!), fit: BoxFit.cover)),
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

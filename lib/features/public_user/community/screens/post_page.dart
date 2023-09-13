// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:health_app/core/common/widgets/error.dart';
import 'package:health_app/core/common/widgets/expanded_text.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/community/controller/community_controller.dart';
import 'package:health_app/models/comment_model.dart';

import '../../../../core/common/repositories/utils.dart';

class PublicUserCommunityPostScreen extends ConsumerStatefulWidget {
  final String postId;
  final String postImage;

  const PublicUserCommunityPostScreen(this.postId, this.postImage, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessionalCommunityScreenState();
}

class _ProfessionalCommunityScreenState
    extends ConsumerState<PublicUserCommunityPostScreen> {
  String commentTxt = '';
  final TextEditingController _controller = TextEditingController();

  ScrollController _scrollController = ScrollController();
  void _addCommentScrollAnimation() {
    // scroll to the end of the list after the new comment has been laid out
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // post a comment
  void postComment() {
    if (commentTxt.isNotEmpty) {
      _controller.clear();
      final pubUser = ref.read(publicUserProvider);
      final String commentId = const Uuid().v4();
      final newComment = CommunityComment(
          id: commentId,
          postId: widget.postId,
          authorUid: pubUser!.uid,
          text: commentTxt,
          authorName: pubUser.name,
          authorAvatarUrl: pubUser.profilePic,
          createdAt: DateTime.now());

      ref.read(professionalCommunityControllerProvider).postComment(newComment);
      commentTxt = '';
      _addCommentScrollAnimation();
    } else {
      showSnackBar(
          context: context, content: 'vous devez remplir le champ de texte.');
    }
  }

  bool isLiked = false;
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final pubUser = ref.watch(publicUserProvider);
    final commentsStream = ref
        .watch(professionalCommunityControllerProvider)
        .loadComments(widget.postId);
    return ref.watch(getPostByIdStreamProvider(widget.postId)).when(
        data: (data) {
          return Scaffold(
            appBar: widget.postImage == ''
                ? AppBar(
                    centerTitle: true,
                    title: Text(
                      'Publication de ${data.username}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_sharp)),
                  )
                : null,
            extendBodyBehindAppBar: true,
            bottomNavigationBar: SafeArea(
              child: Container(
                height: screenHeight * 0.08,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorHeight: 20.0,
                        controller: _controller,
                        decoration: InputDecoration(
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 60,
                            minHeight: 50,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          prefixIcon: FractionallySizedBox(
                            heightFactor: 0.5,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                pubUser!.profilePic,
                              ),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18.0),
                          filled: true,
                          suffixIcon: InkWell(
                            onTap: postComment,
                            child: Container(
                              margin: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade300,
                                  backgroundBlendMode: BlendMode.overlay,
                                  shape: BoxShape.circle),
                              child: Transform.rotate(
                                angle: 5.5,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 22.0,
                                ),
                              ),
                            ),
                          ),
                          hintText: 'écrire un commentaire...',
                          hintStyle: const TextStyle(letterSpacing: 1.4),
                        ),
                        onChanged: (value) {
                          setState(() {
                            commentTxt = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // sliver app bar
                data.image == ''
                    ? const SliverToBoxAdapter(
                        child: SafeArea(child: SizedBox()),
                      )
                    : SliverAppBar(
                        leading: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back_ios_new_sharp)),
                        expandedHeight: 250,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: false,
                          background: Image.network(
                            data.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                data.userProfilePic,
                              ),
                              radius: 20,
                            ),
                            const SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  'il y a ${getTimeDifference(data.postedAt)}',
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Text(
                              DateFormat.yMd().add_Hms().format(data.postedAt),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade200),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: data.description.length >= 140
                              ? ExpandableText(
                                  text: data.description,
                                  maxLength: data.description.length ~/ 2,
                                )
                              : Text(
                                  data.description,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                        ),
                        const Divider(
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  ),
                ),
                // comments ListView
                // Stream
                StreamBuilder<List<CommunityComment>>(
                  stream: commentsStream, // your stream of post data
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // Show a message if there is no data or if the data is empty
                      return const SliverToBoxAdapter(
                        child: Loader(),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('aucun commentaire pour l\'instant'),
                        ),
                      );
                    }

                    final comments = snapshot.data!;

                    return SliverPadding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final comment = comments[index];

                            return CommentCard(
                              comment: CommunityComment(
                                  id: comment.id,
                                  postId: comment.postId,
                                  authorUid: comment.authorUid,
                                  text: comment.text,
                                  authorName: comment.authorName,
                                  authorAvatarUrl: comment.authorAvatarUrl,
                                  createdAt: comment.createdAt),
                            );
                          },
                          childCount: comments.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => ErrorText(error: 'error: $error'),
        loading: () => const Loader());
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final CommunityComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              comment.authorAvatarUrl,
            ),
            radius: 20,
          ),
          const SizedBox(
            width: 10.0,
          ),
          // name and comment Column
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: const BoxDecoration(
                  color: Pallete.bgDarkerShade,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(comment.text),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat.Hm().format(comment.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade200),
            ),
          ),
        ],
      ),
    );
  }
}

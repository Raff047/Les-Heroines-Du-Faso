// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:health_app/core/common/widgets/custom_tag.dart';
import 'package:health_app/core/common/widgets/text_to_speech.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:like_button/like_button.dart';

import '../../../../core/common/repositories/utils.dart';
import '../../../../core/common/widgets/article_image_container.dart';
import '../../../../models/article_model.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = ModalRoute.of(context)?.settings.arguments as Article;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        actions: [
          LikeButton(
            size: 35,
            likeBuilder: (isLiked) {
              return Icon(
                Icons.bookmark,
                color: Colors.red,
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ArticleImageContainer(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            imageUrl: articles.imageUrl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CostumTag(
                    backgroundColor: Pallete.blueColor.withOpacity(0.9),
                    children: [
                      Text(
                        articles.category,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ]),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  articles.title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.25,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CostumTag(
                        backgroundColor: const Color(0xffffafbd),
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                NetworkImage(articles.authorImageUrl),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            articles.authorName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ]),
                    SizedBox(
                      width: 10.0,
                    ),
                    CostumTag(backgroundColor: Colors.black12, children: [
                      Icon(
                        Icons.timer,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(getTimeDifference(articles.createdAt),
                          style: Theme.of(context).textTheme.bodyMedium!),
                    ]),
                    SizedBox(
                      width: 10.0,
                    ),
                    CostumTag(backgroundColor: Colors.black12, children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text('${articles.views}',
                          style: Theme.of(context).textTheme.bodyMedium!),
                    ]),
                    TextToSpeech(
                        text:
                            '${articles.title} par docteur ${articles.authorName} + ${articles.content}'),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  articles.content,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        height: 1.5,
                        fontSize: 18.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

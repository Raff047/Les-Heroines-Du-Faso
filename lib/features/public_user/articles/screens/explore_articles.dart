import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/models/professional_user_model.dart';

import '../../../../core/common/repositories/utils.dart';
import '../../../../core/common/widgets/article_image_container.dart';
import '../../../../models/article_model.dart';
import 'read_articles.dart';

class ExploreArticles extends ConsumerStatefulWidget {
  const ExploreArticles({super.key});

  @override
  ConsumerState<ExploreArticles> createState() => _ExploreArticlesState();
}

class _ExploreArticlesState extends ConsumerState<ExploreArticles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }

          // Group articles by category
          final articlesByCategory = <String, List<Article>>{};
          for (final article in snapshot.data!.docs) {
            final category = article['category'];
            final articleModel = Article.fromFirestore(
                article as DocumentSnapshot<Map<String, dynamic>>);
            if (articlesByCategory.containsKey(category)) {
              articlesByCategory[category]!.add(articleModel);
            } else {
              articlesByCategory[category] = [articleModel];
            }
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: articlesByCategory.length,
              itemBuilder: (BuildContext context, int index) {
                final category = articlesByCategory.keys.elementAt(index);
                final articles =
                    articlesByCategory[category]!.map((doc) => doc).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(category,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
                        itemBuilder: (BuildContext context, int index) {
                          final article = articles[index];

                          return Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            width: MediaQuery.of(context).size.width * 0.5,
                            margin: const EdgeInsets.only(right: 10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: RouteSettings(
                                      arguments: article,
                                    ),
                                    builder: (context) => const ArticleScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ArticleImageContainer(
                                    height: MediaQuery.of(context).size.height *
                                        0.28,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    imageUrl: article.imageUrl,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Flexible(
                                    child: Text(
                                      article.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    'il y a ${getTimeDifference(article.createdAt)}',
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    'Par Dr. ${article.authorName}',
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/custom_tag.dart';
import 'package:health_app/core/common/widgets/text_to_speech.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/manager/articles/controller/articles_controller.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../core/common/repositories/utils.dart';
import '../../../../core/common/widgets/article_image_container.dart';
import '../../../../models/article_model.dart';

class ManagerArticleScreen extends ConsumerWidget {
  const ManagerArticleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ModalRoute.of(context)!.settings.arguments as Article;
    // delete article
    void deleteArticle() {
      ref.watch(managerArticlesController).deleteArticle(articles.id, context);
    }

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red.shade300,
            mini: true,
            onPressed: () {
              deleteArticle();
              Navigator.pop(context);
            },
            child: Icon(
              MdiIcons.delete,
              size: 30,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_new_sharp)),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: ArticleImageContainer(
                  colorFilter:
                      const ColorFilter.mode(Colors.black12, BlendMode.darken),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ]),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        articles.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(20.0),
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
                            const SizedBox(width: 5.0),
                            Text('${articles.views}',
                                style: Theme.of(context).textTheme.bodyMedium!),
                          ]),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: TextToSpeech(
                                text:
                                    '${articles.title} par docteur ${articles.authorName} + ${articles.content}'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                articles.content[0].toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0,
                                  height: 0.7,
                                  letterSpacing: 6,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: articles.content.substring(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}

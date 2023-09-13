import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:health_app/core/common/widgets/error.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/articles/controller/articles_controller.dart';
import '../../../../models/article_model.dart';

class ViewMyArticles extends ConsumerWidget {
  const ViewMyArticles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final professional = ref.watch(professionalUserProvider);
    return ref.watch(myArticlesProvider(professional!.uid)).when(
        data: (articles) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new)),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const _MesArticlesHeader(),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final Article article = articles[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IntrinsicHeight(
                              child: Card(
                                color: const Color(0xff4c4f64),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Image.network(
                                        article.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                article.category,
                                                style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Text(article.title),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 12.0,
                                                    backgroundImage:
                                                        NetworkImage(article
                                                            .authorImageUrl),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  Text(article.authorName),
                                                  const SizedBox(width: 12.0),
                                                  Text(
                                                    DateFormat.yMd().format(
                                                        article.createdAt),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stacktrace) => ErrorText(error: 'error: $error'),
        loading: () => const Loader());
  }
}

class _MesArticlesHeader extends StatelessWidget {
  const _MesArticlesHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * .25,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mes articles',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            const Text('Voici vos articles publiés'),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Chercher',
                    fillColor: const Color(0xff4c4f64),
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

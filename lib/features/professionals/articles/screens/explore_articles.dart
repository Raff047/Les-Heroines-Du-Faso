import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:health_app/core/common/repositories/common_firebase_storage_methods.dart';
import 'package:health_app/core/common/widgets/pick_image.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/core/constants/constants.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/articles/controller/articles_controller.dart';
import 'package:health_app/features/professionals/articles/screens/my_articles.dart';
import 'package:health_app/features/professionals/articles/screens/read_article.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/common/repositories/utils.dart';
import '../../../../core/common/widgets/article_image_container.dart';
import '../../../../models/article_model.dart';

class ProfessionalExploreArticlesScreen extends ConsumerStatefulWidget {
  const ProfessionalExploreArticlesScreen({super.key});

  @override
  ConsumerState<ProfessionalExploreArticlesScreen> createState() =>
      _ExploreArticlesState();
}

class _ExploreArticlesState
    extends ConsumerState<ProfessionalExploreArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Pallete.greenColor,
        children: [
          SpeedDialChild(
              backgroundColor: Pallete.bgDarkerShade,
              labelBackgroundColor: Pallete.bgDarkerShade,
              child: const Icon(MdiIcons.post),
              label: 'Ajouter article',
              onTap: () {
                Future(() => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return const ShowAddArticleScreen();
                    }));
              }),
          SpeedDialChild(
            backgroundColor: Pallete.bgDarkerShade,
            labelBackgroundColor: Pallete.bgDarkerShade,
            child: const Icon(MdiIcons.viewCarouselOutline),
            label: 'Mes articles',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const ViewMyArticles()))),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.38,
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
                                    builder: (context) =>
                                        const ProfessionalArticleScreen(),
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
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    'il y a ${getTimeDifference(article.createdAt)}',
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    'par Dr. ${article.authorName}',
                                    maxLines: 2,
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

// show bottom shee add article

class ShowAddArticleScreen extends ConsumerStatefulWidget {
  const ShowAddArticleScreen({
    super.key,
  });
  @override
  _ShowAddArticleScreenState createState() => _ShowAddArticleScreenState();
}

@override
ConsumerState<ConsumerStatefulWidget> createState() =>
    _ShowAddArticleScreenState();

class _ShowAddArticleScreenState extends ConsumerState<ShowAddArticleScreen> {
  File? _articleImage;
  String? _title;
  String? _category;
  String? _content;

  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _titleController.dispose();
  }

  // DropDown Menu
  final List<String> categories = [
    'Santé mentale',
    'Santé sexuelle',
    'Santé générale',
    'Santé reproductive',
  ];

  //for selecting article image
  void pickImage() async {
    _articleImage = await selectImage(context);
    setState(() {});
  }

  // upload new article
  void uploadNewArticle() async {
    _contentController.clear();
    _titleController.clear();
    final professional = ref.watch(professionalUserProvider);
    if (_title != null && _category != null && _content != null) {
      const articleId = Uuid();
      Article newArticle = Article(
          id: articleId.v4(),
          title: _title!,
          category: _category!,
          content: _content!,
          imageUrl: _articleImage == null
              ? Constants.articleImageDefault
              : await ref
                  .read(commonFirebaseStorageMethodsProvider)
                  .storeFileToFirebase(
                      'Article/${articleId.v4()}', _articleImage!),
          authorId: professional!.uid,
          authorName: professional.name,
          authorImageUrl: professional.profilePic,
          views: 0,
          createdAt: DateTime.now());

      ref
          .read(professionalArticleControllerProvider)
          .postArticle(newArticle, context);
      Navigator.pop(context);
    } else {
      showSnackBar(context: context, content: 'Please fill out all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final proUser = ref.watch(professionalUserProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var heightOfModalBottomSheet = screenHeight * .92;
    return Container(
      padding: const EdgeInsets.all(25),
      width: screenWidth,
      height: heightOfModalBottomSheet,
      color: Pallete.blackColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Titre',
                  fillColor: const Color(0xff4c4f64),
                  filled: true,
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0))),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),

            const SizedBox(height: 10.0),
            // article content

            TextFormField(
              maxLines: 20,
              decoration: InputDecoration(
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.text_snippet),
                  ],
                ),
                prefixIconConstraints:
                    const BoxConstraints.expand(height: 390, width: 50),
                hintText: 'Contenu',
                fillColor: const Color(0xff4c4f64),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _content = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                    // heightOfModalBottomSheet = heightOfModalBottomSheet * 2;
                    setState(() {});
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Icon(
                        Icons.image,
                        color: Colors.green,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text('Select image')
                    ],
                  ),
                ),
                _articleImage != null
                    ? Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_articleImage!),
                                fit: BoxFit.cover)),
                      )
                    : Container(),

                //DropDown
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Catégorie',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: categories
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: _category,
                    onChanged: (value) {
                      setState(() {
                        _category = value as String;
                      });
                    },
                    // Styling
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: 180,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Pallete.bgDarkerShade,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Pallete.bgDarkerShade,
                        ),
                        elevation: 8,
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        )),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 4, backgroundColor: yellowish),
                onPressed: uploadNewArticle,
                child: const Text('Publier'))
          ],
        ),
      ),
    );
  }
}

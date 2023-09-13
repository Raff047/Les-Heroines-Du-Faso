// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/repositories/common_firebase_storage_methods.dart';
import 'package:health_app/core/common/widgets/custom_tag.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/core/common/widgets/text_to_speech.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/articles/controller/articles_controller.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../core/common/repositories/utils.dart';
import '../../../../core/common/widgets/article_image_container.dart';
import '../../../../core/common/widgets/pick_image.dart';
import '../../../../models/article_model.dart';

class ProfessionalArticleScreen extends ConsumerWidget {
  const ProfessionalArticleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final professional = ref.watch(professionalUserProvider);
    final article = ModalRoute.of(context)!.settings.arguments as Article;

    // check if owner of article
    bool isArticleOwner() {
      final isOwner = professional?.uid == article.authorId;
      return isOwner;
    }

    // delete article
    void deleteArticle() {
      ref
          .watch(professionalArticleControllerProvider)
          .deleteArticle(article.id, professional!.uid, context);
    }

    final articles = ModalRoute.of(context)?.settings.arguments as Article;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isArticleOwner()
            ? Padding(
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
              )
            : null,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                isArticleOwner()
                    ? TextButton(
                        onPressed: () {
                          Future(() => showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return ShowEditArticleScreen(
                                  article: article,
                                );
                              }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Modifier',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    : Container(),
              ],
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

// show bottom sheet to edit article
class ShowEditArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  const ShowEditArticleScreen({
    required this.article,
    super.key,
  });
  @override
  ShowEditArticleScreenState createState() => ShowEditArticleScreenState();
}

@override
ConsumerState<ConsumerStatefulWidget> createState() =>
    ShowEditArticleScreenState();

class ShowEditArticleScreenState extends ConsumerState<ShowEditArticleScreen> {
  File? _articleImage;
  String? _title;
  String? _category;
  String? _content;
  String? _articleImageUrl;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  ShowEditArticleScreenState();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.article.title;
    _contentController.text = widget.article.content;
    _imageController.text = widget.article.imageUrl;
    _category = widget.article.category;
    _content = widget.article.content;
    _title = widget.article.title;
  }

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

  // edit selected article
  void editArticle() async {
    try {
      if (_category != null && _content != null) {
        final proUser = ref.read(professionalUserProvider);
        ref.watch(professionalArticleControllerProvider).editArticle(
            widget.article.id,
            proUser!.uid,
            _content!,
            _title ?? '',
            _category!,
            await ref
                .read(commonFirebaseStorageMethodsProvider)
                .storeFileToFirebase(
                    'Article/${widget.article.id}', _articleImage!),
            context);
        _contentController.clear();
        _titleController.clear();
        Navigator.pop(context);
      } else {
        showSnackBar(
            context: context,
            content: 'La catégorie et le contenu sont obligatoires');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _titleController,
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
              controller: _contentController,
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
              onEditingComplete: () => _content,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
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
                      SizedBox(width: 5.0),
                      Text(
                        'Ajouter image',
                        style: TextStyle(fontSize: 12),
                      )
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
                    : Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.article.imageUrl),
                                fit: BoxFit.cover)),
                      ),

                //DropDown
                Expanded(
                  child: DropdownButtonHideUnderline(
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
                          _category = value;
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
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 4, backgroundColor: yellowish),
                onPressed: () {
                  editArticle();
                },
                child: const Text('Publier'))
          ],
        ),
      ),
    );
  }
}

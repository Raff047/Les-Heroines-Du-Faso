import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/article_textfield.dart';
import 'package:health_app/core/constants/constants.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/articles/controller/articles_controller.dart';
import 'package:health_app/features/professionals/dashboard/professional_user_dashboard.dart';
import 'package:health_app/models/article_model.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/common/repositories/common_firebase_storage_methods.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/pick_image.dart';
import '../../../../core/common/widgets/show_snack_bar.dart';
import '../../../../theme/pallete.dart';

class NewArticleScreen extends ConsumerStatefulWidget {
  const NewArticleScreen({super.key});

  @override
  ConsumerState<NewArticleScreen> createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends ConsumerState<NewArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? _title;
  String? _category = 'Santé mentale';
  String? _content;

  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  //for selecting profile image
  void pickImage() async {
    _image = await selectImage(context);
    setState(() {});
  }

  void sendNewArticle() async {
    _contentController.clear();
    _titleController.clear();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProfessionalDashboardScreen()));
    final currentPersonalUser = ref.watch(professionalUserProvider);
    if (_title != null && _category != null && _content != null) {
      const articleId = Uuid();
      Article newArticle = Article(
          id: articleId.v4(),
          title: _title!,
          category: _category!,
          content: _content!,
          imageUrl: _image == null
              ? Constants.articleImageDefault
              : await ref
                  .read(commonFirebaseStorageMethodsProvider)
                  .storeFileToFirebase('Article/${articleId.v4()}', _image!),
          authorId: currentPersonalUser!.uid,
          authorName: currentPersonalUser.name,
          authorImageUrl: Constants.doctorAvatar,
          views: 0,
          createdAt: DateTime.now());

      ref
          .read(professionalArticleControllerProvider)
          .postArticle(newArticle, context);
    } else {
      showSnackBar(context: context, content: 'Please fill out all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'New Article',
          ),
          centerTitle: true,
          leading: const Icon(
            Icons.arrow_back_ios_new_sharp,
          ),
          backgroundColor: Pallete.blackColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: pickImage,
                child: _image == null
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, style: BorderStyle.solid)),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_image!), fit: BoxFit.cover)),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    ArticleForm(
                        controller: _titleController,
                        hintText: 'Titre',
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        }),
                    DropdownButton<String>(
                      alignment: AlignmentDirectional.topEnd,
                      style: const TextStyle(fontSize: 16.0),
                      value: _category,
                      onChanged: (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                            value: 'Santé mentale',
                            child: Text('Santé mentale')),
                        DropdownMenuItem(
                            value: 'Santé sexuelle',
                            child: Text('Santé sexuelle')),
                        DropdownMenuItem(
                            value: 'Santé générale',
                            child: Text('Santé générale')),
                        DropdownMenuItem(
                            value: 'Santé reproductive',
                            child: Text('Santé reproductive')),
                      ],
                    ),
                    ArticleForm(
                        controller: _contentController,
                        maxLines: 10,
                        hintText: 'Contenu',
                        onChanged: (value) {
                          setState(() {
                            _content = value;
                          });
                        }),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(15.0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomButton(
                    onPressed: sendNewArticle,
                    text: 'Post',
                  )),
            ],
          ),
        ));
  }
}

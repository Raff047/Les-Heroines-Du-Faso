import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/article_textfield.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../controller/admin_controller.dart';

class AddManagerScreen extends ConsumerStatefulWidget {
  const AddManagerScreen({super.key});

  @override
  ConsumerState<AddManagerScreen> createState() => _AddManagerScreenState();
}

class _AddManagerScreenState extends ConsumerState<AddManagerScreen> {
  String? _name;
  String? _email;
  String? _password;

  void addManager() {
    if (_name != null && _email != null && _password != null) {
      ref.watch(adminControllerProvider).createManager(
          name: _name!, email: _email!, password: _password!, context: context);
    } else {
      showSnackBar(
          context: context, content: 'Veuillez remplir tous les champs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          child: Column(
            children: [
              ArticleForm(
                hintText: 'Manager 1',
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              ArticleForm(
                hintText: 'nom@gmail.com',
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              ArticleForm(
                hintText: 'mot de passe',
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              SizedBox(
                  width: 150,
                  child: CustomButton(onPressed: addManager, text: 'Ajouter')),
            ],
          ),
        ),
      ),
    );
  }
}

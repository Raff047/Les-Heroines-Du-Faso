import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/custom_button.dart';

import '../../../core/common/widgets/article_textfield.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../controller/admin_controller.dart';

class AddAdminScreen extends ConsumerStatefulWidget {
  const AddAdminScreen({super.key});

  @override
  ConsumerState<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends ConsumerState<AddAdminScreen> {
  @override
  Widget build(BuildContext context) {
    String? _name;
    String? _email;
    String? _password;

    void addAdmin() {
      if (_name != null && _email != null && _password != null) {
        ref.watch(adminControllerProvider).createAdmin(
            name: _name, email: _email, password: _password, context: context);
      } else {
        showSnackBar(
            context: context, content: 'Veuillez remplir tous les champs');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          child: Column(
            children: [
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
                  child: CustomButton(onPressed: addAdmin, text: 'Ajouter')),
            ],
          ),
        ),
      ),
    );
  }
}

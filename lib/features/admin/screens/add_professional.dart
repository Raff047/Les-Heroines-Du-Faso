import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/article_textfield.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../controller/admin_controller.dart';

class AddProfessionalScreen extends ConsumerStatefulWidget {
  const AddProfessionalScreen({super.key});

  @override
  ConsumerState<AddProfessionalScreen> createState() =>
      _AddProfessionalScreenState();
}

class _AddProfessionalScreenState extends ConsumerState<AddProfessionalScreen> {
  String? _name;
  String? _email;
  String? _password;
  String? _professionCategory = 'Gynécologie';

  void addProfessional() {
    if (_name != null && _email != null && _password != null) {
      ref.read(adminControllerProvider).createProfessional(
          name: _name,
          email: _email,
          password: _password,
          category: _professionCategory,
          context: context);
    } else {
      showSnackBar(
          context: context, content: 'Veuillez remplir tous les champs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                ArticleForm(
                  hintText: 'Name',
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Catégorie'),
                    SizedBox(
                      width: 250,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Container(
                        color: Colors.deepPurple.shade200,
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(20),
                          alignment: AlignmentDirectional.topEnd,
                          style: const TextStyle(fontSize: 16.0),
                          value: _professionCategory,
                          onChanged: (value) {
                            setState(() {
                              _professionCategory = value;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Gynécologie',
                              child: Text('Gynécologie'),
                            ),
                            DropdownMenuItem(
                              value: 'Obstétrique',
                              child: Text('Obstétrique'),
                            ),
                            DropdownMenuItem(
                              value: 'Contraception',
                              child: Text('Contraception'),
                            ),
                            DropdownMenuItem(
                              value:
                                  'MST (Maladies Sexuellement Transmissibles)',
                              child: Text(
                                  'MST (Maladies Sexuellement Transmissibles)'),
                            ),
                            DropdownMenuItem(
                              value: 'Fécondité',
                              child: Text('Fécondité'),
                            ),
                            DropdownMenuItem(
                              value: 'Ménopause',
                              child: Text('Ménopause'),
                            ),
                            DropdownMenuItem(
                              value: 'Santé mentale et sexuelle',
                              child: Text('Santé mentale et sexuelle'),
                            ),
                            DropdownMenuItem(
                              value: 'Violence sexuelle',
                              child: Text('Violence sexuelle'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ArticleForm(
                  hintText: 'name@email.com',
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                ArticleForm(
                  hintText: 'password',
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(
                    width: 150,
                    child:
                        CustomButton(onPressed: addProfessional, text: 'Add')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

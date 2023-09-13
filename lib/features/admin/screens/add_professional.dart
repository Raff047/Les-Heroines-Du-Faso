import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/text_field.dart';
import 'package:health_app/theme/pallete.dart';

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
  String? _category;

  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // DropDown Menu
  final List<String> categories = [
    'Gynécologie',
    'Obstétrique',
    'Contraception',
    'Santé mentale et sexuelle',
    'Violence sexuelle',
    'Ménopause',
    'Fécondité',
    'MST (Maladies Sexuellement Transmissibles)',
  ];

  void addProfessional() {
    if (_name != null && _email != null && _password != null) {
      ref.read(adminControllerProvider).createProfessional(
          name: _name,
          email: _email,
          password: _password,
          category: _category,
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
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nom',
                    fillColor: Pallete.bgDarkerShade,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Catégorie'),
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
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              )),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'nom@gmail.com',
                    fillColor: Pallete.bgDarkerShade,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    fillColor: Pallete.bgDarkerShade,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                    width: 150,
                    child: CustomButton(
                        onPressed: addProfessional, text: 'Ajouter')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/repositories/common_firebase_storage_methods.dart';
import 'package:health_app/core/common/widgets/pick_image.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/core/common/widgets/text_field.dart';
import 'package:health_app/features/auth/screens/login.dart';
import 'package:health_app/features/professionals/profile_settings/profile_repository.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../auth/controller/auth_controller.dart';

class ProfessionalUserProfileSettings extends ConsumerStatefulWidget {
  const ProfessionalUserProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessionalUserProfileSettingsState();
}

class _ProfessionalUserProfileSettingsState
    extends ConsumerState<ProfessionalUserProfileSettings> {
  String? name;
  String? email;
  File? _profilePic;
  String? specializedIn;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _specializedInController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _specializedInController.dispose();
  }

  @override
  void initState() {
    super.initState();
    final professional = ref.read(professionalUserProvider);
    _nameController.text = professional!.name;
    _emailController.text = professional.email!;
    _specializedInController.text = professional.specializedIn;
  }

  //for selecting profile pic
  void pickImage() async {
    _profilePic = await selectImage(context);
    setState(() {});
    updateProfilePic();
  }

  // update phone number
  void updateProfilePic() async {
    final professional = ref.read(professionalUserProvider);
    final profilePicUrl = await ref
        .read(commonFirebaseStorageMethodsProvider)
        .storeFileToFirebase('/profilePic/${professional!.uid}', _profilePic!);
    ref
        .read(professionalProfileRepository)
        .updateProfilePic(professional.uid, profilePicUrl);
  }

  // update name
  void updateName() async {
    if (name != null) {
      final professional = ref.read(professionalUserProvider);
      ref
          .read(professionalProfileRepository)
          .updateName(professional!.uid, name!);
    } else {
      showSnackBar(
          context: context, content: 'S\'il vous plaît, entrez votre nom');
    }
  }

  @override
  Widget build(BuildContext context) {
    final professional = ref.watch(professionalUserProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    MdiIcons.account,
                    size: 28,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Mon compte',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallete.bgDarkerShade,
                      image: DecorationImage(
                          image: _profilePic == null
                              ? NetworkImage(professional!.profilePic)
                              : FileImage(_profilePic!)
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover),
                    ),
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                      child: IconButton(
                        onPressed: () {
                          pickImage();
                        },
                        icon: const Icon(MdiIcons.pencil),
                      ),
                    ),
                  ),
                ],
              ),

              // form
              // name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nom',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  TextFieldWidget(
                    prefixText: 'Dr. ',
                    onEditingComplete: updateName,
                    readOnly: false,
                    hintText: '',
                    controller: _nameController,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ],
              ),
              // email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  TextFieldWidget(
                    onEditingComplete: null,
                    readOnly: true,
                    hintText: '',
                    controller: _emailController,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ],
              ),
              // SpicializedIn
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spécialisé en',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  TextFieldWidget(
                    onEditingComplete: null,
                    readOnly: true,
                    hintText: '',
                    controller: _specializedInController,
                    onChanged: (value) {
                      setState(() {
                        specializedIn = value;
                      });
                    },
                  ),
                ],
              ),

              // sign out
              Container(
                padding: const EdgeInsets.all(20.0),
                width: double.infinity,
                child: CustomButton(
                    text: 'Se déconnecter',
                    onPressed: () {
                      ref.watch(authControllerProvider.notifier).signUserOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

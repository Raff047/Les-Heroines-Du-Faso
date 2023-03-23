import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/admin/screens/add_professional.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/login.dart';
import 'admin_dashboard_screen.dart';
import 'delete_professional.dart';
import 'disable_professional.dart';
import 'managers_management.dart';

class ProfessionalsManagementScreen extends ConsumerWidget {
  const ProfessionalsManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des professionnels'),
          centerTitle: true,
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new)),
          elevation: 0,
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                'Veuillez choisir l\'une des options suivantes,',
                style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              OptionCard(
                title: 'Ajouter',
                color: Colors.lightBlue.shade200,
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProfessionalScreen()));
                },
              ),
              OptionCard(
                title: 'Désactiver',
                color: Colors.amber.shade200,
                icon: Icons.toggle_off,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DisableProfessionalScreen(),
                    ),
                  );
                },
              ),
              OptionCard(
                title: 'Supprimer',
                color: Colors.red.shade200,
                icon: Icons.remove_circle,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeleteProfessionalScreen(),
                    ),
                  );
                },
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.05,
                child: CustomButton(
                    text: 'Se deconnecter',
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
        )));
  }
}

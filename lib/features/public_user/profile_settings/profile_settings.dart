import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/profile_settings_tile.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/login.dart';
import '../dashboard/public_user_dashboard.dart';

class PublicUserProfileSettings extends ConsumerWidget {
  const PublicUserProfileSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicUser = ref.watch(publicUserProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const PublicUserDashBoardScreen()));
              },
            );
          },
        ),
        title: const Text('Paramètres du compte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xff0BAB64),
                      Color(0xff3BB78F),
                    ]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            child: Align(
              alignment: const Alignment(1, 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(57, 7, 94, 16),
                              offset: Offset(10.0, 12.0),
                              blurRadius: 12.0,
                              blurStyle: BlurStyle.normal,
                              spreadRadius: 4.0,
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(publicUser?.profilePic ?? ''),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        '${publicUser?.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: const [
              ProfileSettingsTile(
                icon: Icons.account_circle_outlined,
                setting: 'Mettre à jour la photo de profil',
                color: Color(0xffffafbd),
              ),
              ProfileSettingsTile(
                icon: Icons.phone,
                setting: 'Mettre à jour le numéro de téléphone',
                color: Color(0xffffafbd),
              ),
              ProfileSettingsTile(
                icon: Icons.notifications,
                setting: 'Notifications',
                color: Color(0xffffafbd),
              ),
              ProfileSettingsTile(
                icon: Icons.backup,
                setting: 'Backup / restore',
                color: Color(0xffffafbd),
              ),
              ProfileSettingsTile(
                icon: Icons.toggle_off_outlined,
                setting: 'Désactiver le compte',
                color: Color(0xffffafbd),
              ),
              ProfileSettingsTile(
                icon: Icons.help,
                setting: 'Aide',
                color: Color(0xffffafbd),
              ),
            ],
          ),
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
    );
  }
}

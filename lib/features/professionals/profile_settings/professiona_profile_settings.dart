import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/auth/screens/login.dart';
import 'package:health_app/theme/pallete.dart';
import '../../../core/common/widgets/custom_button.dart';

import '../../auth/controller/auth_controller.dart';
import 'app_bar.dart';

class ProfessionalUserProfileSettings extends ConsumerStatefulWidget {
  const ProfessionalUserProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PublicUserProfileSettingsState();
}

class _PublicUserProfileSettingsState
    extends ConsumerState<ProfessionalUserProfileSettings> {
  @override
  Widget build(BuildContext context) {
    final professionalUser = ref.watch(professionalUserProvider);

    return Scaffold(
      body: Column(
        children: [
          ProfileAppBar(
            photoURL: professionalUser!.profilePic,
            startColor: const Color(0xff0BAB64),
            endColor: const Color(0xff3BB78F),
            name: professionalUser.name,
            basedIn: professionalUser.specializedIn,
          ),
          const Expanded(child: SizedBox()),
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






// Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new_sharp),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             const ProfessionalDashboardScreen()));
//               },
//             );
//           },
//         ),
//         title: const Text('Paramètres du compte'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height * 0.3,
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.bottomLeft,
//                     end: Alignment.topRight,
//                     colors: [
//                       Color(0xff02aab0),
//                       Color(0xff00cdac),
//                     ]),
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40))),
//             child: Align(
//               alignment: const Alignment(1, 1),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromARGB(189, 48, 245, 235),
//                               offset: Offset(10.0, 12.0),
//                               blurRadius: 12.0,
//                               blurStyle: BlurStyle.normal,
//                               spreadRadius: 4.0,
//                             )
//                           ],
//                         ),
//                         child: const CircleAvatar(
//                           radius: 25,
//                           backgroundImage: NetworkImage(Constants.doctorAvatar),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15.0,
//                       ),
//                       Text(
//                         professionalUser?.name ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Icon(
//                     Icons.edit,
//                     color: Colors.white,
//                     size: 25,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Column(
//             children: const [
//               ProfileSettingsTile(
//                 icon: Icons.account_circle_outlined,
//                 setting: 'Mettre à jour la photo de profil',
//                 color: Color(0xff02aab0),
//               ),
//               ProfileSettingsTile(
//                 icon: Icons.phone,
//                 setting: 'Mettre à jour le numéro de téléphone',
//                 color: Color(0xff02aab0),
//               ),
//               ProfileSettingsTile(
//                 icon: Icons.notifications,
//                 setting: 'Notifications',
//                 color: Color(0xff02aab0),
//               ),
//               ProfileSettingsTile(
//                 icon: Icons.backup,
//                 setting: 'Backup / restore',
//                 color: Color(0xff02aab0),
//               ),
//               ProfileSettingsTile(
//                 icon: Icons.toggle_off_outlined,
//                 setting: 'Désactiver le compte',
//                 color: Color(0xff02aab0),
//               ),
//               ProfileSettingsTile(
//                 icon: Icons.help,
//                 setting: 'Aide',
//                 color: Color(0xff02aab0),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.all(20.0),
//             width: double.infinity,
//             child: CustomButton(
//                 text: 'Se déconnecter',
//                 onPressed: () {
//                   ref.watch(authControllerProvider.notifier).signUserOut();
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginScreen()),
//                       (route) => false);
//                 }),
//           ),
//         ],
//       ),
//     );

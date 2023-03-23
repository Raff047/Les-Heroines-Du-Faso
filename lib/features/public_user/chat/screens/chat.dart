import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/error.dart';
import 'package:health_app/features/public_user/chat/screens/start_chat.dart';
import 'package:health_app/models/professional_user_model.dart';

import '../../../../core/common/widgets/loader.dart';
import '../controller/chat_controller.dart';

final selectedProfessionalProvider =
    StateProvider<Professional>((ref) => _createInitialProfessional());

// Define a function to create a new instance of Professional with required fields initialized.
Professional _createInitialProfessional() {
  const uid = "";
  const name = "";
  const email = "";
  const profilePic = "";
  const specializedIn = "";
  const role = "";

  return Professional(
      uid: uid,
      name: name,
      email: email,
      profilePic: profilePic,
      specializedIn: specializedIn,
      role: role);
}

class MainChatScreen extends ConsumerStatefulWidget {
  const MainChatScreen({super.key});

  @override
  ConsumerState<MainChatScreen> createState() => _ChatState();
}

class _ChatState extends ConsumerState<MainChatScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedProfessional =
        ref.watch(selectedProfessionalProvider.notifier);
    return ref.watch(loadProfessionalsProvider).when(
        data: (data) {
          final professionals = data;

          final groupedProfessionals = <String, List<Professional>>{};

          // Group the professionals by their specializedIn field
          for (final professional in professionals) {
            final specializedIn = professional.specializedIn;

            if (!groupedProfessionals.containsKey(specializedIn)) {
              groupedProfessionals[specializedIn] = [];
            }

            groupedProfessionals[specializedIn]!.add(professional);
          }

          return ListView.builder(
            itemCount: groupedProfessionals.length,
            itemBuilder: (context, index) {
              final specializedIn = groupedProfessionals.keys.elementAt(index);
              final professionalsInSpecialization =
                  groupedProfessionals[specializedIn]!;

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choisissez un professionnel à contacter',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      specializedIn,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: professionalsInSpecialization.length,
                        itemBuilder: (context, index) {
                          final professional =
                              professionalsInSpecialization[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectedProfessional.state = Professional(
                                        role: professional.role,
                                        uid: professional.uid,
                                        name: professional.name,
                                        email: professional.email,
                                        profilePic: professional.profilePic,
                                        specializedIn:
                                            professional.specializedIn);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const StartChatScreen()));
                                  },
                                  child: CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage:
                                        NetworkImage(professional.profilePic),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Flexible(
                                  child: Text(
                                    'Dr. ${professional.name}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorText(error: '$error'),
        loading: (() => const Loader()));
  }
}

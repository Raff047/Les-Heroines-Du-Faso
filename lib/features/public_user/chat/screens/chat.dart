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
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Choisissez un professionnel à contacter',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupedProfessionals.length,
                      itemBuilder: (context, index) {
                        final specializedIn =
                            groupedProfessionals.keys.elementAt(index);
                        final professionalsInSpecialization =
                            groupedProfessionals[specializedIn]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              specializedIn,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: professionalsInSpecialization.length,
                                itemBuilder: (context, index) {
                                  final professional =
                                      professionalsInSpecialization[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 15.0),
                                        GestureDetector(
                                          onTap: () {
                                            selectedProfessional.state =
                                                Professional(
                                                    role: professional.role,
                                                    uid: professional.uid,
                                                    name: professional.name,
                                                    email: professional.email,
                                                    profilePic:
                                                        professional.profilePic,
                                                    specializedIn: professional
                                                        .specializedIn);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const StartChatScreen()));
                                          },
                                          child: CircleAvatar(
                                            radius: 45.0,
                                            backgroundImage: NetworkImage(
                                                professional.profilePic),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Expanded(
                                          child: Text(
                                            'Dr. ${professional.name}',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorText(error: '$error'),
        loading: (() => const Loader()));
  }
}

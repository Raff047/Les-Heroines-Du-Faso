import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/chat/controller/chat_controller.dart';
import 'package:health_app/features/professionals/chat/screens/start_chat.dart';
import 'package:health_app/models/public_user_model.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/no_conversations.dart';
import '../../../../models/chat_request.dart';

final selectedSenderProvider =
    StateProvider<PublicUser>((ref) => _createInitialPublicUser());

PublicUser _createInitialPublicUser() {
  const uid =
      ""; // Initialize with an empty string or any default value you prefer
  const name = "";
  const profilePic = "";
  const phoneNumber = "";
  const role = "";

  return PublicUser(
    uid: uid,
    name: name,
    profilePic: profilePic,
    phoneNumber: phoneNumber,
    role: role,
  );
}

class ProfessionalsChatScreen extends ConsumerStatefulWidget {
  const ProfessionalsChatScreen({super.key});

  @override
  ConsumerState<ProfessionalsChatScreen> createState() =>
      _ProfessionalsChatScreenState();
}

class _ProfessionalsChatScreenState
    extends ConsumerState<ProfessionalsChatScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedSender = ref.watch(selectedSenderProvider.notifier);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Messages',
          ),
          backgroundColor: Pallete.blackColor,
          elevation: 0,
        ),
        body: StreamBuilder<List<ChatRequest>>(
            stream: ref
                .watch(professionalChatControllerProvider)
                .getChatRequestsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loader();
              } else if (snapshot.data!.isEmpty) {
                return const NoConversations();
              }
              return ListView.builder(
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: ((context, index) {
                    var chatRequest = snapshot.data![index];
                    final senderData = ref
                        .watch(publicUserDataStreamProvider(
                            chatRequest.chatRequestID))
                        .value;
                    return GestureDetector(
                      onTap: () {
                        selectedSender.state = PublicUser(
                          uid: senderData!.uid,
                          name: senderData.name,
                          profilePic: senderData.profilePic,
                          phoneNumber: senderData.phoneNumber,
                          role: senderData.role,
                        );

                        // final senderData = ref.watch(
                        //     publicUserDataStreamProvider(
                        //         chatRequest.chatRequestID));
                        // print(senderData);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const ProfessionalStartChatScreen())));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: (BorderRadius.circular(20)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            chatRequest != null
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        NetworkImage(chatRequest.profilePic))
                                : CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 24,
                                  ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatRequest.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  chatRequest.lastMessage,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey.shade100),
                                ),
                              ],
                            )),
                            Text(
                              DateFormat.Hm().format(
                                chatRequest.timesent,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }));
            }),
      ),
    );
  }
}

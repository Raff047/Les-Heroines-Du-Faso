import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/chat/controller/chat_controller.dart';
import 'package:health_app/features/professionals/chat/screens/chat.dart';
import 'package:health_app/theme/pallete.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/common/widgets/show_snack_bar.dart';

class ProfessionalStartChatScreen extends ConsumerStatefulWidget {
  const ProfessionalStartChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfessionalStartChatScreen> createState() =>
      _StartChatScreenState();
}

String? _message;

class _StartChatScreenState extends ConsumerState<ProfessionalStartChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    _controller.clear();
    if (_message != null) {
      ref.read(professionalChatControllerProvider).sendMessage(_message ?? '');
      _message = null;
    } else {
      showSnackBar(context: context, content: 'please enter a message');
    }
  }

  // get messages from db
  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream() {
    final selectedSender = ref.watch(selectedSenderProvider.notifier).state;
    final currentProfessional = ref.watch(professionalUserProvider);
    final snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc('professionals')
        .collection('professionals')
        .doc(currentProfessional?.uid)
        .collection('messages')
        .doc(selectedSender.uid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    final selectedSender = ref.watch(selectedSenderProvider.notifier).state;
    // final message = ref.watch(messageProvider)!.senderId;
    final currentProfessional = ref.watch(professionalUserProvider)!.uid;
    // print('currentProfessional UID : $currentProfessional');
    // print('selectedSender UID : ${selectedSender.uid}');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 24,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(selectedSender.profilePic),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                selectedSender.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Expanded(child: Container()),
              StreamBuilder(
                  stream: messageStream(),
                  builder: ((context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Loader();
                    }
                    final messages = snapshot.data!.docs;
                    List<MessageBubble> messageBubbles = [];
                    for (var message in messages) {
                      final messageSenderID = message.data()['senderId'];
                      final messageTxt = message.data()['content'];
                      final messageWidget = MessageBubble(
                        text: messageTxt,
                        isMe: currentProfessional == messageSenderID,
                      );
                      messageBubbles.add(messageWidget);
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: messageBubbles,
                      ),
                    );

                    // return Container();
                  })),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: TextField(
                  controller: _controller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18.0),
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: sendMessage,
                      child: Icon(
                        Icons.send,
                        color: Pallete.greenColor,
                      ),
                    ),
                    hintText: 'Message',
                    hintStyle: const TextStyle(letterSpacing: 1.4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _message = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: isMe
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30))
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30)),
                color: isMe
                    ? Pallete.greenColor
                    : Colors.pink.shade200.withOpacity(0.8)),
            child: Text(
              text,
              style: const TextStyle(),
            )),
      ],
    );
  }
}

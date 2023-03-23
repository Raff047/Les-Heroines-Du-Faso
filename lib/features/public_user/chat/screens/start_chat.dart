import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/public_user/chat/controller/chat_controller.dart';
import 'package:health_app/theme/pallete.dart';
import '../../../../core/common/widgets/show_snack_bar.dart';
import 'chat.dart';

class StartChatScreen extends ConsumerStatefulWidget {
  const StartChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StartChatScreen> createState() => _StartChatScreenState();
}

String? _message;

class _StartChatScreenState extends ConsumerState<StartChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    _controller.clear();
    if (_message != null) {
      ref
          .read(publicUserChatControllerProvider)
          .sendMessage(_message ?? '', ref);
      _message = null;
    } else {
      showSnackBar(context: context, content: 'please enter a message');
    }
  }

  // messages stream
  // get messages from db
  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream() {
    final selectedProfessional = ref.watch(selectedProfessionalProvider);
    final currentPublicUser = ref.read(publicUserProvider);
    final snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc('professionals')
        .collection('professionals')
        .doc(selectedProfessional.uid)
        .collection('messages')
        .doc(currentPublicUser?.uid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    final selectedProfessional =
        ref.watch(selectedProfessionalProvider.notifier).state;

    final currentPublicUserUID = ref.watch(publicUserProvider)!.uid;

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
                radius: 52,
                backgroundImage: NetworkImage(selectedProfessional.profilePic),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Dr. ${selectedProfessional.name}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                selectedProfessional.specializedIn,
                style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 2,
                    color: Colors.grey.shade300),
              ),
              // Expanded(child: Container()),
              StreamBuilder(
                  stream: messageStream(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Loader();
                    }
                    final messages = snapshot.data!.docs;
                    List<MessageBubble> messageBubbles = [];

                    for (var message in messages) {
                      final messageSenderID = message.data()['senderId'];
                      final messageTxt = message.data()['content']!;
                      final messageWidget = MessageBubble(
                        text: messageTxt,
                        isMe: currentPublicUserUID == messageSenderID,
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
                    suffixIcon: InkWell(
                      onTap: sendMessage,
                      child: Icon(
                        Icons.send,
                        color: Colors.pink.shade300,
                      ),
                    ),
                    hintText: 'Message',
                    hintStyle: const TextStyle(letterSpacing: 1.4),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
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
                  ? Colors.pink.shade200.withOpacity(0.8)
                  : Colors.lightBlue.shade300),
          child: Text(text),
        ),
      ],
    );
  }
}

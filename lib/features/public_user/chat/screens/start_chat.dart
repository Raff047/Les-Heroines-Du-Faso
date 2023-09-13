import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/chat/controller/chat_controller.dart';
import 'package:health_app/features/public_user/chat/controller/chat_controller.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    messageController.dispose();
  }

  void sendMessage() {
    _controller.clear();
    if (_message != null) {
      ref.read(publicUserChatControllerProvider).sendMessage(_message!, ref);
      _message = null;
    } else {
      showSnackBar(context: context, content: 'please enter a message');
    }
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
                  stream: ref
                      .watch(professionalChatControllerProvider)
                      .messageStream(),
                  builder: ((context, messages) {
                    if (!messages.hasData) {
                      return const Loader();
                    }
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                        messageController
                            .jumpTo(messageController.position.maxScrollExtent);
                      },
                    );
                    print(messages);
                    return Expanded(
                      child: ListView.builder(
                          controller: messageController,
                          reverse: true,
                          itemCount: messages.data!.length,
                          itemBuilder: ((context, index) {
                            return MessageBubble(
                                text: messages.data![index].content,
                                isMe: currentPublicUserUID ==
                                    messages.data![index].senderId);
                          })),
                    );

                    // return Container();
                  })),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    fillColor: Pallete.bgDarkerShade,
                    suffixIcon: IconButton(
                        onPressed: sendMessage,
                        icon: Icon(
                          MdiIcons.send,
                          color: Pallete.greenColor,
                        )),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
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

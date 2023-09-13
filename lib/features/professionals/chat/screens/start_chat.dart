import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/error.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/chat/controller/chat_controller.dart';
import 'package:health_app/features/professionals/chat/screens/chat.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  final ScrollController _messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _messageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    debugPrint('widget is rebuilding');
    final selectedSender = ref.watch(selectedSenderProvider.notifier);
    final currentProfessional = ref.read(professionalUserProvider)!.uid;
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(selectedSender.state.profilePic),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                selectedSender.state.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
                        _messageController.jumpTo(
                            _messageController.position.maxScrollExtent);
                      },
                    );
                    print(messages);
                    return Expanded(
                      child: ListView.builder(
                          controller: _messageController,
                          reverse: true,
                          itemCount: messages.data!.length,
                          itemBuilder: ((context, index) {
                            return MessageBubble(
                                text: messages.data![index].content,
                                isMe: currentProfessional ==
                                    messages.data![index].senderId);
                          })),
                    );

                    // return Container();
                  })),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
            // width: MediaQuery.of(context).size.width * .6,
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
              style: const TextStyle(fontSize: 14),
            )),
      ],
    );
  }
}

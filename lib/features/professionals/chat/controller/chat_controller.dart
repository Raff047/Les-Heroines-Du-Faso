import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/chat/screens/chat.dart';
import '../../../../models/chat_message_model.dart';
import '../../../../models/chat_request.dart';
import '../../../public_user/chat/controller/chat_controller.dart';
import '../repository/chat_repository.dart';

// CLASS PROVIDER
final professionalChatControllerProvider =
    Provider((ref) => ProfessionalChatController(
          ref.watch(professionalChatRepositoryProvider),
          ref,
        ));

// chat requests stream
final getChatRequestsStream = StreamProvider<List<ChatRequest>>((ref) {
  final professionalChatController =
      ref.watch(professionalChatControllerProvider);
  return professionalChatController.getChatRequestsStream();
});

// chat messages stream
final getChatMessagesStream = StreamProvider<List<Message>>((ref) {
  final professionalChatController =
      ref.watch(professionalChatControllerProvider);
  return professionalChatController.messageStream();
});

class ProfessionalChatController {
  final ProfessionalChatRepository _professionalChatRepository;
  final ProviderRef ref;

  ProfessionalChatController(this._professionalChatRepository, this.ref);

  Stream<List<ChatRequest>> getChatRequestsStream() {
    final proUID = ref.read(professionalUserProvider)?.uid;
    return _professionalChatRepository.getChatRequestsStream(proUID!);
  }

  // send message to publicUser
  void sendMessage(String message) {
    _professionalChatRepository.sendMessage(message, ref).then((result) =>
        result.fold(
            (l) => null,
            (message) => ref
                .watch(messageProvider.notifier)
                .update((state) => message)));
  }

  // load a stream of messages
  Stream<List<Message>> messageStream() {
    final String currentProfessionalUID =
        ref.watch(professionalUserProvider)!.uid;
    final String selectedSenderUID = ref.watch(selectedSenderProvider).uid;

    return _professionalChatRepository.messageStream(
        currentProfessionalUID, selectedSenderUID);
  }
}

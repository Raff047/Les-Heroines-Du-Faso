import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/public_user/chat/repository/chat_repository.dart';
import '../../../../models/chat_message_model.dart';
import '../../../../models/professional_user_model.dart';

// Get Professionals Stream provider
final loadProfessionalsProvider = FutureProvider<List<Professional>>(
    (ref) => ref.watch(publicUserChatControllerProvider).loadProfessionals());

// CLASS PROVIDER
final publicUserChatControllerProvider = Provider((ref) =>
    PublicUserChatController(ref.watch(publicUserChatRepositoryProvider)));

// message provider
final messageProvider = StateProvider<Message?>((ref) => null);

class PublicUserChatController {
  final PublicUserChatRepository _publicUserChatRepository;

  PublicUserChatController(this._publicUserChatRepository);

  // load all professionals from firestore
  Future<List<Professional>> loadProfessionals() async {
    return await _publicUserChatRepository.loadProfessionals();
  }

  // send message to a selected professional
  void sendMessage(String message, WidgetRef ref) {
    _publicUserChatRepository.sendMessage(message, ref).then((result) =>
        result.fold(
            (l) => null,
            (message) => ref
                .watch(messageProvider.notifier)
                .update((state) => message)));
  }
}

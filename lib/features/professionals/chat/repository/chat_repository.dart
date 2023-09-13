import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/providers/firebase_providers.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/features/professionals/chat/screens/chat.dart';
import 'package:health_app/models/chat_request.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/failure.dart';
import '../../../../core/type_defs.dart';
import '../../../../models/chat_message_model.dart';

final professionalChatRepositoryProvider =
    Provider((ref) => ProfessionalChatRepository(ref.read(firestoreProvider)));

class ProfessionalChatRepository {
  final FirebaseFirestore _firestore;

  ProfessionalChatRepository(this._firestore);

// get chat requests
  Stream<List<ChatRequest>> getChatRequestsStream(String proUID) {
    final snapshot = _firestore
        .collection('users')
        .doc('professionals')
        .collection('professionals')
        .doc(proUID)
        .collection('messages')
        .snapshots()
        .asyncMap((event) async {
      List<ChatRequest> chatRequests = [];
      for (var doc in event.docs) {
        var chatRequest = ChatRequest.fromMap(doc.data());
        chatRequests.add(chatRequest);
      }
      return chatRequests;
    });

    return snapshot;
  }

  // send message to public user
  FutureEither<Message?> sendMessage(
    final String textmessage,
    final ProviderRef ref,
  ) async {
    try {
      final professionalUser = ref.read(professionalUserProvider);
      final publicUserSender = ref.read(selectedSenderProvider).uid;
      var timesent = DateTime.now();
      if (textmessage != null) {
        const messageId = Uuid();
        Message newMessage = Message(
            id: messageId.v4(),
            senderId: professionalUser!.uid,
            receiverId: publicUserSender,
            content: textmessage,
            timestamp: timesent);
        await _firestore
            .collection('users')
            .doc('professionals')
            .collection('professionals')
            .doc(professionalUser.uid)
            .collection('messages')
            .doc(newMessage.receiverId)
            .collection('messages')
            .add(newMessage.toMap());

        return right(newMessage);
      } else {
        // do something about user empty input
        return right(null);
      }
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure('error " $e'));
    }
  }

  // load messages
  Stream<List<Message>> messageStream(
      String currentProfessionalUID, String selectedSenderUID) {
    return _firestore
        .collection('users')
        .doc('professionals')
        .collection('professionals')
        .doc(currentProfessionalUID)
        .collection('messages')
        .doc(selectedSenderUID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((event) async {
      final List<Message> messages = [];
      for (var doc in event.docs) {
        var message = Message.fromMap(doc.data());
        messages.add(message);
      }
      return messages;
    });
  }
}

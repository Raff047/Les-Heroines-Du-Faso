import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/models/chat_request.dart';
import 'package:health_app/models/public_user_model.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/failure.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/type_defs.dart';
import '../../../../models/chat_message_model.dart';
import '../../../../models/professional_user_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../screens/chat.dart';

// CLASS PROVIDER
final publicUserChatRepositoryProvider = Provider(
  (ref) => PublicUserChatRepository(
    ref.read(firestoreProvider),
  ),
);

class PublicUserChatRepository {
  final FirebaseFirestore _firestore;

  PublicUserChatRepository(this._firestore);

  // load all professionals from firestore
  Future<List<Professional>> loadProfessionals() async {
    var querySnapshot = await _firestore
        .collection('users')
        .doc('professionals')
        .collection('professionals')
        .get();

    List<Professional> professionals = [];
    for (var doc in querySnapshot.docs) {
      professionals.add(Professional.fromMap(doc.data()));
    }
    return professionals;
  }

  // save user data to message subcollection
  void _saveDataToContactsSubcollection(
    PublicUser senderData,
    Professional recieverData,
    String text,
    String recieverId,
    DateTime timesent,
  ) async {
    // users -> recieverID (selected pro) -> chats -> curr pUserID -> set data
    var recieverChatRequest = ChatRequest(
        name: senderData.name,
        profilePic: senderData.profilePic,
        chatRequestID: senderData.uid,
        lastMessage: text,
        timesent: timesent);

    await _firestore
        .collection('users')
        .doc('professionals')
        .collection('professionals')
        .doc(recieverId)
        .collection('messages')
        .doc(senderData.uid)
        .set(recieverChatRequest.toMap());

    // users -> curr pUserID-> chats ->  recieverID (selected pro)  -> set data
  }

  // send message to a selected professional
  FutureEither<Message?> sendMessage(
    final String textmessage,
    final WidgetRef ref,
  ) async {
    try {
      final selectedProfessional = ref.watch(selectedProfessionalProvider);
      final currentPublicUser = ref.watch(publicUserProvider)!;
      var timesent = DateTime.now();
      if (textmessage != null) {
        const messageId = Uuid();
        Message newMessage = Message(
            id: messageId.v4(),
            senderId: currentPublicUser.uid,
            receiverId: selectedProfessional.uid,
            content: textmessage,
            timestamp: timesent);
        _saveDataToContactsSubcollection(
            currentPublicUser,
            selectedProfessional,
            textmessage,
            selectedProfessional.uid,
            timesent);
        await _firestore
            .collection('users')
            .doc('professionals')
            .collection('professionals')
            .doc(newMessage.receiverId)
            .collection('messages')
            .doc(newMessage.senderId)
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
}

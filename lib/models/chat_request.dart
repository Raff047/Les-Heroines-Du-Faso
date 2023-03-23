// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChatRequest {
  final String name;
  final String profilePic;
  final String chatRequestID;
  final String lastMessage;
  final DateTime timesent;
  ChatRequest({
    required this.name,
    required this.profilePic,
    required this.chatRequestID,
    required this.lastMessage,
    required this.timesent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'chatRequestID': chatRequestID,
      'lastMessage': lastMessage,
      'timesent': timesent.millisecondsSinceEpoch,
    };
  }

  factory ChatRequest.fromMap(Map<String, dynamic> map) {
    return ChatRequest(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      chatRequestID: map['chatRequestID'] as String,
      lastMessage: map['lastMessage'] as String,
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent'] as int),
    );
  }
}

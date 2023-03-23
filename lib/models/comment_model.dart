// ignore_for_file: public_member_api_docs, sort_constructors_first

class CommunityComment {
  final String id;
  final String postId;
  final String authorUid;
  final String text;
  final String authorName;
  final String authorAvatarUrl;
  final DateTime createdAt;

  CommunityComment({
    required this.id,
    required this.postId,
    required this.authorUid,
    required this.text,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.createdAt,
  });

  CommunityComment copyWith({
    String? id,
    String? postId,
    String? authorUid,
    String? text,
    String? authorName,
    String? authorAvatarUrl,
    DateTime? createdAt,
  }) {
    return CommunityComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorUid: authorUid ?? this.authorUid,
      text: text ?? this.text,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'authorUid': authorUid,
      'text': text,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CommunityComment.fromMap(Map<String, dynamic> map) {
    return CommunityComment(
      id: map['id'] as String,
      postId: map['postId'] as String,
      authorUid: map['authorUid'] as String,
      text: map['text'] as String,
      authorName: map['authorName'] as String,
      authorAvatarUrl: map['authorAvatarUrl'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'CommunityComment(id: $id, postId: $postId, authorUid: $authorUid, text: $text, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CommunityComment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.authorUid == authorUid &&
        other.text == text &&
        other.authorName == authorName &&
        other.authorAvatarUrl == authorAvatarUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        authorUid.hashCode ^
        text.hashCode ^
        authorName.hashCode ^
        authorAvatarUrl.hashCode ^
        createdAt.hashCode;
  }
}

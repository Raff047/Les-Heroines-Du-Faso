import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String description;
  final String image;
  final String communityName;
  final List<String> likes;
  final int commentCount;
  final String username;
  final String userUid;
  final String userRole;
  final String userProfilePic;
  final bool isPinned;
  final DateTime postedAt;
  Post({
    required this.id,
    required this.description,
    required this.image,
    required this.communityName,
    required this.likes,
    required this.commentCount,
    required this.username,
    required this.userUid,
    required this.userRole,
    required this.userProfilePic,
    required this.postedAt,
    required this.isPinned,
  });

  Post copyWith({
    String? id,
    String? description,
    String? image,
    String? communityName,
    List<String>? likes,
    int? commentCount,
    String? username,
    String? userUid,
    String? userRole,
    String? userProfilePic,
    DateTime? postedAt,
  }) {
    return Post(
      id: id ?? this.id,
      description: description ?? this.description,
      image: image ?? this.image,
      communityName: communityName ?? this.communityName,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      userUid: userUid ?? this.userUid,
      userRole: userRole ?? this.userRole,
      userProfilePic: userProfilePic ?? this.userProfilePic,
      postedAt: postedAt ?? this.postedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'description': description});
    result.addAll({'image': image});
    result.addAll({'communityName': communityName});
    result.addAll({'likes': likes});
    result.addAll({'commentCount': commentCount});
    result.addAll({'username': username});
    result.addAll({'userUid': userUid});
    result.addAll({'userRole': userRole});
    result.addAll({'userProfilePic': userProfilePic});
    result.addAll({'postedAt': postedAt.millisecondsSinceEpoch});
    result.addAll({'isPinned': isPinned});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        id: map['id'] ?? '',
        description: map['description'] ?? '',
        image: map['image'] ?? '',
        communityName: map['communityName'] ?? '',
        likes: List<String>.from(map['likes']),
        commentCount: map['commentCount']?.toInt() ?? 0,
        username: map['username'] ?? '',
        userUid: map['userUid'] ?? '',
        userRole: map['userRole'] ?? '',
        userProfilePic: map['userProfilePic'] ?? '',
        postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
        isPinned: map['isPinned'] ?? '');
  }

  @override
  String toString() {
    return 'Post(id: $id, description: $description, image: $image, communityName: $communityName, likes: $likes, commentCount: $commentCount, username: $username, userUid: $userUid, userRole: $userRole, userProfilePic: $userProfilePic, postedAt: $postedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.description == description &&
        other.image == image &&
        other.communityName == communityName &&
        listEquals(other.likes, likes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.userUid == userUid &&
        other.userRole == userRole &&
        other.userProfilePic == userProfilePic &&
        other.postedAt == postedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        image.hashCode ^
        communityName.hashCode ^
        likes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        userUid.hashCode ^
        userRole.hashCode ^
        userProfilePic.hashCode ^
        postedAt.hashCode;
  }
}

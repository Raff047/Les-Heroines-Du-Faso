// ignore_for_file: public_member_api_docs, sort_constructors_first

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
  final String userProfilePic;
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
    required this.userProfilePic,
    required this.postedAt,
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
      userProfilePic: userProfilePic ?? this.userProfilePic,
      postedAt: postedAt ?? this.postedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'image': image,
      'communityName': communityName,
      'likes': likes,
      'commentCount': commentCount,
      'username': username,
      'userUid': userUid,
      'userProfilePic': userProfilePic,
      'postedAt': postedAt.millisecondsSinceEpoch,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        id: map['id'] ?? '',
        description: map['description'] ?? '',
        image: map['image'] ?? '',
        communityName: map['communityName'] ?? '',
        likes: List<String>.from(
          (map['likes']),
        ),
        commentCount: map['commentCount'],
        postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
        userProfilePic: map['userProfilePic'] ?? '',
        userUid: map['userUid'] ?? '',
        username: map['username'] ?? '');
  }

  @override
  String toString() {
    return 'Post(id: $id, description: $description, image: $image, communityName: $communityName, likes: $likes, commentCount: $commentCount, username: $username, userUid: $userUid, userProfilePic: $userProfilePic, postedAt: $postedAt)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.image == image &&
        other.communityName == communityName &&
        listEquals(other.likes, likes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.userUid == userUid &&
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
        userProfilePic.hashCode ^
        postedAt.hashCode;
  }
}

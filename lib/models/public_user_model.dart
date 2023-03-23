import 'package:health_app/models/user_base_model_class.dart';

class PublicUser extends UserModel {
  final String phoneNumber;

  PublicUser({
    required this.phoneNumber,
    required super.uid,
    required super.name,
    required super.profilePic,
    required super.role,
  });

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'phoneNumber': phoneNumber});

    return result;
  }

  factory PublicUser.fromMap(Map<String, dynamic> map) {
    return PublicUser(
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      role: map['role'] ?? '',
    );
  }
}

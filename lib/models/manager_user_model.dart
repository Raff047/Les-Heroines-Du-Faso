import 'package:health_app/models/user_base_model_class.dart';

class Manager extends UserModel {
  Manager({
    required super.uid,
    required super.name,
    required super.profilePic,
    required super.role,
    required super.email,
  });

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({});

    return result;
  }

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      role: map['role'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

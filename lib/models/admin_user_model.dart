import 'package:health_app/models/user_base_model_class.dart';

class Admin extends UserModel {
  Admin(
      {required super.uid,
      required super.name,
      required super.profilePic,
      required super.role,
      required super.email});

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({});

    return result;
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      role: map['role'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

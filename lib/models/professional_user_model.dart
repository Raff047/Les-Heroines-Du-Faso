import 'package:health_app/models/user_base_model_class.dart';

class Professional extends UserModel {
  final String specializedIn;

  Professional(
      {required this.specializedIn,
      required super.uid,
      required super.name,
      required super.profilePic,
      required super.role,
      required super.email});

  @override
  Map<String, dynamic> toMap() {
    final result = super.toMap();
    result.addAll({'specializedIn': specializedIn});
    return result;
  }

  factory Professional.fromMap(Map<String, dynamic> map) {
    return Professional(
      specializedIn: map['specializedIn'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      role: map['role'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

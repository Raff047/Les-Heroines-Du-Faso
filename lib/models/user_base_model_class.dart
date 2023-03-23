class UserModel {
  final String uid;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String profilePic;
  final String role;

  UserModel({
    required this.uid,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.profilePic,
    required this.role,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicUrl,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePic: profilePicUrl ?? profilePic,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'name': name});
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phoneNumber != null) {
      result.addAll({'phoneNumber': phoneNumber});
    }
    result.addAll({'profilePicUrl': profilePic});
    result.addAll({'role': role});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      profilePic: map['profilePicUrl'] ?? '',
      role: map['role'] ?? '',
    );
  }
}

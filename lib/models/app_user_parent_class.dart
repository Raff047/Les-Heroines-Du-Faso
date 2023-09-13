// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class StaffUser {
//   final String uid;
//   final String name;
//   final String email;
//   final String profilePic;

//   StaffUser({
//     required this.uid,
//     required this.name,
//     required this.email,
//     required this.profilePic,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'profilePic': profilePic,
//     };
//   }

//   factory StaffUser.fromMap(Map<String, dynamic> map) {
//     return StaffUser(
//       uid: map['uid'] as String,
//       name: map['name'] as String,
//       email: map['email'] as String,
//       profilePic: map['profilePic'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory StaffUser.fromJson(String source) =>
//       StaffUser.fromMap(json.decode(source) as Map<String, dynamic>);
// }

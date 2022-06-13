import 'dart:ffi';

class IdentityUser {
  String uid;
  String? name;
  String? profilePicture;
  String? email;
  int? age;

  IdentityUser(
      {required this.uid,
      this.name,
      this.profilePicture,
      this.email,
      this.age});

  factory IdentityUser.fromJson(Map<String, dynamic> json) {
    return IdentityUser(
        uid: json['Uid'],
        age: json['Age'],
        name: json['Name'],
        email: json['Email'],
        profilePicture: json['ProfilePicture']);
  }
}

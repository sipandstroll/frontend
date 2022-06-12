import 'dart:ffi';

class IdentityUser {
  String uid;
  String? name;
  String? profilePicture;
  String? email;
  Uint32? age;

  IdentityUser(this.uid, this.name, this.profilePicture, this.email, this.age);
}

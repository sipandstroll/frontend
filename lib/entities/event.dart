import 'package:frontend/entities/user.dart';

class Event {
  int? id;
  IdentityUser owner;
  String picture;
  String title;
  String? description;

  Event(
      {this.id,
      required this.owner,
      required this.picture,
      required this.title,
      this.description});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['Id'],
        owner: IdentityUser.fromJson(json['User']),
        picture: json['Picture'],
        title: json['Title'],
        description: json['Description']);
  }

  Map toJson() => {
        'UserUid': owner.uid,
        'Picture': picture,
        'Title': title,
        'Description': description
      };
}

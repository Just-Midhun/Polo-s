import 'package:firebase_database/firebase_database.dart';

class UserModel {
  dynamic phone;
  dynamic name;
  dynamic id;
  dynamic email;
  dynamic address;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.id,
  });

  UserModel.fromSnapshot(DataSnapshot dataSnapshot) {
    final data = dataSnapshot.value as Map<dynamic, dynamic>;
    id = dataSnapshot.key;
    email = data["email"];
    name = data["name"];
    phone = data["phone"];
  }
}

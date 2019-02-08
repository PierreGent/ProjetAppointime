import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class User {
  User({
    this.avatar,
    @required this.firstName,
    @required this.lastName,
    @required this.address,
    @required this.credit,
    @required this.phoneNumber,
    @required this.isPro,
    @required this.email,
    @required this.password,
  });

  String avatar;
  final String firstName;
  final String email;
  final String password;
  final String lastName;
  final String address;
  final int credit;
  final String phoneNumber;
  final bool isPro;

  static User fromMap(Map mailPass, Map map) {
    var name = map['name'];

    return new User(
        //avatar: map['picture']['large'],
        email: mailPass['email'],
        password: mailPass['password'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        address: map['address'],
        credit: map['credit'],
        phoneNumber: map['phoneNumber'],
        isPro: map['isPro']);
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  String toString() {
    return this.firstName + "    " + this.lastName;
  }
}

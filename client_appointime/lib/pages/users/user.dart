import 'package:client_appointime/pages/business/favorite.dart';
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
    @required this.favorite,
  });

  String avatar;
  final String firstName;
  final String email;
  final String password;
  final String lastName;
  String address;
  final int credit;
  String phoneNumber;
  final bool isPro;
  List<Favorite> favorite;

  static User fromMap(Map mailPass, Map map) {
    return new User(
        email: mailPass['email'],
        password: mailPass['password'],
        firstName: '${_capitalize(map['firstName'])}',
        lastName: '${_capitalize(map['lastName'])}',
        address: map['address'],
        credit: map['credit'],
        phoneNumber: map['phoneNumber'],
        isPro: map['isPro'],
        favorite: []);
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  String toString() {
    return this.firstName + "    " + this.lastName;
  }
}

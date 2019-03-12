import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class Business {
  Business(
      {@required this.id,
      @required this.name,
      @required this.address,
      @required this.phoneNumber,
      @required this.cancelAppointment,
      @required this.fieldOfActivity,
      @required this.description,
      @required this.avatarUrl,
      @required this.bannerUrl,
      @required this.prestation,
      @required this.boss,
      @required this.businessShedule});

  final String id;
  final User boss;
  final String name;
  final String address;
  final String phoneNumber;
  final int cancelAppointment;
  final String fieldOfActivity;
  final String description;
  final String avatarUrl;
  final String bannerUrl;
  List<Prestation> prestation;
  final Map<dynamic,dynamic> businessShedule;

  static Business fromMap(
      String idBusiness, Map map, User user, Map<dynamic,dynamic> businessSheduleMap) {
    print(businessSheduleMap);
    return new Business(
        //avatar: map['picture']['large'],
        id: idBusiness,
        name: '${_capitalize(map['name'])}',
        address: map['address'],
        phoneNumber: map['phoneNumber'],
        description: map['description'],
        cancelAppointment: map['cancelAppointment'],
        fieldOfActivity: map['fieldOfActivity'].toString(),
        avatarUrl: map['avatarUrl'],
        bannerUrl: map['bannerUrl'],
        boss: user,
        prestation: [],
        businessShedule: businessSheduleMap);
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  String toString() {
    return this.name + "    " + fieldOfActivity;
  }
}

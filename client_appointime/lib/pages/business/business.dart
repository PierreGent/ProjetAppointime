import 'package:client_appointime/pages/business/businessdetails/arcbannerImage.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:flutter/material.dart';
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
      @required this.avatar,
      @required this.banner,
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
  final NetworkImage avatar;
  final ArcBannerImage banner;
  List<Prestation> prestation;
  final Map<dynamic,dynamic> businessShedule;

  static Business fromMap(
      String idBusiness, Map map, User user, Map<dynamic,dynamic> businessSheduleMap,Activity activity) {
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
        avatar: activity.avatar,
        banner: activity.banner,
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

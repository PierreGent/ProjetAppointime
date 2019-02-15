import 'package:meta/meta.dart';

class Business {
  Business({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.phoneNumber,
    @required this.cancelAppointment,
    @required this.fieldOfActivity,
    @required this.description,
    @required this.avatarUrl,
    @required this.bannerUrl
  });

  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final int cancelAppointment;
  final String fieldOfActivity;
  final String description;
  final String avatarUrl;
  final String bannerUrl;


  static Business fromMap(String idBusiness, Map map) {
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
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  String toString() {
    return this.name + "    " + fieldOfActivity;
  }
}

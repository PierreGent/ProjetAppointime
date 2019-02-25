import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
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
      @required this.boss});

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

  static Business fromMap(String idBusiness, Map map,User user) {
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
      boss:user,
      prestation: [],
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  String toString() {
    return this.name + "    " + fieldOfActivity;
  }
}

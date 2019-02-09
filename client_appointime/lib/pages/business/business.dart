
import 'package:meta/meta.dart';

class Business {
  Business({
     this.avatar,
    @required this.name,
    @required this.address,
    @required this.cancelAppointment,
    @required this.fieldOfActivity,
    @required this.description,
  });

   String avatar;
  final String name;
  final String address;
  final int cancelAppointment;
  final String fieldOfActivity;
  final String description;



  static Business fromMap(Map map) {

    return new Business(
      //avatar: map['picture']['large'],
      name: '${_capitalize(map['name'])}',
      address: map['address'],
      description: map['description'],
      cancelAppointment: map['cancelAppointment'],
      fieldOfActivity: map['fieldOfActivity'],
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
  String toString(){
    return this.name+"    "+fieldOfActivity;
  }
}

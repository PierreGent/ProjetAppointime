import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:meta/meta.dart';

class Appointment {
  final String id;
  final User user;
  final Prestation prestation;
   DateTime day;
  final int startTime;
 bool confirmed;
  Appointment({
    @required this.id,
    @required this.user,
    @required this.day,
    @required this.prestation,
    @required this.startTime,
    @required this.confirmed,
  });

  static Appointment fromMap(String id, Map map, User user, Prestation presta) {
    return new Appointment(
      id: id,
      user: user,
      day: DateTime.parse(map['dayAppointment']),
      prestation: presta,
      startTime: map['startAppointment'],
      confirmed: map["confirmed"]
    );
  }
}

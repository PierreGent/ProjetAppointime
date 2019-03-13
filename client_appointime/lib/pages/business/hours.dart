import 'package:meta/meta.dart';

class Hours {
  final String id;
  final String buisnessId;
  final double closingTime;
  final int halfDayId;
  final double openingTime;

  Hours({
    @required this.id,
    @required this.buisnessId,
    @required this.closingTime,
    @required this.halfDayId,
    @required this.openingTime,
  });

  static Hours fromMap(String idHours, Map map) {
    return new Hours(
      id: idHours,
      buisnessId: map['businessId'],
      closingTime: map['closingTime'].toDouble(),
      halfDayId: map['halfDayId'],
      openingTime: map['openingTime'].toDouble(),
    );
  }
}
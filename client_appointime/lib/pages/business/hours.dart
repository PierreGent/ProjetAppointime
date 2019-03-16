import 'package:meta/meta.dart';

class Hours {
  final String id;
  final String businessId;
  final double closingTime;
  final int halfDayId;
  final double openingTime;

  Hours({
    @required this.id,
    @required this.businessId,
    @required this.closingTime,
    @required this.halfDayId,
    @required this.openingTime,
  });

  static Hours fromMap(String idHours, Map map) {
    return new Hours(
      id: idHours,
      businessId: map['businessId'],
      closingTime: map['closingTime'].toDouble(),
      halfDayId: map['halfDayId'],
      openingTime: map['openingTime'].toDouble(),
    );
  }
}
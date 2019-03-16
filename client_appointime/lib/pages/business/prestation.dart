import 'package:client_appointime/pages/business/business.dart';
import 'package:meta/meta.dart';

class Prestation {
  final String id;
  final String business;
  final String namePresta;
  final String description;
  final int duration;
  final double price;
  final bool autoConf;

  Prestation({
    @required this.id,
    @required this.business,
    @required this.namePresta,
    @required this.description,
    @required this.duration,
    @required this.price,
    @required this.autoConf,
  });

  static Prestation fromMap(String idPresta, Map map) {
    return new Prestation(
      id: idPresta,
      business: map["businessId"],
      namePresta: map['name'],
      description: map['description'],
      duration: map['duration'],
      price: map['price'].toDouble(),
      autoConf: map["autoConf"]
    );
  }
}

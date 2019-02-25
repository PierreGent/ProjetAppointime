import 'package:meta/meta.dart';

class Prestation {
  final String id;
  final String buisnessId;
  final String namePresta;
  final String description;
  final int duration;
  final double price;

  Prestation({
    @required this.id,
    @required this.buisnessId,
    @required this.namePresta,
    @required this.description,
    @required this.duration,
    @required this.price,
  });

  static Prestation fromMap(String idPresta, Map map) {
    return new Prestation(
      id: idPresta,
      buisnessId: map['buisnessId'],
      namePresta: map['name'],
      description: map['description'],
      duration: map['duration'],
      price: map['price'].toDouble(),
    );
  }
}

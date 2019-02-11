
import 'package:meta/meta.dart';

class Favorite {
  Favorite({
    @required this.id,
    @required this.userId,
    @required this.businessId,
  });

  final String id;
  final String userId;
  final String businessId;



  static Favorite fromMap(String idFavorite,Map map) {

    return new Favorite(
      id:idFavorite,
      userId: map['user'],
      businessId: map['business'],
    );
  }


  String toString(){
    return this.userId+"    "+this.businessId;
  }
}

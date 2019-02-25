import 'package:meta/meta.dart';

class Activity {
  Activity({
    @required this.name,
    @required this.id,
  });

  final String name;
  final String id;

  static Activity fromMap(String id, Map map) {
    return new Activity(
      name: map['name'],
      id: id,
    );
  }
}

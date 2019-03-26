import 'package:client_appointime/pages/business/businessdetails/arcbannerImage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Activity {
  Activity({
    @required this.name,
    @required this.id,
    @required this.banner,
    @required this.avatar,
  });

  final String name;
  final String id;
  final NetworkImage avatar;
  final ArcBannerImage banner;

  static Activity fromMap(String id, Map map) {
    return new Activity(
      name: map['name'],
      banner: ArcBannerImage(map['banner']),
      avatar: NetworkImage(map['avatar']),
      id: id,
    );
  }
}

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/pages/business/business.dart';

class BusinessListPage extends StatefulWidget {
  @override
  _BusinessListPageState createState() => new _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  List<Business> _business = [];
  bool _isFavorited=false;
  int _favoriteCount=0;
  @override
  void initState() {
    super.initState();
     _loadFriends();
  }

  Future<void> _loadFriends() async {
    await FirebaseDatabase.instance.reference().child('business').once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      print(values.toString());
      values.forEach((k,v) {
        print(k);
        print(v["name"]);
        setState(() {
          this._business.add(Business.fromMap(v));
        });



      });
    });
  }
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }
  Widget _buildFriendListTile(BuildContext context, int index) {
    var business = _business[index];

    return Stack(
        children: <Widget>[
        ListTile(
      onTap: () => _navigateToFriendDetails(business, index),

      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
         // backgroundImage: new NetworkImage(friend.avatar),
        ),
      ),
      title: new Text(business.name),
      subtitle: new Text(business.address),

    ),

          Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
              color: Colors.red[500],
              onPressed: _toggleFavorite,
            ),
          ),
    ],);
    }

  void _navigateToFriendDetails(Business friend, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_business.isEmpty) {
      print(_business.toString());
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView.builder(
        itemCount: _business.length,
        itemBuilder: _buildFriendListTile,
      );
    }

    return Container(
      child: content,
    );
  }
}

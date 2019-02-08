import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/pages/business/business.dart';

class BusinessListPage extends StatefulWidget {
  @override
  _BusinessListPageState createState() => new _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  List<Business> _friends = [];

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
          this._friends.add(Business.fromMap(v));
        });



      });
    });
  }

  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];

    return new ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
         // backgroundImage: new NetworkImage(friend.avatar),
        ),
      ),
      title: new Text(friend.name),
      subtitle: new Text(friend.address),
    );
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

    if (_friends.isEmpty) {
      print(_friends.toString());
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView.builder(
        itemCount: _friends.length,
        itemBuilder: _buildFriendListTile,
      );
    }

    return Container(
      child: content,
    );
  }
}

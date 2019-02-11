import 'dart:async';

import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/pages/business/business.dart';

class BusinessListPage extends StatefulWidget {
  BusinessListPage(this.auth,this.user);
  final User user;
  final BaseAuth auth;
  @override
  _BusinessListPageState createState() => new _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {

  List<Business> _business = [];
  FirebaseUser getInfosUser;
  @override
  void initState() {
    super.initState();
     _loadBusiness();
     _loadFavorite();
  }

  Future<void> _loadBusiness() async {
    await FirebaseDatabase.instance.reference().child('business').once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      print(values.toString());
      values.forEach((k,v) async {

        print(k);
        print(v["name"]);
        setState(() {
          this._business.add(Business.fromMap(k,v));
        });



      });
    });
  }
  Future<Business> loadBusiness (
      String id
      ) async{
    Business business;
  FirebaseDatabase.instance.reference().child('business').child(id).once().then((DataSnapshot result) {

  print(result.value);
  Map<dynamic, dynamic> values=result.value;
  setState(() {
  business = Business.fromMap(id,values);
  });

  });
    return business;
  }


  Future<void> _loadFavorite() async {
    getInfosUser = await widget.auth.getCurrentUser();
    await FirebaseDatabase.instance.reference().child('favorite').once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      print(values.toString());
      values.forEach((k,v)  async {

        print(k);
        print(v["name"]);


          if(v["user"]==getInfosUser)
             widget.user.favorite.add(await loadBusiness(v["business"]));




      });
    });
  }

   _toggleFavorite(Business business)  {

     Future.delayed(Duration(seconds: 1), () async {
       getInfosUser = await widget.auth.getCurrentUser();
       if (widget.user.favorite.contains(business)) {
         FirebaseDatabase.instance.reference().child('favorite').child("user")
             .child(getInfosUser.uid)
             .parent().parent().child("business").child(business.id)
             .remove();
         widget.user.favorite.remove(business);
       } else {
         await FirebaseDatabase.instance.reference().child('favorite')
             .push()
             .set(
             {
               'user': getInfosUser.uid,
               'business': business.id,
             });
         widget.user.favorite.add(business);
         print(widget.user.favorite);
       }
       print("ONESTLAAAAA");
     });
     print("ONESTLAAAAA");
  }
  Widget _buildFriendListTile(BuildContext context, int index)  {
    Business business = _business[index];

    return Stack(
        children: <Widget>[
        ListTile(
      onTap: () => _toggleFavorite(business),//_navigateToFriendDetails(business, index),

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
            padding: EdgeInsets.all(7),
            child: IconButton(
              icon: (widget.user.favorite.contains(business) ? Icon(Icons.star) : Icon(Icons.star_border)),
              color: Colors.red[500],
              onPressed: _toggleFavorite(business),
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

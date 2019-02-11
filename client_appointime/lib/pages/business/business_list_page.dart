import 'dart:async';

import 'package:client_appointime/pages/business/favorite.dart';
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
bool _isLoading=false;
  List<Business> _business = [];
  FirebaseUser getInfosUser;
  @override
  void initState() {
    super.initState();


    _isLoading=false;


     _loadBusiness();
     _loadFavorite();

  }

  Future<void> _loadBusiness() async {
    setState(() {
      _isLoading=true;

    });
    await FirebaseDatabase.instance.reference().child('business').once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      values.forEach((k,v) async {

        setState(() {
          this._business.add(Business.fromMap(k,v));
        });



      });
    });
    setState(() {
      _isLoading=false;

    });
  }
  Future<Business> loadBusiness (
      String id
      ) async{
    Business business;
  FirebaseDatabase.instance.reference().child('business').child(id).once().then((DataSnapshot result) {

  Map<dynamic, dynamic> values=result.value;
  setState(() {
  business = Business.fromMap(id,values);
  });

  });
    return business;
  }


  Future<void> _loadFavorite() async {
    setState(() {
      _isLoading=true;

    });
    widget.user.favorite=[];
    getInfosUser = await widget.auth.getCurrentUser();
    await FirebaseDatabase.instance.reference().child('favorite').once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      if(values!=null)
      values.forEach((k,v) async {
        if(v["user"]==getInfosUser.uid)
        setState(() {
         widget.user.favorite.add(Favorite.fromMap(k, v));
        });



      });
    });
    setState(() {
      _isLoading=false;

    });
  }

   _toggleFavorite(Business business)  async{
     setState(() {
       _isLoading=true;

     });

     Future.delayed(Duration(seconds: 1), () async {

       bool toDelete=false;
       Favorite favToDelete=null;
       getInfosUser = await widget.auth.getCurrentUser();
       widget.user.favorite.forEach((favorite){
         if(favorite.businessId==business.id) {
           toDelete=true;
           FirebaseDatabase.instance.reference().child('favorite').child(
               favorite.id)
               .remove();
          favToDelete=favorite;
         }
       });



       if(!toDelete) {
         await FirebaseDatabase.instance.reference().child('favorite')
             .push()
             .set(
             {
               'user': getInfosUser.uid,
               'business': business.id,
             });
         setState(() {
           _loadFavorite();
         });
       }else{
         setState(()  {
         widget.user.favorite.remove(favToDelete);
         });
       }
       setState(() {
         _isLoading=false;

       });

     });

  }
  Widget _buildFriendListTile(BuildContext context, int index)  {
    Business business = _business[index];
    bool isFavorite=false;
    widget.user.favorite.forEach((favorite) {
      if(favorite.businessId==business.id)
        isFavorite=true;
    });
    return Stack(
        children: <Widget>[
          ListTile(
            leading: new Hero(
              tag: index,
              child: new CircleAvatar(
                // backgroundImage: new NetworkImage(friend.avatar),
              ),
            ),
            title: new Text(business.name),
            subtitle: new Text(business.address),
trailing: Container(
  padding: EdgeInsets.all(10),
  child: IconButton(
    icon: (isFavorite ? Icon(Icons.star) : Icon(Icons.star_border)),
    color: Colors.red[500],
    onPressed: ()=>_toggleFavorite(business),
  ),
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
Widget _showCircularProgress() {
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

  @override
  Widget build(BuildContext context) {

    Widget content;


      content = new ListView.builder(
        itemCount: _business.length,
        itemBuilder: _buildFriendListTile,
      );


    return Container(
      child: Stack(
        children: <Widget>[
          content,
          _showCircularProgress(),
        ],
      )
    );
  }
}

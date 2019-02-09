import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/header/user_detail_header.dart';
import 'package:client_appointime/pages/users/usersdetails/user_detail_body.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  UserDetailsPage(
    this.user,
   this.avatarTag
);

  final User user;
  final Object avatarTag;


  @override
  _UserDetailsPageState createState() => new _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String isPro="Particulier";
  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.black38,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if(widget.user.isPro)
      isPro="Professionnel";
    var theme = Theme.of(context);

    var textTheme = theme.textTheme;


    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new UserDetailHeader(
                widget.user,
                widget.avatarTag
              ),


              //new UserShowcase(widget.user),
            ],
          ),
        ),
            new Padding(
              padding: const EdgeInsets.all(24.0),
              child: new UserDetailBody(widget.user),
            ),
          new Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: new Text(
              isPro,
              style:
              textTheme.body1.copyWith(color: Colors.grey, fontSize: 16.0),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: new Row(
              children: <Widget>[
                _createCircleBadge(Icons.star, theme.accentColor),
                _createCircleBadge(Icons.star, theme.accentColor),
                _createCircleBadge(Icons.star_border, Colors.white12),
              ],
            ),
          ),
        ],),

      ),

    );
  }
}

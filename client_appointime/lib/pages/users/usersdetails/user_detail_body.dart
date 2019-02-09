import 'package:client_appointime/pages/users/user.dart';
import 'package:flutter/material.dart';

class UserDetailBody extends StatefulWidget {
  UserDetailBody(this.user);
  final User user;

  @override
  UserDetailBodyState createState() {
    return new UserDetailBodyState();
  }
}

class UserDetailBodyState extends State<UserDetailBody> {
String ispro="Particulier";

  Widget _buildLocationInfo(TextTheme textTheme) {

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: <Widget>[
    new Container(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 20.0,
        ),
        new Text(
          widget.user.address,
          style: textTheme.subhead.copyWith(color: Colors.white,fontSize: 20),

        ),
      ],
    ),
    ),
    new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Icon(
            Icons.fastfood,
            color: Colors.white,
            size: 20.0,
          ),
          new Text(

            'TARTIFLETTE',
            style: textTheme.subhead.copyWith(color: Colors.white,fontSize: 20,fontStyle: FontStyle.italic),
          ),

        ],
      ),
    ),

    new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Icon(
            Icons.phone_in_talk,
            color: Colors.white,
            size: 20.0,
          ),
          new Text(

            widget.user.phoneNumber,
            textAlign: TextAlign.right,
            style: textTheme.subhead.copyWith(color: Colors.white,fontSize: 20),
          ),

        ],
      ),
    ),






      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(widget.user.isPro)
      ispro="Professionnel";
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          widget.user.firstName+" "+widget.user.lastName,
          style: textTheme.headline.copyWith(color: Colors.white),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text(
            ispro,
            style:
                textTheme.body1.copyWith(color: Colors.white70, fontSize: 16.0),
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
      ],
    );
  }
}

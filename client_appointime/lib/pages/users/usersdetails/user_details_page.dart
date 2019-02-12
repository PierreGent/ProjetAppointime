import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/header/user_detail_header.dart';
import 'package:client_appointime/pages/users/usersdetails/user_detail_body.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  UserDetailsPage(this.user, this.avatarTag, this.auth);

  final BaseAuth auth;
  final User user;
  final Object avatarTag;

  @override
  _UserDetailsPageState createState() => new _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String isPro = "Particulier";
  bool edit = false;
String text="Modifier";
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

  Widget _createPillButton(
    BuildContext context,
    String textToShow, {
    Color backgroundColor = Colors.transparent,
    textColor,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {
          if (edit)
            setState(() {
              text="Modifier";
              edit = false;
            });
          else
            setState(() {
              text="Annuler";
              edit = true;
            });
        },
        child: new Text(textToShow),
      ),
    );
  }

  Widget viewFooter() {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    if (edit) return new Container();
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        children: <Widget>[
          _createCircleBadge(Icons.star, theme.accentColor),
          _createCircleBadge(Icons.star, theme.accentColor),
          _createCircleBadge(Icons.star_border, Colors.white12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user.isPro) isPro = "Professionnel";

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new UserDetailHeader(
                          widget.user, widget.avatarTag, edit, widget.auth),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 235,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new DecoratedBox(
                              decoration: new BoxDecoration(
                                border: new Border.all(color: Colors.white30),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: _createPillButton(
                                context,
                                text,
                                backgroundColor: Colors.black.withOpacity(0.5),
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(24.0),
              child: new UserDetailBody(widget.user, edit, widget.auth),
            ),
            viewFooter(),
          ],
        ),
      ),
    );
  }
}

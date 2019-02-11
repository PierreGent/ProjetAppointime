import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/header/diagonally_cut_colored_image.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class UserDetailHeader extends StatelessWidget {
  var BACKGROUND_IMAGE = 'images/myAccount.png';

  UserDetailHeader(this.user, this.avatarTag, this.edit, this.auth);

  final User user;
  final Object avatarTag;
  final bool edit;
  final BaseAuth auth;
  String email;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    if (edit)
      BACKGROUND_IMAGE = 'images/editAccount.png';
    else
      BACKGROUND_IMAGE = 'images/myAccount.png';
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        alignment: Alignment.centerRight,
        fit: BoxFit.cover,
      ),
      color: Colors.blueAccent.withOpacity(1),
    );
  }

  Widget emailShow(TextTheme textTheme) {
    if (!edit) {
      return new Text(user.email,
          style: textTheme.subhead.copyWith(color: const Color(0xFFFFFFFF)));
    } else {
      return new Text("Modification des informations",
          style: textTheme.subhead.copyWith(color: const Color(0xFFFFFFFF)));
    }
  }

  Widget _buildAvatar() {
    return new Hero(
        tag: avatarTag,
        child: new CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: new Center(
            child: new Text(user.firstName[0] + user.lastName[0],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
          ),
          radius: 50.0,
        ));
  }

  Widget _buildUserInfo(TextTheme textTheme) {
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          emailShow(textTheme),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildUserInfo(textTheme),
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}

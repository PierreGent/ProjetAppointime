import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/header/user_detail_header.dart';
import 'package:client_appointime/pages/users/usersdetails/user_detail_body.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class UserEditPage extends StatefulWidget {
  UserEditPage(this.user, this.avatarTag, this.auth);
  final BaseAuth auth;
  final User user;
  final Object avatarTag;

  @override
  _UserEditPageState createState() => new _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new UserDetailHeader(
                      widget.user, widget.avatarTag, true, widget.auth),
                ],
              ),
            ),
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new UserDetailBody(widget.user, true, widget.auth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

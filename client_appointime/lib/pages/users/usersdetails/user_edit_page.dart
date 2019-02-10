import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/header/user_detail_header.dart';
import 'package:client_appointime/pages/users/usersdetails/user_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/validation.dart';

class UserEditPage extends StatefulWidget {
  UserEditPage(
    this.user,
   this.avatarTag
);

  final User user;
  final Object avatarTag;


  @override
  _UserEditPageState createState() => new _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  bool autoValidate = false;
  bool _isLoading;
  String errorMessage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String isPro="Particulier";
  void initState() {
    super.initState();
    _isLoading = false;
    errorMessage = "";
  }
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
    if(widget.user.isPro)
      isPro="Professionnel";
    var theme = Theme.of(context);

    var textTheme = theme.textTheme;

    return  Scaffold(
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new UserDetailHeader(
                widget.user,
                widget.avatarTag,
              true
            ),


            //new UserShowcase(widget.user),
          ],
        ),
    ),
        new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new  UserDetailBody(widget.user,true),


              //new UserShowcase(widget.user),
            ],
          ),
        ),




    ],),

    );






  }
}

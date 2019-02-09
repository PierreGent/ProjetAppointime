import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/user_detail_footer.dart';
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
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xDD3333FF),
          const Color(0xFF00004A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new UserDetailHeader(
                widget.user,
                widget.avatarTag
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new UserDetailBody(widget.user),
              ),
              new UserShowcase(widget.user),
            ],
          ),
        ),
      ),
    );
  }
}

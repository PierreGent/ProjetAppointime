import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class MyBusiness extends StatefulWidget {
  @override
  MyBusiness({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  State<StatefulWidget> createState() => new MyBusinessState();
}

class MyBusinessState extends State<MyBusiness> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("MonBizz"),
      ),
    );
  }
}

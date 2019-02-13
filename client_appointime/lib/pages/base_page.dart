import 'package:client_appointime/pages/business/business_list_page.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;

class BasePage extends StatefulWidget {
  @override
  BasePage(this.auth, this.user);

  final BaseAuth auth;
  final User user;

  State<StatefulWidget> createState() => new BasePageState();
}

class BasePageState extends State<BasePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return Container(
        child: Text("loading"),
      );
    }
   return new Scaffold(

        backgroundColor: globalVar.couleurPrimaire,
        body:BusinessListPage(widget.auth, widget.user,"favorite"));
  }
}

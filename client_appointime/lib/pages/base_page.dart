import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/business_list_page.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  @override
  BasePage(this.auth, this.user,this.businessList,this.favoriteList,this.jobList);

  final User user;
  final BaseAuth auth;
  final List<Activity> jobList;
  final List<Business> businessList;
  List<Business> favoriteList;


  State<StatefulWidget> createState() => new BasePageState();
}

class BasePageState extends State<BasePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return new Scaffold(
        backgroundColor: globalVar.couleurPrimaire,
        resizeToAvoidBottomPadding: false,
        body: BusinessListPage(widget.auth, widget.user, "favorite",widget.businessList,widget.favoriteList,widget.jobList));
  }
}

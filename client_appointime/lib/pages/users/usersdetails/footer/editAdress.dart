
import 'package:client_appointime/pages/users/editUser.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class ConditionsShowcase extends StatelessWidget {
  ConditionsShowcase(this.user,this.auth);
  final User user;
  final BaseAuth auth;
  @override
  Widget build(BuildContext context) {
    return new  EditUser(auth:this.auth,user:this.user,type:"address");
  }
}
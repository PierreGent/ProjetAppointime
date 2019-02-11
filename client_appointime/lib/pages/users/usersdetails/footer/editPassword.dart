import 'package:client_appointime/pages/users/editUser.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class PrestationsShowcase extends StatelessWidget {
  PrestationsShowcase(this.user,this.auth);
  User user;
  BaseAuth auth;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return new  EditUser(auth:this.auth,user:this.user,type:"pass");

  }
}

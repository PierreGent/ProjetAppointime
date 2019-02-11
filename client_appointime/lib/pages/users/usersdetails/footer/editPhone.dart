import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/pages/users/editUser.dart';

class DetailsShowcase extends StatelessWidget {
  DetailsShowcase(this.user,this.auth);
  User user;
  BaseAuth auth;

  @override
  Widget build(BuildContext context) {

    return new  EditUser(auth:this.auth,user:this.user,type:"phone");
  }
}

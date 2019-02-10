import 'package:client_appointime/pages/users/user.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/pages/editAccount.dart';

class DetailsShowcase extends StatelessWidget {
  DetailsShowcase(this.user);
  User user;

  @override
  Widget build(BuildContext context) {

    return new  editAccount(user:this.user,type:"email");
  }
}

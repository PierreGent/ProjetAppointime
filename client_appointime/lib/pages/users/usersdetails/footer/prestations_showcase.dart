import 'package:client_appointime/pages/editAccount.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:flutter/material.dart';

class PrestationsShowcase extends StatelessWidget {
  PrestationsShowcase(this.user);
  User user;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return new  editAccount(user:this.user,type:"pass");

  }
}

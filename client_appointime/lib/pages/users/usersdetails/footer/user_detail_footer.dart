import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/editAdress.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/editPassword.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/editPhone.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class UserShowcase extends StatefulWidget {
  UserShowcase(this.user, this.auth);

  final User user;
  final BaseAuth auth;

  @override
  _UserShowcaseState createState() => new _UserShowcaseState();
}

class _UserShowcaseState extends State<UserShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(child: Icon(Icons.phone, color: Colors.black54)),
      new Tab(child: Icon(Icons.vpn_key, color: Colors.black54)),
      new Tab(child: Icon(Icons.edit_location, color: Colors.black54)),
    ];
    _pages = [
      new DetailsShowcase(widget.user, widget.auth),
      new PrestationsShowcase(widget.user, widget.auth),
      new ConditionsShowcase(widget.user, widget.auth),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.black54,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(600.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

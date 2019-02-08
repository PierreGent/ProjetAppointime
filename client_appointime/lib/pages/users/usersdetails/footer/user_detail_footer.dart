import 'package:client_appointime/pages/users/user.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/Conditions_showcase.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/Details_showcase.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/prestations_showcase.dart';


class UserShowcase extends StatefulWidget {
  UserShowcase(this.user);

  final User user;

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
      new Tab(text: 'Détails'),
      new Tab(text: 'Prestations'),
      new Tab(text: 'Conditions'),
    ];
    _pages = [
      new DetailsShowcase(),
      new PrestationsShowcase(),
      new ConditionsShowcase(widget.user),
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
            indicatorColor: Colors.white,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
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

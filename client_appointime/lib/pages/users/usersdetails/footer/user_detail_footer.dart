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
      new Tab(child: Icon(Icons.alternate_email,color: Colors.black54)),
      new Tab(
          child:  Icon(Icons.vpn_key,color: Colors.black54)
          ),
      new Tab(
        child: Text(
          "Item3",
          style: TextStyle(color: Colors.black38),
        ),
      ),
    ];
    _pages = [
      new DetailsShowcase(widget.user),
      new PrestationsShowcase(widget.user),
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
            indicatorColor: Colors.black54,
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

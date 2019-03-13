import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/DetailsShowCase.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/PrestationsShowCase.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/conditionShowCase.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:flutter/material.dart';

class BusinessShowcase extends StatefulWidget {
  BusinessShowcase(this.business, this.edit,this.user);

  final Business business;
  final bool edit;
  final User user;

  @override
  _BusinessShowcaseState createState() => new _BusinessShowcaseState();
}

class _BusinessShowcaseState extends State<BusinessShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(child: Icon(Icons.description, color: Colors.black54)),
      new Tab(child: Icon(Icons.work, color: Colors.black54)),
      new Tab(child: Icon(Icons.calendar_today, color: Colors.black54)),
    ];
    _pages = [
      new DetailsShowcase(widget.business),
      new PrestationsShowcase(widget.business, widget.edit,widget.user),
      new ConditionsShowcase(widget.business),
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

import 'package:flutter/material.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/Conditions_showcase.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/Details_showcase.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/prestations_showcase.dart';
import 'package:client_appointime/pages/business/business.dart';

class BusinessShowcase extends StatefulWidget {
  BusinessShowcase(this.friend);

  final Business friend;

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
      new Tab(text: 'Détails'),
      new Tab(text: 'Prestations'),
      new Tab(text: 'Conditions'),
    ];
    _pages = [
      new DetailsShowcase(),
      new PrestationsShowcase(),
      new ConditionsShowcase(widget.friend),
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

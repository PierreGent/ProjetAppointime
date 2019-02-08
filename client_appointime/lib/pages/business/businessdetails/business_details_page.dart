import 'package:flutter/material.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/business_detail_footer.dart';
import 'package:client_appointime/pages/business/businessdetails/business_detail_body.dart';
import 'package:client_appointime/pages/business/businessdetails/header/business_detail_header.dart';
import 'package:client_appointime/pages/business/business.dart';
import 'package:meta/meta.dart';

class BusinessDetailsPage extends StatefulWidget {
  BusinessDetailsPage(
    this.friend, {
    @required this.avatarTag,
  });

  final Business friend;
  final Object avatarTag;

  @override
  _BusinessDetailsPageState createState() => new _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new BusinessDetailHeader(
                widget.friend,
                avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new BusinessDetailBody(widget.friend),
              ),
              new BusinessShowcase(widget.friend),
            ],
          ),
        ),
      ),
    );
  }
}

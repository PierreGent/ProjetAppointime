import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/arcbannerImage.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:flutter/material.dart';

class BusinessDetailHeader extends StatelessWidget {
  BusinessDetailHeader(this.business, this.avatarTag, this.activity);

  final Business business;
  final Object avatarTag;
  final Activity activity;

  Widget _buildCategoryChips(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(activity.name),
        labelStyle: textTheme.caption,
        backgroundColor: Colors.black12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var businessInformation = Container(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  business.name,
                  style: textTheme.title,
                ),
                Text(
                  business.address,
                  style: textTheme.subtitle,
                ),
                Text(
                  business.phoneNumber,
                  style: textTheme.subtitle,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //  SizedBox(height: 8.0),
                // RatingInformation(business),
                _buildCategoryChips(textTheme),
                Text(
                  business.boss.firstName + " " + business.boss.lastName,
                  style: textTheme.subtitle,
                ),
                Text(
                  business.boss.email,
                  style: textTheme.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Stack(
      children: [
       Stack(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(bottom: 95.0),
            child:ArcBannerImage(business.bannerUrl),

          ),
    new Align(
    alignment: FractionalOffset.bottomCenter,
    heightFactor: 1.6,
    child:
     Center(
       child: Hero(

         tag: avatarTag,
         child: new CircleAvatar(

           backgroundImage: NetworkImage(business.avatarUrl),

           radius: 50.0,
         )),),)

    ],),

        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            children: [
              SizedBox(width: 16.0),
              Expanded(child: businessInformation),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/arcbannerImage.dart';
import 'package:client_appointime/pages/business/businessdetails/rating_business.dart';
import 'package:flutter/material.dart';

class BusinessDetailHeader extends StatelessWidget {
  BusinessDetailHeader(this.business,this.avatarTag);
  final Business business;
final Object avatarTag;
  Widget _buildCategoryChips(TextTheme textTheme) {
    return  Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          label: Text(business.fieldOfActivity),
          labelStyle: textTheme.caption,
          backgroundColor: Colors.black12,
        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var businessInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          business.name,
          style: textTheme.title,
        ),
        SizedBox(height: 8.0),
        RatingInformation(business),
        SizedBox(height: 12.0),
         _buildCategoryChips(textTheme),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),

          child: Hero(
            tag: avatarTag,
            child: ArcBannerImage("images/mecano.jpg"),),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
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
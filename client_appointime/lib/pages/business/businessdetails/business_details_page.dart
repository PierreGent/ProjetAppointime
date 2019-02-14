import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/business_details_header.dart';
import 'package:flutter/material.dart';

class BusinessDetailsPage extends StatelessWidget {
  BusinessDetailsPage(this.business,this.avatarTag);
  final Business business;
  final Object avatarTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BusinessDetailHeader(business,avatarTag),
            Padding(
              padding: const EdgeInsets.all(20.0),
             // child: Storyline(movie.storyline),
            ),
           /* PhotoScroller(movie.photoUrls),
            SizedBox(height: 20.0),
            ActorScroller(movie.actors),
            SizedBox(height: 50.0),*/
          ],
        ),
      ),
    );
  }
}
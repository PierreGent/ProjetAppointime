import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/business_details_header.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/business_detail_footer.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:flutter/material.dart';

class BusinessDetailsPage extends StatelessWidget {
  BusinessDetailsPage(
      this.business, this.avatarTag, this.sectorActivityList, this.edit);

  final Business business;
  final Object avatarTag;
  final bool edit;
  final List<Activity> sectorActivityList;

  Activity getActivity() {
    Activity activityToReturn;
    sectorActivityList.forEach((activity) {
      if (activity.id == business.fieldOfActivity) activityToReturn = activity;
    });
    return activityToReturn;
  }

  Widget showDetails() {
    if (avatarTag == -1) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              BusinessDetailHeader(business, avatarTag, getActivity()),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: BusinessShowcase(this.business, this.edit),
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
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Details de l'entreprise"),
          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BusinessDetailHeader(business, avatarTag, getActivity()),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: BusinessShowcase(this.business, this.edit),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          showDetails(),
        ],
      ),
    );
  }
}

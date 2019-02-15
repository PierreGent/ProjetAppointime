import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/business_details_header.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:flutter/material.dart';

class BusinessDetailsPage extends StatelessWidget {
  BusinessDetailsPage(this.business,this.avatarTag,this.sectorActivityList);
  final Business business;
  final Object avatarTag;
  final List<Activity> sectorActivityList;
Activity getActivity(){
  Activity activityToReturn;
  sectorActivityList.forEach((activity){
    if(activity.id==business.fieldOfActivity)
      activityToReturn=activity;
  });
  return activityToReturn;
}


  @override
  Widget build(BuildContext context) {
    return Container(

    child:Stack(
        children:<Widget>[


        Scaffold(
            appBar: AppBar(
        title: Text("Details de l'entreprise"),
      backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BusinessDetailHeader(business,avatarTag,getActivity()),
            Padding(
              padding: const EdgeInsets.all(20.0),
             child: Text(this.business.description),
             // child: Storyline(movie.storyline),
            ),
           /* PhotoScroller(movie.photoUrls),
            SizedBox(height: 20.0),
            ActorScroller(movie.actors),
            SizedBox(height: 50.0),*/
          ],
        ),
      ),
    ),],),);
  }
}
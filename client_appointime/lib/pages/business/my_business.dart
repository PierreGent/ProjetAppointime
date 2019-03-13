import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/business_details_page.dart';
import 'package:client_appointime/pages/business/create_business.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyBusiness extends StatefulWidget {
  @override
  MyBusiness({this.auth, this.userId, this.onSignedOut,this.user});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final User user;

  State<StatefulWidget> createState() => new MyBusinessState();
}

class MyBusinessState extends State<MyBusiness> {
  Business business;
  bool isLoading = false;

  Map<String, dynamic> mailPass = new Map<String, dynamic>();
  List<Activity> sectorActivityList;

  void initState() {
    MyBusiness();
    loadJobs();
    super.initState();
  }

  Future MyBusiness() async {
    setState(() {
      isLoading = true;
    });
    FirebaseDatabase.instance
        .reference()
        .child('business')
        .orderByChild("boss")
        .equalTo(widget.userId)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) return;
      values.forEach((k, v) async {
        widget.auth.getCurrentUser().then((result) {
          mailPass['email'] = result.email;
          mailPass['password'] = result.uid;
        });
        getUser(widget.userId).then((DataSnapshot result) {
          Map<dynamic, dynamic> values = result.value;
          FirebaseDatabase.instance
              .reference()
              .child('shedule').orderByChild("businessId").equalTo(k).once()
              .then((DataSnapshot resultShedule) async {
            Map<dynamic, dynamic> valuesShedule = resultShedule.value;
            print(valuesShedule);
            if (this.mounted) {
              setState(() {
                this.business = Business.fromMap(
                    k, v, User.fromMap(mailPass, values, widget.userId),valuesShedule);



              });
            }
          });
        });
      });

    });
    setState(() {
      isLoading = false;
    });
  }

  Future loadJobs() async {
    setState(() {
      isLoading = true;
    });

    sectorActivityList = [];
    await FirebaseDatabase.instance
        .reference()
        .child('activity')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((k, v) async {
        if (this.mounted)
          setState(() {
            sectorActivityList.add(Activity.fromMap(k, v));

          });
      });
      setState(() {
        isLoading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    if (isLoading || this.business == null )
      return new Center(
        child: CircularProgressIndicator(),
      );
    if(this.business!=null)
      return BusinessDetailsPage(
          this.business, -1, this.sectorActivityList, true,widget.user);


    if (this.business == null)
        return new Center(
          child: Container(
            padding: EdgeInsets.all(25),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vous ne possedez pas d'entreprise",
                  style: TextStyle(color: Colors.black54),
                ),
                new ClipRRect(
                  borderRadius: new BorderRadius.circular(30.0),
                  child: new MaterialButton(
                    minWidth: 140.0,
                    color: Color(0xFF3388FF).withOpacity(0.8),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateBusinessPage(auth: widget.auth)))
                          .then((value) {
                        setState(() {
                          MyBusiness();
                        });
                      });
                    },
                    child: new Text('Créer une entreprise'),
                  ),
                ),
              ],
            ),
          ),
        );


  }
}

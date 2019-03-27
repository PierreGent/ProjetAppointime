import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/pages/base_page.dart';
import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/business_list_page.dart';
import 'package:client_appointime/pages/business/favorite.dart';
import 'package:client_appointime/pages/business/my_business.dart';
import 'package:client_appointime/pages/my_appointment.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/user_details_page.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/services/my_icone_icons.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<Home> {
  PageController pageController;
  int page = 0;
  String title = "Accueil";
  bool _isPro = false;
  var items;
  bool isLoading=true;
  bool isLoadingFav=true;
  User user;
  int compteurFav=0;
  int nbFav=1;
  int compteurBus=0;
  int nbBus=1;
  List<Business> _business=[];
  List<Business> _favorite=[];

  List<Activity> sectorActivityList;
  Business business;
  Map<String, dynamic> mailPass = new Map<String, dynamic>();

  initState() {
    loadJobs();
    myBusiness();

    widget.auth.getCurrentUser().then((result) {
      mailPass['email'] = result.email;
      mailPass['password'] = result.uid;
    });
    getUser(widget.userId).then((DataSnapshot result) {
      Map<dynamic, dynamic> values = result.value;
      setState(() {
        user = User.fromMap(mailPass, values, widget.userId);


        _loadBusiness().then((te){_loadFavorite();});
      });
    });
    isPro(widget.userId).then((result) {
      setState(() {
        _isPro = result;
      });
    });

    pageController = new PageController(initialPage: 1);
    setState(() {
      page = 1;
      title = "Accueil";
    });
    super.initState();
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

   loadJobs() async {


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
            if(k!="test")
              sectorActivityList.add(Activity.fromMap(k, v));

          });
      });

    });

  }
   myBusiness() async {

    FirebaseDatabase.instance
        .reference()
        .child('business')
        .orderByChild("boss")
        .equalTo(widget.userId)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null)
        return;
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
            Activity businessActivity;
            for(Activity act in sectorActivityList)
              if (act.id==v["fieldOfActivity"])
                businessActivity=act;
            if (this.mounted) {
              setState(() {
                this.business = Business.fromMap(
                    k, v, User.fromMap(mailPass, values, widget.userId),valuesShedule,businessActivity);



              });
            }
          });
        });
      });
    });




  }



  Future<void> _loadFavorite() async {

if(this.mounted)
  setState(() {
    isLoadingFav=true;
  });
    var getInfosUser = await widget.auth.getCurrentUser();
    await FirebaseDatabase.instance
        .reference()
        .child('favorite')
        .orderByChild("user")
        .equalTo(getInfosUser.uid)
        .once()
        .then((DataSnapshot snapshot) {
      //Pour chaque favoris disponnible en bdd
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        setState(() {
          compteurFav=0;
          nbFav=values.length;
        });

        values.forEach((k, v) async {
          //Si il concerne l'utilisateur connecté on l'ajoute a la liste


          if (this.mounted) {
            setState(() {
              user.favorite.add(Favorite.fromMap(k, v));
              FirebaseDatabase.instance
                  .reference()
                  .child('business')
                  .child(v["business"])
                  .once()
                  .then((DataSnapshot result) async {
                Map<dynamic, dynamic> valuesBusiness = result.value;

                Map<String, dynamic> mailPass = new Map<String, dynamic>();
                widget.auth.getCurrentUser().then((result) {
                  mailPass['email'] = result.email;
                  mailPass['password'] = result.uid;
                });
                FirebaseDatabase.instance
                    .reference()
                    .child('shedule')
                    .orderByChild("businessId")
                    .equalTo(v["business"])
                    .once()
                    .then((DataSnapshot resultShedule) {
                  Map<dynamic, dynamic> valuesShedule = resultShedule.value;
                  print(valuesShedule);

                  getUser(valuesBusiness['boss']).then((DataSnapshot result) {
                    Map<dynamic, dynamic> valuesUser = result.value;
                    Activity businessActivity;
                    for (Activity act in sectorActivityList)
                      if (act.id == valuesBusiness["fieldOfActivity"])
                        businessActivity = act;


                      if(this.mounted)
                        setState(() {
                    _favorite.add(Business.fromMap(
                        v["business"],
                        valuesBusiness,
                        User.fromMap(mailPass, valuesUser, valuesBusiness['boss']),
                        valuesShedule, businessActivity));
                    compteurFav++;

                    print(compteurFav.toString()+"    "+values.length.toString());
                    if(compteurFav==values.length)
                          isLoadingFav=false;
                        });
                  });
                });
              });
            });
          }
        });
      }
      else
      if(this.mounted)
        setState(() {
          isLoadingFav=false;
        });




    });



  }


 Future<void> _loadBusiness() async {
   if (this.mounted) {
     setState(() {
       isLoading = true;
     });
   }
    await FirebaseDatabase.instance
        .reference()
        .child('business')
        .once()
        .then((DataSnapshot snapshot) {

      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) {
        if(this.mounted)
          setState(() {

            print("setstate false load 154");
            isLoading=false;
          });
        return;
      }
   setState(() {
     compteurBus=0;
     nbBus=values.length;
   });

      values.forEach((k, v) async {

        if (this.mounted) {
          setState(() {
            isLoading = true;
          });
        }
            Map<String, dynamic> mailPass = new Map<String, dynamic>();
            widget.auth.getCurrentUser().then((result) {
              mailPass['email'] = result.email;
              mailPass['password'] = result.uid;
            });
            getUser(v['boss']).then((DataSnapshot result) {
              Map<dynamic, dynamic> valuesUser = result.value;

              FirebaseDatabase.instance
                  .reference()
                  .child('shedule')
                  .orderByChild("businessId")
                  .equalTo(k)
                  .once()
                  .then((DataSnapshot resultShedule) async {
                Map<dynamic, dynamic> valuesShedule = resultShedule.value;
                print(valuesShedule);
                Activity businessActivity;
                for (Activity act in sectorActivityList)
                  if (act.id == v["fieldOfActivity"])
                    businessActivity = act;

                if (this.mounted) {
                  setState(() {
                    Business bus = Business.fromMap(
                        k,
                        v,
                        User.fromMap(mailPass, valuesUser, v['boss']),
                        valuesShedule, businessActivity);
                    this._business.add(bus);

                    compteurBus++;
print(compteurBus.toString()+"    "+values.length.toString());
                    if (compteurBus == values.length) {
                      isLoading = false;
                    }
                  });
                }
              });
            });


      });

    });

  }

  Widget build(BuildContext context) {
    var widgetList;
    if (_isPro == null || isLoading|| isLoadingFav) {
      return Scaffold(
       backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Appointime",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white)),
              LinearProgressIndicator(backgroundColor: Colors.blueAccent,valueColor:AlwaysStoppedAnimation<Color>(Colors.white),value: ((((compteurFav)/(nbFav))*10)+(((compteurBus)/(nbBus))*90))/100,),
              Text(((((compteurFav)/(nbFav))*10)+(((compteurBus)/(nbBus))*90)).round().toString()+"%",style: TextStyle(fontSize: 20,color: Colors.white),),
              ],
          ),
        ),
      );
    }
    if (_isPro) {
      items = [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          activeIcon: Icon(MyIcone.calendar),
          title: Text("Mes rendez-vous"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MyIcone.home_outline),
          activeIcon: Icon(MyIcone.home),
          title: Text("Accueil"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_center),
          activeIcon: Icon(Icons.business_center),
          title: Text("Mon entreprise"),
        )
      ];
       widgetList=[
        MyAppointment(user) /*,MyAppointment(),*/,
        BasePage(widget.auth, user,this._business,this._favorite,this.sectorActivityList),
        MyBusiness(
            listJobs: sectorActivityList,
            business:business,
            auth: widget.auth,
            userId: widget.userId,
            onSignedOut: widget.onSignedOut,
            user: user),
  ];
    } else {
     widgetList=[
    MyAppointment(user) /*,MyAppointment(),*/,
    BasePage(widget.auth, user,this._business,this._favorite,this.sectorActivityList),

    ];
      items = [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          activeIcon: Icon(MyIcone.calendar),
          title: Text("Mes rendez-vous"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MyIcone.home_outline),
          activeIcon: Icon(MyIcone.home),
          title: Text("Accueil"),
        ),
      ];
    }
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3388FF).withOpacity(0.8),
        title: Text(title),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: widgetList,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            brightness: Brightness.light,
            primaryColor: const Color(0xFF3388FF).withOpacity(0.8),
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.black45))),
        // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          items: items,
          onTap: navigateToPage,
          currentIndex: page,
        ),
      ),
      drawer: new Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Menu principal",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                GestureDetector(
                  child: Center(
                    child: Hero(
                      tag: "myaccount",
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.2),
                          child: new Center(
                            child: new Icon(
                              MyIcone.torso,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                          radius: 30.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailsPage(
                                user, "myaccount", widget.auth)));
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [0.5, 1],
                colors: <Color>[
                  const Color(0xFF3388FF).withOpacity(0.8),
                  const Color(0xFF3388FF).withOpacity(0.8),
                ],
              ),
            ),
          ),
          /*   ListTile(
            title: Text(
              "Je suis un professionnel",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateBusinessPage(auth: widget.auth)));
            },
          ),*/
          ListTile(
            title: Text(
              "Liste des entreprises",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Liste des entreprises"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        backgroundColor: globalVar.couleurPrimaire,
                        body: BusinessListPage(widget.auth, user, "all",this._business,this._favorite,this.sectorActivityList))),
              );
            },
          ),
          ListTile(
            title: Text(
              "Déconnexion",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              _signOut();
            },
          ),
        ],
      )),
    );
  }

  void navigateToPage(int page) {
    pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    String temptitle = "";
    this.page = page;
    switch (page) {
      case 0:
        temptitle = "Mes rendez-vous";

        break;
      case 1:
        temptitle = "Accueil";
        break;
      /*case 2:
        temptitle = "Liste des entreprises";
        break;*/
      case 2:
        temptitle = "Mon entreprise";
        break;
    }

    setState(() {
      this.page = page;
      this.title = temptitle;
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}

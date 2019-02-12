import 'package:client_appointime/pages/base_page.dart';
import 'package:client_appointime/pages/business/business_list_page.dart';
import 'package:client_appointime/pages/business/create_business.dart';
import 'package:client_appointime/pages/my_appointment.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/pages/users/usersdetails/user_details_page.dart';
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
  User user;
  Map<String, dynamic> mailPass = new Map<String, dynamic>();

  initState() {
    super.initState();
    widget.auth.getCurrentUser().then((result) {
      mailPass['email'] = result.email;
      mailPass['password'] = result.uid;
    });
    getUser(widget.userId).then((DataSnapshot result) {
      print(result.value);
      Map<dynamic, dynamic> values = result.value;
      setState(() {
        user = User.fromMap(mailPass, values);
      });
    });
    isPro(widget.userId).then((result) {
      setState(() {
        _isPro = result;
      });
    });

    pageController = new PageController();
    title = "Accueil";
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget build(BuildContext context) {
    if (_isPro == null) {
      return AppBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        title: Text("loading"),
      );
    }
    if (_isPro) {
      items = [
        BottomNavigationBarItem(
          icon: Icon(MyIcone.home_outline),
          activeIcon: Icon(MyIcone.home),
          title: Text("Accueil"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          activeIcon: Icon(MyIcone.calendar),
          title: Text("Mes rendez-vous"),
        ),
        /* BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          activeIcon: Icon(Icons.playlist_add_check),
          title: Text("Liste des Entreprises"),
        ),*/
        BottomNavigationBarItem(
          icon: Icon(Icons.business_center),
          activeIcon: Icon(Icons.business_center),
          title: Text("Mon entreprise"),
        )
      ];
    } else {
      items = [
        BottomNavigationBarItem(
          icon: Icon(MyIcone.home_outline),
          activeIcon: Icon(MyIcone.home),
          title: Text("Accueil"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          activeIcon: Icon(MyIcone.calendar),
          title: Text("Mes rendez-vous"),
        ),
        /*  BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted),
          activeIcon: Icon(Icons.playlist_add_check),
          title: Text("Liste des Entreprises"),
        )*/
      ];
    }
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        title: Text(title),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          BasePage(widget.auth, user),
          MyAppointment() /*,MyAppointment(),*/,
          BusinessListPage(widget.auth, user,"all")
        ],
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            brightness: Brightness.light,
            primaryColor: Colors.blueAccent.withOpacity(0.8),
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
                            builder: (context) =>
                                UserDetailsPage(user, "myaccount", widget.auth)));
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomLeft,
                stops: [0.6, 1],
                colors: <Color>[
                  const Color(0xFF0000FF),
                  const Color(0xFFFFFFFF),
                ],
              ),
            ),
          ),
          ListTile(
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
          ),
          ListTile(
            title: Text(
              "Liste des entreprises",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                  Scaffold(
                      appBar: AppBar(
                        title: Text("Liste des entreprises"),
                        backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      ),
                      backgroundColor: globalVar.couleurPrimaire,
                      body:BusinessListPage(widget.auth, user,"all"))),);
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
    switch (page) {
      case 0:
        temptitle = "Accueil";
        break;
      case 1:
        temptitle = "Mes rendez-vous";
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

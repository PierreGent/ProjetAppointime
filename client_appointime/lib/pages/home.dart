import 'package:client_appointime/pages/base_page.dart';
import 'package:client_appointime/pages/create_business.dart';
import 'package:client_appointime/pages/my_appointment.dart';
import 'package:client_appointime/pages/my_business.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/services/my_icone_icons.dart';

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

  initState() {
    super.initState();
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
        )
      ];
    }
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        title:  Text(title),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[BasePage(), MyAppointment(), MyBusiness()],
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            brightness: Brightness.light,
            primaryColor: Colors.blueAccent.withOpacity(0.8),
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color: Colors
                        .black45))), // sets the inactive color of the `BottomNavigationBar`
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
            child: Column(
              children: <Widget>[
                Text(
                  "Menu principal",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.8),
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

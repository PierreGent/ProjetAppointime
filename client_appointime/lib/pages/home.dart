import 'package:client_appointime/pages/base_page.dart';
import 'package:client_appointime/pages/my_appointment.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/services/menu.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/services/my_icone_icons.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;


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

  void initState() {
    super.initState();
    pageController = new PageController();
    title = "Accueil";
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MenuBarState(
              widget.auth, widget.onSignedOut, widget.userId, context)
          .getAppBar('Appointime'),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          BasePage(),
          MyAppointment(),
        ],
      ),
      bottomNavigationBar: new Theme(

    data: Theme.of(context).copyWith(
      // sets the background color of the `BottomNavigationBar`
        canvasColor: Colors.lightBlueAccent.withOpacity(0),
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
brightness: Brightness.light,
        primaryColor: Colors.indigo,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.black))), // sets the inactive color of the `BottomNavigationBar`
    child: BottomNavigationBar(

          items: [
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

          ],
          onTap: navigateToPage,
          currentIndex: page,
        ),
      ), );
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
}

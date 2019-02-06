import 'package:client_appointime/pages/base_page.dart';
import 'package:client_appointime/pages/my_appointment.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/services/menu.dart';
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
          .getAppBar('Page d\'accueil'),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          BasePage(),
          MyAppointment(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Accueil"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day),
              title: Text("Mes rendez-vous"),
            ),
          ],
          onTap: navigateToPage,
          currentIndex: page,
        ),
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
}

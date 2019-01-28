import 'package:flutter/material.dart';
import 'globalVar.dart' as globalVar;
import 'package:dots_indicator/dots_indicator.dart';

final PageController pageController = new PageController();

void main() => runApp(App());

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    final title = 'Appointime';
    return MaterialApp(
      title: title,
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: globalVar.couleurPrimaire,
        body: PageView(
          controller: pageController,
          children: <Widget>[
            ConnectPage(),
            InscPage(),
          ],
        ));
  }
}

class ConnectPage extends StatefulWidget {
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage>
    with SingleTickerProviderStateMixin {
  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation;
  AnimationController animationController;

  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: -1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toDouble();
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Transform(
                    transform: Matrix4.translationValues(
                        animation.value * width, 0.0, 0.0),
                    child: new Center(
                      child: Container(
                        padding: EdgeInsets.all(25),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Connexion",
                              style: TextStyle(
                                  color: globalVar.couleurSecondaire,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0.0, 0.0),
                      child: new Center(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(hintText: "Email"),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: new Center(
                      child: Container(
                        padding: EdgeInsets.all(25),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              decoration:
                                  InputDecoration(hintText: "Mot de passe"),
                              obscureText: true,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        0.0, muchMuchDelayedAnimation.value * width, 0.0),
                    child: new Center(
                      child: Container(
                        padding: EdgeInsets.all(25),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              child: Text("Se connecter"),
                              onPressed: () {
                                // !!! CONNEXION !!!
                              },
                              color: globalVar.couleurSecondaire,
                              textColor: globalVar.couleurPrimaire,
                            ),
                            OutlineButton(
                              child: Text("   S'inscrire    "),
                              onPressed: () {
                                pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              color: globalVar.couleurSecondaire,
                              textColor: globalVar.couleurSecondaire,
                              highlightColor: globalVar.couleurSecondaire,
                              borderSide: BorderSide(
                                color: globalVar.couleurSecondaire,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
          );
        });
  }
}

/* ************* INSCRIPTION ************** */

class InscPage extends StatefulWidget {
  InscPageState createState() => InscPageState();
}

class InscPageState extends State<InscPage>
    with SingleTickerProviderStateMixin {
  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation;
  AnimationController animationController;

  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toDouble();
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Transform(
                    transform: Matrix4.translationValues(
                        animation.value * width, 0.0, 0.0),
                    child: new Center(
                      child: Container(
                        padding: EdgeInsets.all(25),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Inscription",
                              style: TextStyle(
                                  color: globalVar.couleurSecondaire,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0.0, 0.0),
                      child: new Center(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(hintText: "Email"),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0.0, 0.0),
                      child: new Center(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                decoration:
                                    InputDecoration(hintText: "Mot de passe"),
                                obscureText: true,
                              )
                            ],
                          ),
                        ),
                      )),
                  Transform(
                    transform: Matrix4.translationValues(
                        0.0, muchMuchDelayedAnimation.value * width, 0.0),
                    child: new Center(
                      child: Container(
                        padding: EdgeInsets.all(25),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              child: Text("   S'inscrire    "),
                              onPressed: () {
                                // !!! CONNEXION !!!
                              },
                              color: globalVar.couleurSecondaire,
                              textColor: globalVar.couleurPrimaire,
                            ),
                            OutlineButton(
                              child: Text("Se connecter"),
                              onPressed: () {
                                pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              color: globalVar.couleurSecondaire,
                              textColor: globalVar.couleurSecondaire,
                              highlightColor: globalVar.couleurSecondaire,
                              borderSide: BorderSide(
                                color: globalVar.couleurSecondaire,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
          );
        });
  }
}

/* Suite Inspiré de https://tphangout.com/flutter-delayed-animations */

/* ************* CONNEXION ************** */
/*

class ConnectPage extends StatefulWidget {
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage>
    with SingleTickerProviderStateMixin {
  PageController pc;
  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation;
  AnimationController animationController;

  void initState() {
    pc = new PageController();
    super.initState();


    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: -1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width.toDouble();
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: Align(
              alignment: Alignment.center,
              child: Container(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Transform(
                        transform: Matrix4.translationValues(
                            animation.value * width, 0.0, 0.0),
                        child: new Center(
                          child: Container(
                            padding: EdgeInsets.all(25),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      ".",
                                      style: TextStyle(
                                        color: globalVar.couleurPrimaire,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 80,
                                        shadows: [
                                          Shadow(
                                              // bottomLeft
                                              offset: Offset(-1.5, -1.5),
                                              color:
                                                  globalVar.couleurSecondaire),
                                          Shadow(
                                              // bottomRight
                                              offset: Offset(1.5, -1.5),
                                              color:
                                                  globalVar.couleurSecondaire),
                                          Shadow(
                                              // topRight
                                              offset: Offset(1.5, 1.5),
                                              color:
                                                  globalVar.couleurSecondaire),
                                          Shadow(
                                              // topLeft
                                              offset: Offset(-1.5, 1.5),
                                              color:
                                                  globalVar.couleurSecondaire),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      ".",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 80,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Connexion",
                                  style: TextStyle(
                                      color: globalVar.couleurSecondaire,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform(
                          transform: Matrix4.translationValues(
                              delayedAnimation.value * width, 0.0, 0.0),
                          child: new Center(
                            child: Container(
                              padding: EdgeInsets.all(25),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: "Email"),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Transform(
                          transform: Matrix4.translationValues(
                              muchDelayedAnimation.value * width, 0.0, 0.0),
                          child: new Center(
                            child: Container(
                              padding: EdgeInsets.all(25),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                        hintText: "Mot de passe"),
                                    obscureText: true,
                                  )
                                ],
                              ),
                            ),
                          )),
                      Transform(
                        transform: Matrix4.translationValues(
                            0.0, muchMuchDelayedAnimation.value * width, 0.0),
                        child: new Center(
                          child: Container(
                            padding: EdgeInsets.all(25),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text("Se connecter"),
                                  onPressed: () {
                                    // !!! CONNEXION !!!
                                  },
                                  color: globalVar.couleurSecondaire,
                                  textColor: globalVar.couleurPrimaire,
                                ),
                                OutlineButton(
                                  child: Text("   S'inscrire    "),
                                  onPressed: () {
                                    pc.animateTo(
                                      1,
                                      curve: Curves.easeOut,
                                      duration: const Duration(milliseconds: 300),
                                    );
                                    },
                                  color: globalVar.couleurSecondaire,
                                  textColor: globalVar.couleurSecondaire,
                                  highlightColor: globalVar.couleurSecondaire,
                                  borderSide: BorderSide(
                                    color: globalVar.couleurSecondaire,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

/* ************* INSCRIPTION ************** */

class InscPage extends StatefulWidget {
  InscPageState createState() => InscPageState();
}

class InscPageState extends State<InscPage>
    with SingleTickerProviderStateMixin {
  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation;
  AnimationController animationController;

  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toDouble();
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: Align(
              alignment: Alignment.center,
              child: Container(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ".",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 80,
                            ),
                          ),
                          Text(
                            ".",
                            style: TextStyle(
                              color: globalVar.couleurPrimaire,
                              fontWeight: FontWeight.bold,
                              fontSize: 80,
                              shadows: [
                                Shadow(
                                  // bottomLeft
                                    offset: Offset(-1.5, -1.5),
                                    color:
                                    globalVar.couleurSecondaire),
                                Shadow(
                                  // bottomRight
                                    offset: Offset(1.5, -1.5),
                                    color:
                                    globalVar.couleurSecondaire),
                                Shadow(
                                  // topRight
                                    offset: Offset(1.5, 1.5),
                                    color:
                                    globalVar.couleurSecondaire),
                                Shadow(
                                  // topLeft
                                    offset: Offset(-1.5, 1.5),
                                    color:
                                    globalVar.couleurSecondaire),
                              ],
                            ),
                          ),

                        ],
                      ),
                      Transform(
                        transform: Matrix4.translationValues(
                            animation.value * width, 0.0, 0.0),
                        child: new Center(
                          child: Container(
                            padding: EdgeInsets.all(25),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Inscription",
                                  style: TextStyle(
                                      color: globalVar.couleurSecondaire,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform(
                          transform: Matrix4.translationValues(
                              delayedAnimation.value * width, 0.0, 0.0),
                          child: new Center(
                            child: Container(
                              padding: EdgeInsets.all(25),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: "Email"),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Transform(
                          transform: Matrix4.translationValues(
                              muchDelayedAnimation.value * width, 0.0, 0.0),
                          child: new Center(
                            child: Container(
                              padding: EdgeInsets.all(25),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                        hintText: "Mot de passe"),
                                    obscureText: true,
                                  )
                                ],
                              ),
                            ),
                          )),
                      Transform(
                        transform: Matrix4.translationValues(
                            0.0, muchMuchDelayedAnimation.value * width, 0.0),
                        child: new Center(
                          child: Container(
                            padding: EdgeInsets.all(25),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text("   S'inscrire    "),
                                  onPressed: () {
                                    // !!! CONNEXION !!!
                                  },
                                  color: globalVar.couleurSecondaire,
                                  textColor: globalVar.couleurPrimaire,
                                ),
                                OutlineButton(
                                  child: Text("Se connecter"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ConnectPage()),
                                    );
                                  },
                                  color: globalVar.couleurSecondaire,
                                  textColor: globalVar.couleurSecondaire,
                                  highlightColor: globalVar.couleurSecondaire,
                                  borderSide: BorderSide(
                                    color: globalVar.couleurSecondaire,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
*/

import 'package:flutter/material.dart';
import 'globalVar.dart' as globalVar;
import 'validation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* ************* INSCRIPTION ************** */

class InscPage extends StatefulWidget {
  InscPageState createState() => InscPageState();
}

class InscPageState extends State<InscPage>
    with SingleTickerProviderStateMixin {
  // ANIMATION

  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation;
  AnimationController animationController;

  // FORM VALIDATION

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool autoValidate = false;
  String email;
  String pass;
  String passConf;
  String errorMessage;

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

  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Form(
            key: formKey,
            autovalidate: autoValidate,
            child: FormUI(),
          );
        });
  }

  Widget FormUI() {
    final width = MediaQuery.of(context).size.width.toDouble();
    return ListView(
      children: <Widget>[
        Transform(
          transform:
              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Inscription",
                    style: TextStyle(
                        color: globalVar.couleurSecondaire,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
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
                  TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      icon: new Icon(Icons.mail,
                          color: globalVar.couleurSecondaire),
                    ),
                    validator: validateEmail,
                    onSaved: (value) => email = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    key: passKey,
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Mot de passe',
                      icon: new Icon(
                        Icons.lock,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validatePass,
                    onSaved: (value) => pass = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Confirmation',
                      icon: new Icon(
                        Icons.beenhere,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: (confirm) {
                      print("ddskffskj");
                      return validatePassConfirm(
                          confirm, passKey.currentState.value);
                    },
                  ),
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
                    child: Text("   S'inscrire    "),
                    onPressed: submit,
                    color: globalVar.couleurSecondaire,
                    textColor: globalVar.couleurPrimaire,
                  ),
                  OutlineButton(
                    child: Text("Se connecter"),
                    onPressed: () {
                      globalVar.pageController.previousPage(
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
  }

  submit() async {
    final form = formKey.currentState;
    setState(() {
      errorMessage = "";
    });
    if (form.validate()) {
      form.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);
        print('Signed in: ${user.uid}');
      } catch (e) {
        print('Error: $e');
        setState(() {
          errorMessage = "Nom de compte ou mot de passe incorrect";
        });
      }
    } else {
      setState(() => autoValidate = true);
    }
  }
}

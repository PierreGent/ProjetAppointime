import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:flutter/material.dart';

/* ************* CONNEXION ************** */

class ConnectPage extends StatefulWidget {
  ConnectPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage>
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
  bool autoValidate = false;
  String email;
  String pass;
  String errorMessage;

  bool _isLoading;

  void initState() {
    super.initState();
    _isLoading = false;
    errorMessage = "";
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: -1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Form(
              key: formKey,
              autovalidate: autoValidate,
              child: Stack(
                children: <Widget>[
                  FormUI(),
                  _showCircularProgress(),
                ],
              ));
        });
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget FormUI() {
    final width = MediaQuery.of(context).size.width.toDouble();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Transform(
            transform:
                Matrix4.translationValues(animation.value * width, 0.0, 0.0),
            child: new Center(
              child: Container(
                padding: EdgeInsets.only(top: 50, bottom: 40),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Connexion",
                      style: TextStyle(
                          color: Color(0xFF3388FF).withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 45),
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
                padding: EdgeInsets.only(left: 25, right: 25),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      autovalidate: autoValidate,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.mail,
                            color: Color(0xFF3388FF).withOpacity(0.8)),
                        labelText: 'Email',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
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
                padding: EdgeInsets.only(top: 35, left: 25, right: 25),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new TextFormField(
                      autovalidate: autoValidate,
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                        prefixIcon: new Icon(
                          Icons.lock,
                          color: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        labelText: 'Mot de passe',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) => value.isEmpty
                          ? 'Le mot de passe ne peut pas être vide'
                          : null,
                      onSaved: (value) => pass = value,
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
                padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new SizedBox(
                        child: RaisedButton(
                          child: Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0)),
                          onPressed: submit,
                          color: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        width: double.infinity,
                        height: 55,
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                      child: new SizedBox(
                        child: OutlineButton(
                          child: Text(
                            'S\'inscrire',
                            style: TextStyle(
                              color: Color(0xFF3388FF).withOpacity(0.8),
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0)),
                          onPressed: () {
                            globalVar.pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          borderSide: BorderSide(
                            color: Color(0xFF3388FF).withOpacity(0.8),
                            style: BorderStyle.solid,
                            width: 2, //width of the border
                          ),
                        ),
                        width: double.infinity,
                        height: 55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _showErrorMessage(),
        ],
      ),
    );
  }

  Widget _showErrorMessage() {
    if (errorMessage.length > 0 && errorMessage != null) {
      return new Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  submit() async {
    final form = formKey.currentState;
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });
    if (form.validate()) {
      form.save();
      String userId = "";
      try {
        userId = await widget.auth.signIn(email, pass);

        print('Signed in: ${userId}');
      } catch (e) {
        print('Error: $e');
        setState(() {
          errorMessage = "Nom de compte ou mot de passe incorrect";
          _isLoading = false;
        });
      }
      if (userId.length > 0 && userId != null) {
        widget.onSignedIn();
      }
    } else {
      setState(() {
        _isLoading = false;
        autoValidate = true;
      });
    }
  }

// RESTE À AFFICHER LES MESSAGE DERREUR QUAND UN USER NE DONNE PAS LES BONS IDENTIFIANTS
}

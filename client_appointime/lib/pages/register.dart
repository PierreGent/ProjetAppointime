import 'package:flutter/material.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/validation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:client_appointime/services/authentication.dart';

/* ************* INSCRIPTION ************** */

class InscPage extends StatefulWidget {
  InscPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  InscPageState createState() => InscPageState();
}

class InscPageState extends State<InscPage>
    with SingleTickerProviderStateMixin {
  // ANIMATION

  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation1,
      muchMuchMuchDelayedAnimation2,
      muchMuchMuchDelayedAnimation3,
      muchMuchMuchDelayedAnimation4;
  AnimationController animationController;

  // FORM VALIDATION

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool autoValidate = false;
  bool isPro = false;
  String email;
  bool started=false;
  bool _isPhoneUsed=false;
  bool _isInAsyncCall=false;
  String pass;
  String passConf;
  String errorMessage;
  String firstName;
  String lastName;
  String phone;
  String address;
  bool _isLoading;

  void initState() {
    super.initState();
    _isLoading = false;
    errorMessage = "";
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation1 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation2 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation3 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation4 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  Widget build(BuildContext context) {
    animationController.forward();
    return ModalProgressHUD(
        child :AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          if(started)
            formKey.currentState?.validate();
          return Form(
              key: this.formKey,
              autovalidate: autoValidate,
              child: Stack(
                children: <Widget>[
                  formUI(),
                  _showCircularProgress(),
                ],
              ));
        }),
    inAsyncCall: _isInAsyncCall,
    // demo of some additional parameters
    opacity: 0.5,
    progressIndicator: CircularProgressIndicator(),
    );

  }


  String validatePhone(String value) {
    if(value.length!=10 && !(value is int)){
      return 'Telephone invalide';
    }

    if (_isPhoneUsed) {
      // disable message until after next async call
      _isPhoneUsed = false;
      return 'Numéro déjâ utilisé';
    }
      return null;
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

  Widget formUI() {
    final width = MediaQuery.of(context).size.width.toDouble();
    return SingleChildScrollView(
      child:Column(

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
                        color: Colors.blueAccent.withOpacity(0.8),
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
                      icon: new Icon(
                          Icons.mail,
                          color: Colors.blueAccent.withOpacity(0.8)
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
                        color: Colors.blueAccent.withOpacity(0.8),
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
                        color: Colors.blueAccent.withOpacity(0.8),
                      ),
                    ),
                    validator: (confirm) {
                      print("ddskffskj");
                      if (passKey.currentState != null)
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
              muchMuchMuchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Prénom',
                      icon: new Icon(
                        Icons.supervised_user_circle,
                        color: Colors.blueAccent.withOpacity(0.8),
                      ),
                    ),
                    validator: validateFirstName,
                    onSaved: (value) => firstName = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation1.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Nom',
                      icon: new Icon(
                        Icons.supervised_user_circle,
                        color: Colors.blueAccent.withOpacity(0.8),
                      ),
                    ),
                    validator: validateLastName,
                    onSaved: (value) => lastName = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation2.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Adresse',
                      icon: new Icon(
                        Icons.add_location,
                        color: Colors.blueAccent.withOpacity(0.8),
                      ),
                    ),
                    validator: validateAddress,
                    onSaved: (value) => address = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation3.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Numéro de téléphone',
                      icon: new Icon(
                        Icons.phone,
                        color: Colors.blueAccent.withOpacity(0.8),
                      ),
                    ),
                    validator: validatePhone,
                    onSaved: (value) => phone = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation4.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CheckboxListTile(
                    title: Text(
                      "Cochez si vous etes professionnel",
                      style: TextStyle(color: Colors.black54
                      ),
                    ),
                    value: isPro,
                    onChanged: (bool value) {
                      setState(() {
                        isPro = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              0.0, muchMuchMuchDelayedAnimation4.value * width, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("   S'inscrire    "),
                    onPressed: submit,
                    color: Colors.blueAccent.withOpacity(0.8),
                    textColor: Colors.white,
                  ),
                  OutlineButton(
                    child: Text("Se connecter"),
                    onPressed: () {
                      globalVar.pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    color: Colors.blueAccent.withOpacity(0.8),
                    textColor: Colors.blueAccent.withOpacity(0.8),
                    highlightColor: Colors.blueAccent.withOpacity(0.8),
                    borderSide: BorderSide(
                      color: Colors.blueAccent.withOpacity(0.8),
                      style: BorderStyle.solid,
                      width: 2,
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
    started=true;
    final form = formKey.currentState;

    setState(() {
      errorMessage = "";
      _isLoading = true;
    });
    String userId = "";
    if (form.validate()) {
      form.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        _isInAsyncCall = true;
      });
      Future.delayed(Duration(seconds: 1), () async {
        _isPhoneUsed=await isPhoneUsed(phone);

        setState(() {
          _isInAsyncCall = false;
        });
        if(!_isPhoneUsed ) {
          try {
            userId = await widget.auth.signUp(email, pass);
            widget.auth
                .signUpFull(userId, firstName, lastName, address, phone, isPro);

            print('Signed in: '+userId);
          } catch (e) {
            print('Error: $e');
            setState(() {
              _isLoading = false;

              errorMessage = "Nom de compte ou mot de passe incorrect";
            });
          }
          _isLoading = false;
          if (userId.length > 0 && userId != null) {
            widget.onSignedIn();
          }
        }
      });
    } else {
      setState(() => autoValidate = true);
    }

    setState(() {
      _isLoading = false;
    });
  }
}

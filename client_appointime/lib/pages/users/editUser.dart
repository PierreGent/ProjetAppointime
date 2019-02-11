import 'package:client_appointime/pages/users/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/validation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:client_appointime/services/authentication.dart';

/* ************* INSCRIPTION ************** */

class EditUser extends StatefulWidget {
  EditUser({this.auth, this.onSignedIn,this.user,this.type});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final String type;
  final User user;
  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends State<EditUser>
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
  final GlobalKey<FormState> formKeyPass = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool autoValidate = false;
  String email;
  bool started=false;
  bool confirm=false;
  bool _isPhoneUsed=false;
  bool _isInAsyncCall=false;
  String oldPassword;
  String newPassword;
  String errorMessage;
  FirebaseUser getInfosUser;
  String phone;
  String address;
  bool _isLoading;
PageController pageController;
  TextEditingController changeMailController;
  void initState() {
    super.initState();
    changeMailController = new TextEditingController(text:widget.user.phoneNumber);
    if(widget.type=="address")
      changeMailController = new TextEditingController(text:widget.user.address);

    pageController = new PageController();
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
if(widget.type=="phone")
  return Container(
          child:  formPhone(context),
      );
if(widget.type=="pass")
  return Container(
    child:  formPassword(context),
  );
return Container(
  child:  formAddress(context),
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








  Widget formAddress(BuildContext context) {
    animationController.forward();
    final width = MediaQuery.of(context).size.width.toDouble();

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
                    SingleChildScrollView(
                      child:Column(

                        children: <Widget>[

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
                                      controller: changeMailController,
                                      autovalidate: autoValidate,
                                      maxLines: 1,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(

                                        icon: new Icon(
                                            Icons.edit_location,
                                            color: Colors.blueAccent.withOpacity(0.8)
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
                                0.0, muchMuchMuchDelayedAnimation4.value * width, 0.0),
                            child: new Center(
                              child: Container(
                                padding: EdgeInsets.all(25),
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new ClipRRect(
                                      borderRadius: new BorderRadius.circular(30.0),
                                      child: new MaterialButton(
                                        minWidth: 140.0,
                                        color: Colors.green.withOpacity(0.8),
                                        textColor: Colors.white,
                                        onPressed: _showDialog,
                                        child: new Text('Confirmer'),
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
                    ),
                    _showCircularProgress(),

                  ],
                ));
          }
      ),
      inAsyncCall: _isInAsyncCall,
      // demo of some additional parameters
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
    );
  }





  Widget formPhone(BuildContext context) {

    animationController.forward();
    final width = MediaQuery.of(context).size.width.toDouble();

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
     SingleChildScrollView(
      child:Column(

        children: <Widget>[

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
                      controller: changeMailController,
                      autovalidate: autoValidate,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(

                        icon: new Icon(
                            Icons.phone,
                            color: Colors.blueAccent.withOpacity(0.8)
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
                0.0, muchMuchMuchDelayedAnimation4.value * width, 0.0),
            child: new Center(
              child: Container(
                padding: EdgeInsets.all(25),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: new BorderRadius.circular(30.0),
                      child: new MaterialButton(
                        minWidth: 140.0,
                        color: Colors.green.withOpacity(0.8),
                        textColor: Colors.white,
                        onPressed: _showDialog,
                        child: new Text('Confirmer'),
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
    ),
     _showCircularProgress(),

                    ],
                ));
            }
            ),
      inAsyncCall: _isInAsyncCall,
      // demo of some additional parameters
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
    );
  }












  Widget formPassword(BuildContext context) {
    animationController.forward();
    final width = MediaQuery.of(context).size.width.toDouble();
    return ModalProgressHUD(
      child :AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            if(started)
              formKeyPass.currentState?.validate();
            return Form(
                key: this.formKeyPass,
                autovalidate: autoValidate,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
      child:Column(

        children: <Widget>[


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
                      autovalidate: autoValidate,
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                        hintText: 'Ancien mot de passe',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.blueAccent.withOpacity(0.8),
                        ),
                      ),
                      validator: validatePass,
                      onSaved: (value) => oldPassword = value,
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
                        hintText: 'Nouveau mot de passe',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.blueAccent.withOpacity(0.8),
                        ),
                      ),
                      validator: validatePass,
                      onSaved: (value) => newPassword = value,
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
                0.0, muchMuchMuchDelayedAnimation4.value * width, 0.0),
            child: new Center(
              child: Container(
                padding: EdgeInsets.all(25),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: new BorderRadius.circular(30.0),
                      child: new MaterialButton(
                        minWidth: 140.0,
                        color: Colors.green.withOpacity(0.8),
                        textColor: Colors.white,
                        onPressed: _showDialog,
                        child: new Text('Confirmer'),
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
    ),
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

  void _showDialog() {
    // flutter defined function
    ontap(){
      if(widget.type=="address")
        return submitAddress();
        if(widget.type=="phone")
          return submitPhone();

          if(widget.type=="pass")
            return submitPass();
    }
    showDialog(
      context: context,

      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Attention"),
          content: new Text("Etes vous sur de vouloir effectuer ces chngements?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Continuer"),
              onPressed: () {
                setState(() {
                  ontap();
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
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

  submitPhone() async {
    started=true;
    final form = formKey.currentState;

    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    if (form.validate()) {

        form.save();
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          _isInAsyncCall = true;
        });
        Future.delayed(Duration(seconds: 1), () async {
          _isPhoneUsed = await isPhoneUsed(phone);

          setState(() {
            _isInAsyncCall = false;
          });
          if (!_isPhoneUsed) {
            try {
              getInfosUser = await widget.auth.getCurrentUser();
              widget.user.phoneNumber = phone;
              FirebaseDatabase.instance.reference().child('users').child(
                  getInfosUser.uid).set({
                'firstName': widget.user.firstName,
                'lastName': widget.user.lastName,
                'address': widget.user.address,
                'phoneNumber': phone,
                'isPro': widget.user.isPro,
                'credit': widget.user.credit
              });
            } catch (e) {
              print('Error: $e');
              setState(() {
                _isLoading = false;

                errorMessage = "Erreur";
              });
            }
            _isLoading = false;
            if (errorMessage.length == 0)
              Navigator.pop(context);
          }
        });

    } else {
      setState(() => autoValidate = true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  submitAddress() async {

    final form = formKey.currentState;

    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    if (form.validate() ) {

      form.save();
      FocusScope.of(context).requestFocus(new FocusNode());

      try {
        getInfosUser = await widget.auth.getCurrentUser();
        widget.user.address = address;
        FirebaseDatabase.instance.reference().child('users').child(
            getInfosUser.uid).set({
          'firstName': widget.user.firstName,
          'lastName': widget.user.lastName,
          'address': address,
          'phoneNumber': widget.user.phoneNumber,
          'isPro': widget.user.isPro,
          'credit': widget.user.credit
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;

          errorMessage = "Erreur";
        });
      }
      _isLoading = false;
      if (errorMessage.length == 0)
        Navigator.pop(context);

    } else {
      setState(() => autoValidate = true);
    }

    setState(() {
      _isLoading = false;
    });
  }


  submitPass() async {
    started=true;
    final form = formKeyPass.currentState;

    setState(() {
      errorMessage = "";
      _isLoading = true;
    });
    if (form.validate()) {
      _showDialog();
      if (confirm) {
        confirm = false;
        form.save();


        try {
          getInfosUser = await widget.auth.getCurrentUser();

          if (await widget.auth.signIn(widget.user.email, oldPassword) != null)
            getInfosUser.updatePassword(newPassword);
        } catch (e) {
          print('Error: $e');
          setState(() {
            errorMessage = "Ancien mot de passe incorrect";
            _isLoading = false;
          });
        }
        _isLoading = false;
        if (errorMessage.length == 0) {
          Navigator.pop(context);
        }
      }
    }


    setState(() {
      _isLoading = false;
    });
  }
}

import 'dart:math';

import 'package:appointime_data_generator/authentication.dart';
import 'package:appointime_data_generator/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointime Data Generator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Data generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool started = false;
  bool isPro = false;

  bool _isInAsyncCall = false;
  bool _isLoading=false;
  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget content=Text("Appuyer sur + pour ajouter un utilisateur et son entreprise si il est pro");
    if(_isLoading)
      setState(() {
        content= CircularProgressIndicator();
      });

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

child: content,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitPeople,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  submitPeople() async {

    bool _isPhoneUsed = false;
    BaseAuth auth=new Auth();
    var rnd=new Random();
    isPro=rnd.nextBool();
    int min = 600000000, max = 799999999;
    int r = min + rnd.nextInt(max - min);
    String firstName=faker.person.firstName();
    String lastName=faker.person.lastName();
    String phone="0"+r.toString();
    String address=faker.address.streetAddress()+" "+faker.address.streetName()+" "+faker.address.countryCode()+" "+faker.address.city();

    String email=faker.internet.email();
    String pass=faker.internet.password(length: 8);
    setState(() {

      _isLoading = true;
    });
    String userId = "";

      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        _isInAsyncCall = true;
      });
      Future.delayed(Duration(milliseconds: 300), () async {
        _isPhoneUsed = await isPhoneUsed(phone);

        setState(() {
          _isInAsyncCall = false;
        });
        if (!_isPhoneUsed) {
          try {
            userId = await auth.signUp(email, pass);
            auth
                .signUpFull(userId, firstName, lastName, address, phone, isPro);

            print('Signed in: ' + userId);
            _showDialogUser("nom: "+lastName+" prenom: "+firstName+" adresse: "+address+" tel: "+phone+" email: "+email);
            if(isPro){
              submitBusiness(auth);
            }
          } catch (e) {
            print('Error: $e');
            setState(() {
              _isLoading = false;

            });
          }
          _isLoading = false;

        }
      });


    setState(() {
      _isLoading = false;
    });
  }


  submitBusiness(BaseAuth auth) async {
    int min = 1, max = 5;

    bool _isSiretUsed = false;
    bool _isPhoneUsed = false;
    var rnd=new Random();
    int r = min + rnd.nextInt(max - min);
    String name=faker.company.name();
    String description="Description de sentreprises crées automatiquement";
    String activity=r.toString();
    int cancelAppointment=r+2;
    rnd=new Random();
     min = 1000000;
     max = 9999999;
    String siret=(min + rnd.nextInt(max - min)).toString()+(min + rnd.nextInt(max - min)).toString();
    String address=faker.address.streetAddress()+" "+faker.address.streetName()+" "+faker.address.countryCode()+" "+faker.address.city();
    rnd=new Random();
    min=600000000;
    max=799999999;
    r = min + rnd.nextInt(max - min);
    String phone="0"+r.toString();

    started = true;
    final businessDetails =
    FirebaseDatabase.instance.reference().child('business');

    String userId = "";

    var user = await auth.getCurrentUser();
    userId = user.uid;


      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        _isLoading = true;
        _isInAsyncCall = true;
      });
      Future.delayed(Duration(seconds: 1), () async {
        _isPhoneUsed = await isPhoneUsed(phone);
        _isSiretUsed = await isSiretUsed(siret);
        print(phone+" "+_isPhoneUsed.toString()+siret+" "+_isSiretUsed.toString());

        setState(() {
          _isInAsyncCall = false;
        });

        if (!_isSiretUsed && !_isPhoneUsed) {
          try {
            var banner = await FirebaseStorage.instance
                .ref()
                .child(activity.toString() + '.jpg')
                .getDownloadURL() as String;
            var avatar = await FirebaseStorage.instance
                .ref()
                .child(activity.toString() + 'Avatar.jpg')
                .getDownloadURL() as String;
            businessDetails.push().set({
              'name': name,
              'boss': userId,
              'address': address,
              'phoneNumber': phone,
              'siret': siret,
              'description': description,
              'fieldOfActivity': activity,
              'cancelAppointment': cancelAppointment,
              'bannerUrl': banner,
              'avatarUrl': avatar
            });
            _showDialogBusiness("nom: "+name+" boss: "+userId+" adresse: "+address+" tel: "+phone+" siret: "+siret+" desscription: "+
            description);

          } catch (e) {
            print('Error: $e');
            setState(() {
              _isLoading = false;
            });
          }
          _isLoading = false;

        }
      });

    setState(() {
      _isLoading = false;
    });
  }


  void _showDialogUser(String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("User created"),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showDialogBusiness(String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Business created"),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:client_appointime/pages/create_business.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';

import 'package:path/path.dart';


class MenuBarState  {

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final BuildContext context;
  Choice _selectedChoice = choices[0]; // The app's "state".
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

MenuBarState(this.auth,this.onSignedOut,this.userId,this.context);








  _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }



   _select(Choice choice) async {
    // Causes the app to rebuild with the new _selectedChoice.
if (choice==choices[5])
     _signOut();
if (choice==choices[4]) {
  return await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateBusinessPage(auth: auth)),
  );
}
  }


  getAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.blueAccent.withOpacity(0.8),
      title:  Text(title),
      actions: <Widget>[
        // overflow menu
        PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context) {
            return choices.skip(2).map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        ),
      ],
    );
  }




}
class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}


const List<Choice> choices = const <Choice>[
  const Choice(title: 'Accueil', icon: Icons.home),
  const Choice(title: 'Mes rdv', icon: Icons.directions_bike),
  const Choice(title: 'machin', icon: Icons.directions_boat),
  const Choice(title: 'truc', icon: Icons.directions_bus),
  const Choice(title: 'Renseigner mon entreprise', icon: Icons.business_center),
  const Choice(title: 'Déconnexion', icon: Icons.exit_to_app),
];





/* @override
  Widget build(BuildContext context) {
    String userId="";
     widget.auth.getCurrentUser().then((user) {
       setState(() {
         if (user != null) {
           userId = user?.uid;
         }
       });
     });
    return new Scaffold(




      /*
        appBar: new AppBar(
          title: new Text('Flutter login demo'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: Center(
          child:
            new StreamBuilder<Event>(

              stream: FirebaseDatabase.instance
                  .reference()
                  .child('users')
                  .child(widget.userId)
                  .onValue,
              builder:
                  (BuildContext context, AsyncSnapshot<Event> event) {
                if (!event.hasData)
                  return new Center(child: new Text('Loading...'));
                Map<dynamic, dynamic> data = event.data.snapshot.value;
                return Column(children: [
                  new Text(widget.userId+"  Bonjour "+ '${data['firstName']}'+"  "+'${data['lastName']}', style: new TextStyle(fontSize: 30.0)),

                ]);
              },
            ),
    ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )

   */ );

  }
  */
import 'package:flutter/material.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:client_appointime/pages/home_page.dart';

import 'dart:async';


class MenuBarState  {

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  Choice _selectedChoice = choices[0]; // The app's "state".
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

MenuBarState(this.auth,this.onSignedOut,this.userId);








  _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }



  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
if (choice==choices[5])
     _signOut();
  }


  getAppBar(String title) {
    return AppBar(
      title: const Text('Basic AppBar'),
      actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(choices[0].icon),
          onPressed: () {
            return new HomePage(
              userId: userId,
              auth: auth,
              onSignedOut: onSignedOut,
            );;
          },
        ),
        // action button
        IconButton(
          icon: Icon(choices[5].icon),
          onPressed: () {
            _signOut();
          },
        ),
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
  const Choice(title: 'bidule', icon: Icons.directions_railway),
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
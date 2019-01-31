import 'package:flutter/material.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  @override
  void initState() {
    super.initState();

    /*_todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
    .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);
  */}

  @override
  void dispose() {
    super.dispose();
  }


  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }




  @override
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

    );

  }
}

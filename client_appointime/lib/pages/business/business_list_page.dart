import 'dart:async';

import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/business_details_page.dart';
import 'package:client_appointime/pages/business/favorite.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/activity.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BusinessListPage extends StatefulWidget {
  BusinessListPage(this.auth, this.user, this.type);

  final User user;
  final BaseAuth auth;
  final String type;

  @override
  _BusinessListPageState createState() => new _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  bool _isLoading = false;
  List<Activity> sectorActivityList;
  List<Business> _business = [];
  FirebaseUser getInfosUser;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    loadJobs();
    _loadFavorite();
    if (widget.type == "all") _loadBusiness();
  }

  Future loadJobs() async {
    sectorActivityList = [];
    await FirebaseDatabase.instance
        .reference()
        .child('activity')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((k, v) async {
        setState(() {
          sectorActivityList.add(Activity.fromMap(k, v));
        });
      });
    });
  }

//Chargement des entreprises
  Future<void> _loadBusiness() async {
    _business = [];
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await FirebaseDatabase.instance
        .reference()
        .child('business')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) return;
      values.forEach((k, v) async {
        Map<String, dynamic> mailPass = new Map<String, dynamic>();
        widget.auth.getCurrentUser().then((result) {
          mailPass['email'] = result.email;
          mailPass['password'] = result.uid;
        });
        getUser(v['boss']).then((DataSnapshot result) {
          Map<dynamic, dynamic> values = result.value;
          if (widget.type == "all") {
            if (this.mounted) {
              setState(() {
                this._business.add(Business.fromMap(k, v,User.fromMap(mailPass, values, v['boss'])));
              });
            }
          } else {
            widget.user.favorite.forEach((f) {
              if (f.businessId == k) {
                if (this.mounted) {
                  setState(() {
                    this._business.add(Business.fromMap(k, v,User.fromMap(mailPass, values, v['boss'])));
                  });
                }
              }
            });
          }

        });

      });
    });
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

//Chargement d'une entreprise par id
  Future<Business> loadBusiness(String id) async {
    Business business;
    FirebaseDatabase.instance
        .reference()
        .child('business')
        .child(id)
        .once()
        .then((DataSnapshot result) async {
      Map<dynamic, dynamic> valuesBusiness = result.value;

      Map<String, dynamic> mailPass = new Map<String, dynamic>();
      widget.auth.getCurrentUser().then((result) {
        mailPass['email'] = result.email;
        mailPass['password'] = result.uid;
      });
      getUser(valuesBusiness['boss']).then((DataSnapshot result) {
        Map<dynamic, dynamic> values = result.value;
      if (this.mounted) {
        setState(() {
          business = Business.fromMap(id, values,User.fromMap(mailPass, values, valuesBusiness['boss']));
        });
      }});

    });
    return business;
  }

  //Chargement des favoris propres a l'utilisateur connecté
  Future<void> _loadFavorite() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    widget.user.favorite = [];
    getInfosUser = await widget.auth.getCurrentUser();
    await FirebaseDatabase.instance
        .reference()
        .child('favorite')
        .once()
        .then((DataSnapshot snapshot) {
      //Pour chaque favoris disponnible en bdd
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null)
        values.forEach((k, v) async {
          //Si il concerne l'utilisateur connecté on l'ajoute a la liste
          if (v["user"] == getInfosUser.uid) if (this.mounted) {
            setState(() {
              widget.user.favorite.add(Favorite.fromMap(k, v));
            });
          }
        });
    });
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (widget.type == "favorite") if (this.mounted) {
      setState(() {
        _loadBusiness();
      });
    }
  }

//Action au clique sur une etoile de favoris
  _toggleFavorite(Business business) async {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 1), () async {
      bool toDelete = false;
      Favorite favToDelete;
      getInfosUser = await widget.auth.getCurrentUser();
      widget.user.favorite.forEach((favorite) {
        if (favorite.businessId == business.id) {
          //On supprime l'entreprise si on la trouve, sinon c'est qu'on veut l'ajouter
          toDelete = true;
          FirebaseDatabase.instance
              .reference()
              .child('favorite')
              .child(favorite.id)
              .remove();
          //On sauvegarde le favoris a enlever (pour l'enlever de la liste locale)
          favToDelete = favorite;
        }
      });
//Si on a pas trouvé de favoris a supprimer c'est quon veut l'ajouter
      if (!toDelete) {
        //Ajout dans la bdd
        await FirebaseDatabase.instance
            .reference()
            .child('favorite')
            .push()
            .set({
          'user': getInfosUser.uid,
          'business': business.id,
        });
        setState(() {
          //On réinitialise a liste locale des favoris
          _loadFavorite();
        });
      } else {
        setState(() {
          //On supprime de la liste locale
          widget.user.favorite.remove(favToDelete);
        });
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _buildBusinessListTile(BuildContext context, int index) {
    Business business = _business[index];
    bool isFavorite = false;
    Map<String, dynamic> mailPass = new Map<String, dynamic>();
    User user;

    //On verifie si l'entreprise est favorite, si oui isFavorite passe a true
    widget.user.favorite.forEach((favorite) {
      if (favorite.businessId == business.id) isFavorite = true;
    });
    widget.auth.getCurrentUser().then((result) {
      mailPass['email'] = result.email;
      mailPass['password'] = result.uid;
    });
    getUser(business.boss.id).then((DataSnapshot result) {
      Map<dynamic, dynamic> values = result.value;
      setState(() {
        user = User.fromMap(mailPass, values, business.boss.id);
      });
    });

    return Stack(
      children: <Widget>[
        ListTile(
          onTap: () => _navigateToBusinessDetails(business, index),
          leading: new Hero(
            tag: index,
            child: new CircleAvatar(
              backgroundImage: NetworkImage(business.avatarUrl),
            ),
          ),
          title: new Text(business.name),
          subtitle: new Text(business.address),
          trailing: Container(
            padding: EdgeInsets.all(10),
            child: IconButton(
              icon: (isFavorite ? Icon(Icons.star) : Icon(Icons.star_border)),
              color: Colors.red[500],
              onPressed: () => _toggleFavorite(business),
            ),
          ),
        ),
      ],
    );
  }

  _navigateToBusinessDetails(Business business, Object avatarTag) {
    bool edit = false;
    if (business.boss == widget.user.id) edit = true;


    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new BusinessDetailsPage(
              business, avatarTag, sectorActivityList, edit);
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return new Center(
        child: CircularProgressIndicator(),
      );
    Widget content;
    if (_business.length < 1 && widget.type == "favorite") {
      return new Center(
        child: Container(
          padding: EdgeInsets.all(25),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Vous ne possedez pas de favoris"),
              new ClipRRect(
                borderRadius: new BorderRadius.circular(30.0),
                child: new MaterialButton(
                  minWidth: 140.0,
                  color: Colors.green.withOpacity(0.8),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text("Liste des entreprises"),
                                backgroundColor:
                                    Color(0xFF3388FF).withOpacity(0.8),
                              ),
                              body: BusinessListPage(
                                  widget.auth, widget.user, "all"))),
                    ).then((value) {
                      setState(() {
                        _loadFavorite();
                      });
                    });
                  },
                  child: new Text('Voir la liste des entreprises'),
                ),
              ),
            ],
          ),
        ),
      );
    }
    content = new ListView.builder(
      itemCount: _business.length,
      itemBuilder: _buildBusinessListTile,
    );

    return Container(
        child: Stack(
      children: <Widget>[
        content,
        _showCircularProgress(),
      ],
    ));
  }
}

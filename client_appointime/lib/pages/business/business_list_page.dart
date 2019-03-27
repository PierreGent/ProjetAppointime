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
  BusinessListPage(this.auth, this.user, this.type, this.businessList,
      this.favoriteList, this.jobList);

  final User user;
  final BaseAuth auth;
  final String type;
  final List<Activity> jobList;
  final List<Business> businessList;
  List<Business> favoriteList;

  @override
  _BusinessListPageState createState() => new _BusinessListPageState();
}

class _BusinessListPageState extends State<BusinessListPage> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Widget content = new Container();
  List names = new List(); // names we get from API
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Colors.grey,
  );
  Widget _appBarTitle = new Text(
    'Rechercher une entreprise',
    style: TextStyle(color: Colors.grey),
  );
  bool _isLoading = false;
  List<Activity> sectorActivityList;
  List<Business> _business = [];
  List<Business> _allBusiness = [];
  List<Business> _oldBusiness = [];
  FirebaseUser getInfosUser;
  _BusinessListPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  @override
  void initState() {
    _loadBusiness();
    for (Business bus in _business) names.add(bus);
    _allBusiness = widget.businessList;
    sectorActivityList = widget.jobList;
    if (widget.type == "all")
      _business = widget.businessList;
    else
      _business = widget.favoriteList;
    print("\n\n\n" + widget.favoriteList.toString());
    _loadFavorite();

    super.initState();
  }

  Widget _buildList() {
    filteredNames = names;
    if (!(_searchText.isEmpty)) {
      List<Business> searchListBusiness = new List();
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['activity']
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            filteredNames[i]['address']
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            filteredNames[i]['name']
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            filteredNames[i]['description']
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
          for (Business thebusiness in _allBusiness)
            if (filteredNames[i]['id'] == thebusiness.id)
              searchListBusiness.add(thebusiness);
        }
      }
      setState(() {
        _oldBusiness = _business;
        _business = searchListBusiness;
        filteredNames = tempList;
      });
    }
    return content;
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: GestureDetector(child: _appBarTitle, onTap: _searchPressed),
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Future loadJobs() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    sectorActivityList = [];
    await FirebaseDatabase.instance
        .reference()
        .child('activity')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((k, v) async {
        if (this.mounted)
          setState(() {
            if (k != "test") sectorActivityList.add(Activity.fromMap(k, v));
          });
      });
    });
  }

//Chargement des entreprises
  Future<void> _loadBusiness() async {
    List tempList = new List();
    List<String> fav = [];
    for (Favorite _fav in widget.user.favorite) fav.add(_fav.businessId);

    List<String> bus = [];
    for (Business _bus in _business) bus.add(_bus.id);

    await FirebaseDatabase.instance
        .reference()
        .child('business')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) {
        if (this.mounted)
          setState(() {
            print("setstate false load 154");
            _isLoading = false;
          });
        return;
      }
      values.forEach((k, v) async {
        if (this.mounted)
          setState(() {
            v['id'] = k;
            for (Activity act in sectorActivityList)
              if (act.id == v["fieldOfActivity"]) v["activity"] = act.name;
            tempList.add(v);
            names = tempList;
            names.shuffle();
            filteredNames = names;
          });
      });
    });
  }

//Chargement d'une entreprise par id
  Future<Business> loadBusiness(String id) async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
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
      FirebaseDatabase.instance
          .reference()
          .child('shedule')
          .orderByChild("businessId")
          .equalTo(id)
          .once()
          .then((DataSnapshot resultShedule) {
        Map<dynamic, dynamic> valuesShedule = resultShedule.value;
        print(valuesShedule);

        getUser(valuesBusiness['boss']).then((DataSnapshot result) {
          Map<dynamic, dynamic> values = result.value;
          Activity businessActivity;
          for (Activity act in sectorActivityList)
            if (act.id == valuesBusiness["fieldOfActivity"])
              businessActivity = act;
          business = Business.fromMap(
              id,
              valuesBusiness,
              User.fromMap(mailPass, values, valuesBusiness['boss']),
              valuesShedule,
              businessActivity);
          if (this.mounted) {
            setState(() {
              print("setstate false load 281");
              _isLoading = false;
            });
          }
        });
      });
    });

    return business;
  }

  //Chargement des favoris propres a l'utilisateur connecté
  Future<void> _loadFavorite() async {
    List<String> favList = [];
    List<String> favListBus = [];
    List<String> busList = [];
    List<Business> toRemove = [];
    for (Favorite _fav in widget.user.favorite) {
      favList.add(_fav.id);
      favListBus.add(_fav.businessId);
    }
    for (Business _bus in _business) {
      busList.add(_bus.id);
      if (!favListBus.contains(_bus.id) && widget.type != "all")
        toRemove.add(_bus);
    }
    for (Business _bus in toRemove) _business.remove(_bus);

    getInfosUser = await widget.auth.getCurrentUser();
    await FirebaseDatabase.instance
        .reference()
        .child('favorite')
        .orderByChild("user")
        .equalTo(getInfosUser.uid)
        .once()
        .then((DataSnapshot snapshot) {
      //Pour chaque favoris disponnible en bdd
      Map<dynamic, dynamic> values = snapshot.value;

      if (values != null)
        values.forEach((k, v) async {
          /*  if (this.mounted) {
            setState(() {
              _isLoading = true;
            });
          }*/
          //Si il concerne l'utilisateur connecté on l'ajoute a la liste
          if (!favList.contains(k))
            setState(() {
              widget.user.favorite.add(Favorite.fromMap(k, v));
              favList.add(k);
              favListBus.add(v["business"]);
            });
          if (!busList.contains(v["business"])) if (this.mounted) {
            setState(() {
              FirebaseDatabase.instance
                  .reference()
                  .child('business')
                  .child(v["business"])
                  .once()
                  .then((DataSnapshot result) async {
                Map<dynamic, dynamic> valuesBusiness = result.value;

                Map<String, dynamic> mailPass = new Map<String, dynamic>();
                widget.auth.getCurrentUser().then((result) {
                  mailPass['email'] = result.email;
                  mailPass['password'] = result.uid;
                });
                FirebaseDatabase.instance
                    .reference()
                    .child('shedule')
                    .orderByChild("businessId")
                    .equalTo(v["business"])
                    .once()
                    .then((DataSnapshot resultShedule) {
                  Map<dynamic, dynamic> valuesShedule = resultShedule.value;
                  print(valuesShedule);

                  getUser(valuesBusiness['boss']).then((DataSnapshot result) {
                    Map<dynamic, dynamic> values = result.value;
                    Activity businessActivity;
                    for (Activity act in sectorActivityList)
                      if (act.id == valuesBusiness["fieldOfActivity"])
                        businessActivity = act;

                    busList.add(k);

                    _business.add(Business.fromMap(
                        v["business"],
                        valuesBusiness,
                        User.fromMap(mailPass, values, valuesBusiness['boss']),
                        valuesShedule,
                        businessActivity));
                  });
                });
              });
            });
          }
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
    });
  }

//Action au clique sur une etoile de favoris
  _toggleFavorite(Business business) async {
    setState(() {
      _isLoading = true;
    });

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
      var request;
      //Ajout dans la bdd
      request = FirebaseDatabase.instance.reference().child('favorite').push();
      Favorite favori = new Favorite(
          id: request.key, userId: getInfosUser.uid, businessId: business.id);
      setState(() {
        widget.user.favorite.add(favori);
      });
      request.set({
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
  }

  Widget _buildBusinessListTile(BuildContext context, int index) {
    if (index >= _business.length)
      return new Center(
        child: CircularProgressIndicator(),
      );
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
      if (this.mounted)
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
              backgroundImage: business.fieldOfActivity.avatar,
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
              business, avatarTag, sectorActivityList, edit, widget.user);
        },
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      _isLoading = true;
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(
          Icons.close,
          color: Colors.grey,
        );

        this._appBarTitle = new TextField(
          autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(

              // prefixIcon: new Icon(Icons.search),
              hintText: 'Tapez ici...'),
        );
      } else {
        if (widget.type == "all")
          setState(() {
            _business = widget.businessList;
          });
        else
          _loadFavorite();

        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.grey,
        );
        this._appBarTitle = new Text(
          'Rechercher une entreprise',
          style: TextStyle(color: Colors.grey),
        );
        filteredNames = names;
        _filter.clear();
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return new Center(
        child: CircularProgressIndicator(),
      );

    if (_business.length > 0 || this._searchIcon.icon != Icons.search) {
      setState(() {
        content = new ListView.builder(
          itemCount: _business.length,
          itemBuilder: _buildBusinessListTile,
        );
      });

      return Scaffold(
        appBar: _buildBar(context),
        body: new Container(
          child: Stack(
            children: <Widget>[
              _buildList(),
            ],
          ),
        ),
        resizeToAvoidBottomPadding: false,
      );
    }
    return new Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Vous ne possedez pas de favoris",
              style: TextStyle(color: Colors.black54),
            ),
            new ClipRRect(
              borderRadius: new BorderRadius.circular(30.0),
              child: new MaterialButton(
                minWidth: 140.0,
                color: Color(0xFF3388FF).withOpacity(0.8),
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
                                widget.auth,
                                widget.user,
                                "all",
                                widget.businessList,
                                widget.favoriteList,
                                widget.jobList))),
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
}

import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/user_detail_footer.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class UserDetailBody extends StatefulWidget {
  UserDetailBody(this.user, this.edit, this.auth);

  final User user;
  final bool edit;
  final BaseAuth auth;

  @override
  UserDetailBodyState createState() {
    return new UserDetailBodyState();
  }
}

class UserDetailBodyState extends State<UserDetailBody> {
  String ispro = "Particulier";

  Widget _buildLocationInfo(TextTheme textTheme) {
    double c_width = MediaQuery.of(context).size.width*0.75;
    return new Column(
      children: <Widget>[

        new Row(
          children: <Widget>[

            new Icon(
              Icons.phone_in_talk,
              color: Colors.grey,
              size: 30.0,
            ),
            new Container (
              width: c_width,
              child: new Column(
              children: <Widget>[


                new Text(
                  widget.user.phoneNumber,
                  style: textTheme.subhead
                      .copyWith(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),),
          ],),

    new Row(
    children: <Widget>[
              new Icon(
                Icons.place,
                color: Colors.grey,
                size: 30.0,
              ),


     new Container (
    padding: const EdgeInsets.all(15.0),
    width: c_width,
    child:new Column(
    children: <Widget>[
              new Text(

                widget.user.address,
                style: textTheme.subhead
                    .copyWith(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
],),
     )
],),


      ],
    );
  }

  Widget showName(TextTheme textTheme) {
    return new Text(
      widget.user.firstName + " " + widget.user.lastName,
      style: textTheme.headline.copyWith(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    if (widget.edit)
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          showName(textTheme),
          new Container(
            child: new UserShowcase(widget.user, widget.auth),
          ),
        ],
      );
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        showName(textTheme),
        new Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Container(
          height: 0,
          color: Colors.blueGrey,
          margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 50),
        ),
      ],
    );
  }
}

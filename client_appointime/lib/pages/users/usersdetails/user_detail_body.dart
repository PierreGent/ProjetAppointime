import 'package:client_appointime/pages/editAccount.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/pages/users/usersdetails/footer/user_detail_footer.dart';
import 'package:flutter/material.dart';

class UserDetailBody extends StatefulWidget {
  UserDetailBody(this.user,this.edit);
  final User user;
  final bool edit;

  @override
  UserDetailBodyState createState() {
    return new UserDetailBodyState();
  }
}

class UserDetailBodyState extends State<UserDetailBody> {
String ispro="Particulier";

  Widget _buildLocationInfo(TextTheme textTheme) {

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: <Widget>[
    new Container(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.grey,
          size: 20.0,
        ),
        new Text(
          widget.user.address,
          style: textTheme.subhead.copyWith(color: Colors.grey,fontSize: 20),

        ),
      ],
    ),
    ),


    new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Icon(
            Icons.phone_in_talk,
            color: Colors.grey,
            size: 20.0,
          ),
          new Text(

            widget.user.phoneNumber,
            textAlign: TextAlign.right,
            style: textTheme.subhead.copyWith(color: Colors.grey,fontSize: 20),
          ),

        ],
      ),
    ),







      ],
    );

  }


Widget showName(TextTheme textTheme){
    if(widget.edit)
      return new Icon(Icons.mode_edit);
    return new Text(
      widget.user.firstName+" "+widget.user.lastName,
      style: textTheme.headline.copyWith(color: Colors.grey),
    );
}
  @override
  Widget build(BuildContext context) {


    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    if(widget.edit)
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          showName(textTheme),
    new Container(

    child: new UserShowcase(widget.user),
    ),

        ],
      );
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        showName(textTheme),
        new Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child:_buildLocationInfo(textTheme),
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

import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/calendar/day_view.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/my_icone_icons.dart';
import 'package:flutter/material.dart';

class ConditionsShowcase extends StatefulWidget {
  ConditionsShowcase(this.business, this.user);

  final User user;
  final Business business;


  ConditionsShowcaseState createState() => ConditionsShowcaseState();
}

  class ConditionsShowcaseState extends State<ConditionsShowcase> {
     DateTime date = DateTime.now();
String _value;
     Future _selectDate() async {
       DateTime picked = await showDatePicker(
           context: context,
           initialDate: new DateTime.now(),
           firstDate: new DateTime(2018),
           lastDate: new DateTime(2021),
           locale: const Locale('fr','FR')

       );
       if(picked != null) setState(() {
         _value = picked.toString();
         Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) => DayView(widget.business,picked,null,widget.user)),
         );
       });
     }

     Widget build(BuildContext context) {
    return IconButton(icon: Icon(MyIcone.calendar_circled,size: 80,color: Colors.blueAccent,),onPressed: ()=>_selectDate(),);



  }
}

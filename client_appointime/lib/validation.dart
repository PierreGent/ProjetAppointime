
import 'package:firebase_database/firebase_database.dart';
// VALIDATION DE L'EMAIL

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Email non valide';
  else
    return null;
}

//VALIDATION DU MOT DE PASSE (INSCRIPTION)

String validatePass(String value){
  if(value.isEmpty || value == null){
    return 'Le mot de passe ne peut pas être vide';
  }
  if(value.length < 6){
    return "Mot de passe trop court";
  }
  return null;
}
//VALIDATION DU PRENOM (INSCRIPTION)
String validateFirstName(String value){
  if(value.isEmpty || value == null){
    return 'Le prénom ne peut pas être vide';
  }

  return null;
}
//VALIDATION DU NOM (INSCRIPTION)
String validateLastName(String value){
  if(value.isEmpty || value == null){
    return 'Le Nom ne peut pas être vide';
  }

  return null;
}
//VALIDATION DE LA DURéE D'ANNULATION (INSCRIPTION ENTREPRISE)
String validateCancelAppointment(String value){
  if(value.isEmpty || value == null){
    return 'Ce champ ne peut pas être vide';
  }
  if(num.tryParse(value)==null){
    return 'Ce champ doit etre un nombre';
  }

  return null;
}

//Validation du numéro siret


Future<bool> isSiretUsed(String value) async {
  final businessDetails = FirebaseDatabase.instance.reference().child('business');
  DataSnapshot datas = await businessDetails.orderByChild("siret").equalTo(value).once();
  print(datas.value);
  if(datas.value!=null)
    return true;
  return false;
}
Future<bool> isPhoneUsed(String value) async {

  DataSnapshot datas = await  FirebaseDatabase.instance.reference().child('users').orderByChild("phoneNumber").equalTo(value).once();
  print(datas.value);
  if(datas.value!=null)
    return true;
   datas = await  FirebaseDatabase.instance.reference().child('business').orderByChild("phoneNumber").equalTo(value).once();
  if(datas.value!=null)
    return true;
  return false;
}
Future<bool> isPro(String value) async {
  final businessDetails = FirebaseDatabase.instance.reference().child('users').child(value);
  DataSnapshot datas = await businessDetails.once();

  if(datas.value["isPro"])
    return true;
  return false;
}


Future<String> validateBusiness(String userId) async{
  final businessDetails = FirebaseDatabase.instance.reference().child('business');
  DataSnapshot datas = await businessDetails.orderByChild("boss").equalTo(userId).once();
  if(datas.value!=null)
    return "Vous avez déjâ une entreprise";
  return null;
}



Future<DataSnapshot> getUser(String userId) async{
  final userDetails = FirebaseDatabase.instance.reference().child('users').child(userId);
  DataSnapshot datas = await userDetails.once();
  if(datas.value!=null)
    return datas;
  return null;
}
String validateDesc(String value){
  if(value.isEmpty || value == null){
    return 'La description ne peut pas être vide';
  }
  if(value.length < 6){
    return 'La description doit faire plus de 10 caracteres';
  }

  return null;
}

//VALIDATION DUE LADRESSE (INSCRIPTION)
String validateAddress(String value){
  if(value.isEmpty || value == null){
    return 'Le Nom ne peut pas être vide';
  }

  return null;
}
//VALIDATION DU MOT DE PASSE DE CONFIRMATION (INSCRIPTION)

String validatePassConfirm(String value1,String value2){
  if(!(value1 == value2)){
    return "Mot de passe différents";
  }
  return null;
}



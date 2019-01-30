

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
  if(value.length < 5){
    return "Mot de passe trop court";
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


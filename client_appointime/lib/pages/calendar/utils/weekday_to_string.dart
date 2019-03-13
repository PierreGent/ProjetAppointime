String weekdayToString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "Lundi";
    case DateTime.tuesday:
      return "Mardi";
    case DateTime.wednesday:
      return "Mercredi";
    case DateTime.thursday:
      return "Jeudi";
    case DateTime.friday:
      return "Vendredi";
    case DateTime.saturday:
      return "Samedi";
    case DateTime.sunday:
      return "Dimanche";
    default:
      return "Error";
  }
}

String weekdayToAbbreviatedString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "Lun";
    case DateTime.tuesday:
      return "Mar";
    case DateTime.wednesday:
      return "Mer";
    case DateTime.thursday:
      return "Jeu";
    case DateTime.friday:
      return "Ven";
    case DateTime.saturday:
      return "Sam";
    case DateTime.sunday:
      return "Dim";
    default:
      return "Err";
  }
}

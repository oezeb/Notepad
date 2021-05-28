class Date {
  static getString(DateTime date) {
    String ans = "Edited   ";
    DateTime now = DateTime.now();
    //this year
    if (now.year == date.year) {
      //Today
      if (now.month * 10 + now.day == date.month * 10 + date.day) {
        ans += (date.hour % 12).toString() + " : " + date.minute.toString();
        ans += (date.hour <= 12) ? " AM" : " PM";
      } else {
        ans += intToMonth(date.month) + " " + date.day.toString();
      }
    } else {
      ans += date.year.toString() +
          "/" +
          date.month.toString() +
          "/" +
          date.day.toString();
    }
    return ans;
  }

  static intToMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "";
  }
}

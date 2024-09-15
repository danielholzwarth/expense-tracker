import 'package:intl/intl.dart';

String convertDateTimeToString(DateTime dateTime) {
  return DateFormat("yyyymmdd").format(dateTime);
}

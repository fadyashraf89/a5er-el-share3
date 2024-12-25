import 'package:intl/intl.dart';

class FormattedDate{
  Future<String> FormatDate(String dateString) async {
    final formatter = DateFormat('yyyy-MM-dd');
    final date = formatter.parse(dateString);
    final formattedDate = DateFormat.yMMMMd().format(date);
    return formattedDate;
  }
}
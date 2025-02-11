import 'package:intl/intl.dart';

class FormattedDate {

  // Format a DateTime string into "January 15, 2025"
  Future<String> formatToReadable(String isoDate) async {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat.yMMMMd().format(date);
    } catch (e) {
      throw FormatException('Invalid ISO date format: $isoDate');
    }
  }
  Future<String> formatToReadableDate(dynamic dateInput) async {
    try {
      DateTime date;
      if (dateInput is String) {
        date = parseToCorrectFormat(dateInput);  // Parse ISO 8601 string
      } else if (dateInput is DateTime) {
        date = dateInput;
      } else {
        throw const FormatException('Invalid date type');
      }
      return DateFormat.yMMMMd().format(date); // "January 15, 2025"
    } catch (e) {
      throw FormatException('Error formatting date: $e');
    }
  }

  dynamic parseToCorrectFormat(String dateString) {
    DateFormat format = DateFormat("MMMM d, yyyy");
    try {
      return format.parse(dateString);
    } catch (e) {
      throw FormatException("Error parsing date: $dateString, $e");
    }
  }

  // Parse "January 15, 2025" back to DateTime
  DateTime parseReadableDate(String formattedDate) {
    try {
      return DateFormat.yMMMMd().parse(formattedDate);
    } catch (e) {
      throw FormatException('Invalid readable date format: $formattedDate');
    }
  }

  // Format DateTime to ISO 8601 String
  String formatToISO(DateTime date) {
    return date.toIso8601String();
  }

  // Parse ISO 8601 String to DateTime
  DateTime parseISODate(String isoDate) {
    try {
      return DateTime.parse(isoDate);
    } catch (e) {
      throw FormatException('Invalid ISO date format: $isoDate');
    }
  }
}
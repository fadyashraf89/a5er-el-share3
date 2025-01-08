import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';

class Cards {
  final Passenger? passenger;
  final String? CardNumber, ExpiryDate, CVV;

  Cards({required this.passenger, required this.CardNumber, required this.ExpiryDate, required this.CVV});
  factory Cards.fromMap(Map<String, dynamic> data) {
    return Cards(
      passenger: data['passenger'] != null
          ? Passenger.fromMap(data['passenger'] as Map<String, dynamic>)
          : null,
      CardNumber: data['CardNumber'] as String?,
      CVV: data['CVV'] as String,
      ExpiryDate: data['ExpiryDate'] as String?,
    );
  }

  // Method to convert a Card object to a Map
  Map<String, dynamic> toMap() {
    return {
      'passenger': passenger?.toMap(),
      'CardNumber': CardNumber.toString(),
      'CVV': CVV.toString(),
      'ExpiryDate': ExpiryDate.toString()
    };
  }

}
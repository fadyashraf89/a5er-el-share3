import 'package:a5er_elshare3/features/Passenger/domain/models/Passenger.dart';
import 'package:a5er_elshare3/features/Payment/data/Entities/CardEntity.dart';

class Cards extends CardsEntity {
  final Passenger? passenger;

  Cards({
    required this.passenger,
    required super.CardNumber,
    required super.ExpiryDate,
    required super.CVV,
  });

  factory Cards.fromMap(Map<String, dynamic> data) {
    return Cards(
      passenger: data['passenger'] != null
          ? Passenger.fromMap(data['passenger'] as Map<String, dynamic>)
          : null,
      CardNumber: data['CardNumber'] ?? '',
      ExpiryDate: data['ExpiryDate'] ?? '',
      CVV: data['CVV'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'passenger': passenger?.toMap(),
      'CardNumber': CardNumber,
      'CVV': CVV,
      'ExpiryDate': ExpiryDate,
    };
  }
}

import '../../../Passenger/domain/models/Passenger.dart';
import '../Cards.dart';

abstract class CardRepository {
  Future<void> addCard(Cards card, Passenger passenger);
}
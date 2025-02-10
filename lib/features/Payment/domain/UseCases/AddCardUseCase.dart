import 'package:a5er_elshare3/features/Payment/domain/Repositories/CardRepository.dart';

import '../../../Passenger/domain/models/Passenger.dart';
import '../Cards.dart';

class AddCardUseCase {
  CardRepository cardrepository;
  AddCardUseCase(this.cardrepository);
  Future<void> addCard(Cards card, Passenger passenger) async {
    return await cardrepository.addCard(card, passenger);
  }
}
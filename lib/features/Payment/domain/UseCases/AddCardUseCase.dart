import 'package:a5er_elshare3/features/Payment/domain/Repositories/PaymentRepository.dart';

import '../../../Passenger/domain/models/Passenger.dart';
import '../Cards.dart';

class AddCardUseCase {
  PaymentRepository paymentrepository;
  AddCardUseCase(this.paymentrepository);
  Future<void> addCard(Cards card, Passenger passenger) async {
    return await paymentrepository.addCard(card, passenger);
  }
}
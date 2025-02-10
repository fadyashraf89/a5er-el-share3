import '../../../../dependency_injection.dart';
import '../../../Passenger/domain/models/Passenger.dart';
import '../../domain/Cards.dart';
import '../../domain/UseCases/AddCardUseCase.dart';

class CardStorage {
  Future<void> addCard(Cards card, Passenger passenger) async {
    AddCardUseCase addCardUseCase = sl<AddCardUseCase>();
    addCardUseCase.addCard(card, passenger);
  }
}
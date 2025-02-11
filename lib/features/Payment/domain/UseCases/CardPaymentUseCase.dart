import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';
import 'package:a5er_elshare3/features/Payment/domain/Repositories/PaymentRepository.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';

class CardPaymentUseCase {
  final PaymentRepository repository;

  CardPaymentUseCase(this.repository);

  dynamic CardPayment(PassengerEntity passenger, Trip trip){
    return repository.CardPayment(passenger, trip);
  }

}
import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';
import 'package:a5er_elshare3/features/Payment/domain/Repositories/PaymentRepository.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';

class CashPaymentUseCase {
  final PaymentRepository repository;

  CashPaymentUseCase(this.repository);

  dynamic CashPayment(PassengerEntity passenger, Trip trip){
    return repository.CashPayment(passenger, trip);
  }

}
import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';
import 'package:a5er_elshare3/features/Payment/domain/Repositories/PaymentRepository.dart';
import 'package:a5er_elshare3/features/Trip/domain/models/trip.dart';

class PointsPaymentUseCase {
  final PaymentRepository repository;

  PointsPaymentUseCase(this.repository);

  dynamic PointsPayment(PassengerEntity passenger, Trip trip){
    return repository.PointsPayment(passenger, trip);
  }
}
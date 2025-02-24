import 'package:a5er_elshare3/features/Trip/domain/Repositories/TripRepository.dart';


class fetchAcceptedTripsForUserUseCase {
  final TripRepository repository;

  fetchAcceptedTripsForUserUseCase(this.repository);

  // Future<List<Trip>> fetchAcceptedTripsForUser(String userMail) async {
  //   return await repository.fetchAcceptedTripsForUser(userMail);
  // }
}
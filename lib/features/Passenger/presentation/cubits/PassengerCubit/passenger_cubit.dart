import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/Database/FirebasePassengerStorage.dart';
import '../../../domain/models/Passenger.dart';

part 'passenger_state.dart';

class PassengerCubit extends Cubit<PassengerState> {
  final FirebasePassengerStorage _passengerStorage;

  PassengerCubit(this._passengerStorage) : super(PassengerInitial());

  // Fetch Passenger data
  Future<void> fetchPassengerData() async {
    try {
      emit(PassengerLoading());
      final passenger = await _passengerStorage.fetchPassengerData();
      emit(PassengerLoaded(passenger: passenger));
    } catch (e) {
      emit(PassengerError(message: e.toString()));
    }
  }

  // Update Passenger data
  Future<void> updatePassengerData(Passenger passenger) async {
    try {
      emit(PassengerUpdating());

      // Convert passenger object to a Map to pass it to the storage layer
      final updatedData = passenger.toMap();

      // Update the data in Firestore
      await _passengerStorage.updatePassengerData(updatedData);

      // Emit the updated state with the new data
      emit(PassengerUpdated(passenger: passenger));
    } catch (e) {
      emit(PassengerError(message: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/Database/FirebasePassengerStorage.dart';
import '../../../domain/models/Passenger.dart';

part 'passenger_state.dart';

class PassengerCubit extends Cubit<PassengerState> {
  final FirebasePassengerStorage _passengerStorage;

  PassengerCubit(this._passengerStorage) : super(PassengerInitial());

  Future<void> fetchPassengerData() async {
    try {
      emit(PassengerLoading());
      final passenger = await _passengerStorage.fetchPassengerData();
      emit(PassengerLoaded(passenger: passenger));
    } catch (e) {
      emit(PassengerError(message: e.toString()));
    }
  }

  Future<void> updatePassengerData(Passenger passenger) async {
    try {
      emit(PassengerUpdating());
      final updatedData = passenger.toMap();

      await _passengerStorage.updatePassengerData(updatedData);
      emit(PassengerUpdated(passenger: passenger));
    } catch (e) {
      emit(PassengerError(message: e.toString()));
    }
  }
}

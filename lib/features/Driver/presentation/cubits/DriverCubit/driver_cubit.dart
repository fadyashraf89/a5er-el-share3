import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/database/FirebaseDriverStorage.dart';
import '../../../domain/models/driver.dart';

part 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final FirebaseDriverStorage _driverStorage;

  DriverCubit(this._driverStorage) : super(DriverInitial());

  // Fetch Driver data
  Future<void> fetchDriverData() async {
    try {
      emit(DriverLoading());
      final driver = await _driverStorage.fetchDriverData();
      emit(DriverLoaded(driver: driver));
    } catch (e) {
      emit(DriverError(message: e.toString()));
    }
  }

  // Update Driver data
  Future<void> updateDriverData(Driver driver) async {
    try {
      emit(DriverUpdating());

      // Convert passenger object to a Map to pass it to the storage layer
      final updatedData = driver.toMap();

      // Update the data in Firestore
      await _driverStorage.updateDriverData(updatedData);

      // Emit the updated state with the new data
      emit(DriverUpdated(driver: driver));
    } catch (e) {
      emit(DriverError(message: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/database/FirebaseDriverStorage.dart';
import '../../../domain/models/driver.dart';

part 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final FirebaseDriverStorage _driverStorage;

  DriverCubit(this._driverStorage) : super(DriverInitial());

  Future<void> fetchDriverData() async {
    try {
      emit(DriverLoading());
      final driver = await _driverStorage.fetchDriverData();
      emit(DriverLoaded(driver: driver));
    } catch (e) {
      emit(DriverError(message: e.toString()));
    }
  }

  Future<void> updateDriverData(Driver driver) async {
    try {
      emit(DriverUpdating());
      final updatedData = driver.toMap();
      await _driverStorage.updateDriverData(updatedData);
      emit(DriverUpdated(driver: driver));
    } catch (e) {
      emit(DriverError(message: e.toString()));
    }
  }
}

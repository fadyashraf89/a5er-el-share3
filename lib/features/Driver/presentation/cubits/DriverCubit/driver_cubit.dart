import 'package:a5er_elshare3/core/utils/Injections/dependency_injection.dart';
import 'package:a5er_elshare3/features/Driver/domain/UseCases/FetchDriverDataUseCase.dart';
import 'package:a5er_elshare3/features/Driver/domain/UseCases/UpdateDriverDataUseCase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/models/driver.dart';

part 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {

  DriverCubit() : super(DriverInitial());

  Future<void> fetchDriverData() async {
    try {
      emit(DriverLoading());
      FetchDriverDataUseCase fetchDriverDataUseCase = sl<FetchDriverDataUseCase>();
      final driver = await fetchDriverDataUseCase.fetchDriverData();
      emit(DriverLoaded(driver: driver));
    } catch (e) {
      emit(DriverError(message: e.toString()));
    }
  }

  Future<void> updateDriverData(Driver driver) async {
    try {
      emit(DriverUpdating());
      final updatedData = driver.toMap();
      UpdateDriverDataUseCase driverDataUseCase = sl<UpdateDriverDataUseCase>();
      await driverDataUseCase.updateDriverData(updatedData);
      emit(DriverUpdated(driver: driver));
    } catch (e) {
      emit(DriverError(message: e.toString()));
    }
  }
}

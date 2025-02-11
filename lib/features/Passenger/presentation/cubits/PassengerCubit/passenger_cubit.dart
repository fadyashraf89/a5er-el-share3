import 'package:a5er_elshare3/core/utils/Injections/dependency_injection.dart';
import 'package:a5er_elshare3/features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import 'package:a5er_elshare3/features/Passenger/domain/UseCases/UpdatePassengerDataUseCase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../domain/models/Passenger.dart';

part 'passenger_state.dart';

class PassengerCubit extends Cubit<PassengerState> {

  PassengerCubit() : super(PassengerInitial());

  Future<void> fetchPassengerData() async {
    FetchPassengerDataUseCase fetchPassengerDataUseCase = sl<FetchPassengerDataUseCase>();
    try {
      emit(PassengerLoading());
      final passenger = await fetchPassengerDataUseCase.fetchPassengerData();
      emit(PassengerLoaded(passenger: passenger));
    } catch (e) {
      emit(PassengerError(message: e.toString()));
    }
  }

  Future<void> updatePassengerData(Passenger passenger) async {
    UpdatePassengerDataUseCase updatePassengerDataUseCase = sl<UpdatePassengerDataUseCase>();
    try {
      emit(PassengerUpdating());
      final updatedData = passenger.toMap();

      await updatePassengerDataUseCase.updatePassengerData(updatedData);
      emit(PassengerUpdated(passenger: passenger));
    } catch (e) {
      emit(PassengerError(message: e.toString()));
    }
  }
}

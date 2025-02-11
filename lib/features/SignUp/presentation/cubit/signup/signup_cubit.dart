import 'package:a5er_elshare3/features/Passenger/domain/UseCases/AddPassengerUseCase.dart';
import 'package:a5er_elshare3/features/SignUp/Domain/UseCases/registerWithEmailAndPasswordUseCase.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../../dependency_injection.dart';
import '../../../../Driver/data/database/FirebaseDriverStorage.dart';
import '../../../../Driver/domain/models/driver.dart';
import '../../../../Passenger/domain/models/Passenger.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign-Up
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
    required String mobileNumber,
    required String name,
    String? licenseNumber,
    String? carPlateNumber,
    String? carModel,
  }) async {
    registerWithEmailAndPasswordUseCase register = sl<registerWithEmailAndPasswordUseCase>();
    emit(SignupLoading());
    try {
      String message = await register.registerWithEmailAndPassword(email, password);
      if (message.contains('successful')) {
        if (role == 'Passenger') {
          Passenger passenger = Passenger(
            email: email,
            mobileNumber: mobileNumber,
            uid: _auth.currentUser!.uid,
            name: name,
            role: "Passenger",
            points: 0
          );
          AddPassengerUseCase addPassengerUseCase = sl<AddPassengerUseCase>();
          addPassengerUseCase.addPassenger(passenger);
        } else if (role == 'Driver') {
          Driver driver = Driver(
            email: email,
            mobileNumber: mobileNumber,
            uid: _auth.currentUser!.uid,
            licenseNumber: licenseNumber ?? '',
            carPlateNumber: carPlateNumber ?? '',
            carModel: carModel ?? '',
            name: name,
            role: "Driver",
          );
          FirebaseDriverStorage().addDriver(driver);
        }
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(message: message));
      }
    } catch (e) {
      emit(SignupFailure(message: "Sign-up failed: $e"));
    }
  }
}

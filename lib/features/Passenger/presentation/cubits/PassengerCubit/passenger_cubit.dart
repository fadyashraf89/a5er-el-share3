import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'passenger_state.dart';

class PassengerCubit extends Cubit<PassengerState> {
  PassengerCubit() : super(PassengerInitial());
}

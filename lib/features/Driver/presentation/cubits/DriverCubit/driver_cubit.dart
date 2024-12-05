import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());
}

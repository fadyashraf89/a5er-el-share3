import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripInitial());
}

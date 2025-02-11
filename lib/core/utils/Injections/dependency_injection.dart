import 'package:a5er_elshare3/core/utils/Injections/DriverInjections.dart';
import 'package:a5er_elshare3/core/utils/Injections/LoginInjections.dart';
import 'package:a5er_elshare3/core/utils/Injections/PassengerInjections.dart';
import 'package:a5er_elshare3/core/utils/Injections/PaymentInjections.dart';
import 'package:a5er_elshare3/core/utils/Injections/TripInjections.dart';
import 'package:a5er_elshare3/core/utils/Injections/UserAuthInjections.dart';
import 'package:get_it/get_it.dart';
import 'SignUpInjections.dart';
final sl = GetIt.instance;
void setupLocator() {
  UserAuthInjection().UserAuthInjections(sl);
  LoginInjection().LoginInjections(sl);
  SignUpInjection().SignUpInjections(sl);
  PassengerInjection().PassengerInjections(sl);
  PaymentInjection().PaymentInjections(sl);
  DriverInjection().DriverInjections(sl);
  TripInjection().TripInjections(sl);
}





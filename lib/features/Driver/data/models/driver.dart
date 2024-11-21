
import '../../../Passenger/data/models/Passenger.dart';

class Driver extends Passenger {
  final String? carPlateNumber, licenseNumber;

  Driver({
    String? email,
    String? password,
    String? mobileNumber,
    String? role,
    String? uid,
    this.carPlateNumber,
    this.licenseNumber,
  }) : super(
          email: email,
          password: password,
          mobileNumber: mobileNumber,
          role: role,
          uid: uid,
        );
}

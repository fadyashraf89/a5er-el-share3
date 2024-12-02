
import '../../../Passenger/data/models/Passenger.dart';

class Driver extends Passenger {
  final String? carPlateNumber, licenseNumber;
  factory Driver.fromMap(Map<String, dynamic> data) {
    return Driver(
        name: data['name'] as String?,
        email: data['email'] as String?,
        mobileNumber: data['mobileNumber'] as String?,
        role: data['role'] as String?,
        carPlateNumber: ['carPlateNumber'] as String? ,
        licenseNumber: ['licenseNumber'] as String?,
    );
  }
  Driver({
    String? email,
    String? password,
    String? mobileNumber,
    String? role,
    String? uid,
    String? name,
    this.carPlateNumber,
    this.licenseNumber,
  }) : super(
          email: email,
          password: password,
          mobileNumber: mobileNumber,
          role: role,
          uid: uid,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
      'carPlateNumber': carPlateNumber,
      'licenseNumber': licenseNumber,
    };
  }
}

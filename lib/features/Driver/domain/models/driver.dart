

import '../../../../core/domain/Models/User.dart';

class Driver extends MyUser {
  final String? carPlateNumber, licenseNumber, carModel;
  Driver({
    email, password, mobileNumber, role, uid, name,
    this.carPlateNumber,
    this.licenseNumber,
    this.carModel
  }) : super(
    name: name,
    email: email,
    password: password,
    mobileNumber: mobileNumber,
    role: role,
    uid: uid,
  );

  factory Driver.fromMap(Map<String, dynamic> data) {
    return Driver(
        name: data['name'] as String?,
        email: data['email'] as String?,
        mobileNumber: data['mobileNumber'] as String?,
        role: data['role'] as String?,
        carPlateNumber: data['carPlateNumber'] as String?,
        licenseNumber: data['licenseNumber'] as String?,
        carModel: data['carModel'] as String?
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
      'carPlateNumber': carPlateNumber,
      'licenseNumber': licenseNumber,
      'carModel': carModel
    };
  }
}

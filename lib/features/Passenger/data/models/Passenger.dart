import '../../../../core/data/Models/User.dart';

class Passenger extends MyUser {

  Passenger({email, password, mobileNumber, role, uid, name}) : super(
    name: name,
    email: email,
    password: password,
    mobileNumber: mobileNumber,
    role: role,
    uid: uid,
  );

  factory Passenger.fromMap(Map<String, dynamic> data) {
    return Passenger(
      name: data['name'] as String?,
      email: data['email'] as String?,
      mobileNumber: data['mobileNumber'] as String?,
      role: data['role'] as String?
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
    };
  }
}

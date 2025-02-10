import 'package:a5er_elshare3/features/Passenger/data/Entities/PassengerEntity.dart';


class Passenger extends PassengerEntity{

  Passenger({
    super.points = 0,
    super.email = "",
    super.password = "",
    super.mobileNumber = "",
    super.role = "",
    super.uid = "",
    super.name = "",
  });

  factory Passenger.fromMap(Map<String, dynamic> data) {
    return Passenger(
      points: data['points'] as int?,
      name: data['name'] as String?,
      email: data['email'] as String?,
      mobileNumber: data['mobileNumber'] as String?,
      role: data['role'] as String?,
      uid: data['uid'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'role': role,
      'points': points,
      'uid': uid,
    };
  }
}

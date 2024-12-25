
import '../../../../core/domain/Models/User.dart';

class Passenger extends MyUser {
  final int? points;
  Passenger({this.points, email, password, mobileNumber, role, uid, name}) : super(
    name: name,
    email: email,
    password: password,
    mobileNumber: mobileNumber,
    role: role,
    uid: uid,
  );

  factory Passenger.fromMap(Map<String, dynamic> data) {
    return Passenger(
      points: data['points'] ,
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
      'points': points
    };
  }
}

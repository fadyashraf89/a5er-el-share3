import '../../../../core/domain/Models/User.dart';

class Passenger extends MyUser {
  late final int? points;

  // Constructor with default values for optional properties
  Passenger({
    this.points = 0, // defaulting points to 0 if not provided
    super.email = "",
    super.password = "",
    super.mobileNumber = "",
    super.role = "",
    super.uid = "",
    super.name = "",
  });

  // Factory constructor to create a Passenger object from a Map
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

  // Method to convert a Passenger object to a Map
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

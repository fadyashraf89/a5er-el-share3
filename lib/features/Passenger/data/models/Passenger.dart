class Passenger {
  final String? email, password, mobileNumber, role, uid, name;

  Passenger(
      {this.name,this.email, this.password, this.mobileNumber, this.role, this.uid});

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

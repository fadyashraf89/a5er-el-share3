abstract class PassengerEntity {
  final String? email, password, mobileNumber, role, uid, name;
  late final int? points;

  PassengerEntity(
      {this.name,this.email, this.password, this.mobileNumber, this.role, this.uid, this.points});
}
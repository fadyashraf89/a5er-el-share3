import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../AuthService/data/Database/FirebaseAuthentication.dart';
import '../../domain/models/driver.dart';

abstract class DriverStorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthService authentication = AuthService();

  Future<void> addDriver(Driver driver);

  Future<Driver> fetchDriverData();

  Future<void> updateDriverData(Map<String, dynamic> updatedData);

}

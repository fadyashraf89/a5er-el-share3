import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/driver.dart';

abstract class DriverStorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addDriver(Driver driver);

  Future<Driver> fetchDriverData();

  Future<void> updateDriverData(Map<String, dynamic> updatedData);

}

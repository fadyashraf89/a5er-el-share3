
import 'package:a5er_elshare3/features/Driver/data/Entities/DriverEntity.dart';

import '../models/driver.dart';

abstract class DriverRepository {
  Future<void> addDriver(DriverEntity driver);

  Future<Driver> fetchDriverData();

  Future<void> updateDriverData(Map<String, dynamic> updatedData);
}
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserAuthRepository {
  Future SignOut();
  Future<String> forgotPassword(String emailAddress);
  Future<String?> fetchUserRole(String userId);
  Future<User?> getCurrentUser();
  Future<String?> getCurrentUserUid();
  Future<String?> getCurrentUserEmail();
}
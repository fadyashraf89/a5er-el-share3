import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class getCurrentUserUseCase {
  final UserAuthRepository authRepository;
  getCurrentUserUseCase(this.authRepository);
  Future<User?> getCurrentUser() async {
    return await authRepository.getCurrentUser();
  }
}
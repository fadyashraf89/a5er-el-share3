import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';

class getCurrentUserEmailUseCase {
  final UserAuthRepository authRepository;
  getCurrentUserEmailUseCase(this.authRepository);
  Future<String?> getCurrentUserEmail() async {
    return await authRepository.getCurrentUserEmail();
  }
}
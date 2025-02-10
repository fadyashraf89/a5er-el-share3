import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';

class forgotPasswordUseCase {
  final UserAuthRepository authRepository;
  forgotPasswordUseCase(this.authRepository);
  Future<String> forgotPassword(String emailAddress) async {
    return await authRepository.forgotPassword(emailAddress);
  }
}
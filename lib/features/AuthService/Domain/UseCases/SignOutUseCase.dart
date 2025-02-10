import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';

class SignOutUseCase {
  final UserAuthRepository authRepository;
  SignOutUseCase(this.authRepository);
  Future SignOut() async {
    return await authRepository.SignOut();
  }
}
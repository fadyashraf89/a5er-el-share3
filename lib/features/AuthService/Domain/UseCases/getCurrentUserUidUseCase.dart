import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';

class getCurrentUserUidUseCase {
  final UserAuthRepository authRepository;
  getCurrentUserUidUseCase(this.authRepository);
  Future<String?> getCurrentUserUid() async {
    return await authRepository.getCurrentUserUid();
  }
}
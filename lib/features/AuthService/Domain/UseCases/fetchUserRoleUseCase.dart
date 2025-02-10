import 'package:a5er_elshare3/features/AuthService/Domain/Repositories/UserAuthRepository.dart';

class fetchUserRoleUseCase {
  final UserAuthRepository authRepository;
  fetchUserRoleUseCase(this.authRepository);
  Future<String?> fetchUserRole(String userid) async {
    return await authRepository.fetchUserRole(userid);
  }
}
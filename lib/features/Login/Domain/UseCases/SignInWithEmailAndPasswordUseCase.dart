import 'package:a5er_elshare3/features/Login/Domain/Repositories/LoginRepository.dart';

class SignInWithEmailAndPasswordUseCase {
  final LoginRepository loginRepository;
  SignInWithEmailAndPasswordUseCase(this.loginRepository);
  Future<String> SignInWithEmailAndPassword(String emailAddress, String password) async {
    return await loginRepository.SignInWithEmailAndPassword(emailAddress, password);

  }
}
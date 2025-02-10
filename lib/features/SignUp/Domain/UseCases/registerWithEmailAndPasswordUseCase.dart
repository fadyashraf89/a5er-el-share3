import 'package:a5er_elshare3/features/SignUp/Data/Repositories/SignUpRepository.dart';

class registerWithEmailAndPasswordUseCase {
  final SignUpRepository signUpRepository;
  registerWithEmailAndPasswordUseCase(this.signUpRepository);
  Future<String> registerWithEmailAndPassword(String emailAddress, String password) async{
    return await signUpRepository.registerWithEmailAndPassword(emailAddress, password);
  }
}
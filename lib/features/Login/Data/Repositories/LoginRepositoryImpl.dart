import 'package:a5er_elshare3/features/Login/Domain/Repositories/LoginRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepositoryImpl implements LoginRepository{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<String> SignInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Sign-in successful!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return 'Sign-in failed. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

}
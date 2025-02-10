import 'package:a5er_elshare3/features/SignUp/Data/Repositories/SignUpRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpRepositoryImpl implements SignUpRepository{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<String> registerWithEmailAndPassword(String emailAddress, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: emailAddress, password: password);
      return 'Registration successful!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return 'Registration failed. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }
}
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../AuthService/data/Database/FirebaseAuthentication.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authentication = AuthService();

  Future<String> _signInWithEmailAndPassword(String email, String password) async {
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

  // Sign-In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      String message = await _signInWithEmailAndPassword(email, password);
      if (message.contains('successful')) {
        String? uid = _auth.currentUser?.uid;
        if (uid != null) {
          // Fetch user role and emit success
          String? role = await authentication.fetchUserRole(uid);
          emit(LoginSuccess(role: role));
        } else {
          emit(LoginFailure(message: "Failed to get user UID"));
        }
      } else {
        emit(LoginFailure(message: message));
      }
    } catch (e) {
      emit(LoginFailure(message: "Sign-in failed: $e"));
    }
  }

}

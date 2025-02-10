import 'package:a5er_elshare3/features/AuthService/Domain/UseCases/fetchUserRoleUseCase.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../../dependency_injection.dart';
import '../../../../AuthService/data/Database/FirebaseAuthentication.dart';
import '../../../Domain/UseCases/SignInWithEmailAndPasswordUseCase.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authentication = AuthService();

  // Sign-In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase = sl<SignInWithEmailAndPasswordUseCase>();
    fetchUserRoleUseCase userRoleUseCase = sl<fetchUserRoleUseCase>();
    emit(LoginLoading());
    try {
      String message = await signInWithEmailAndPasswordUseCase.SignInWithEmailAndPassword(email, password);
      if (message.contains('successful')) {
        String? uid = _auth.currentUser?.uid;
        if (uid != null) {
          // Fetch user role and emit success
          String? role = await userRoleUseCase.fetchUserRole(uid);
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

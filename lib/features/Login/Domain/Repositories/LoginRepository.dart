abstract class LoginRepository {
  Future<String> SignInWithEmailAndPassword(String emailAddress, String password);
}
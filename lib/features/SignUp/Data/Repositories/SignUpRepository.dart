abstract class SignUpRepository {
  Future<String> registerWithEmailAndPassword(String emailAddress, String password);
}
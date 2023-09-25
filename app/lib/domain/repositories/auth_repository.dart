import '../failures/http_request_failure.dart';
import '../failures/sign_in_failure.dart';
import '../failures/sign_up_failure.dart';
import '../models/user.dart';
import '../typedefs.dart';

abstract class AuthRepository {
  Future<User?> get currentUser;
  FutureEither<SignInFailure, User> signIn(String email, String password);
  FutureEither<SignUpFailure, User> signInWithGoogle();
  FutureEither<SignUpFailure, User> signUp(User user, String password);
  FutureEither<HttpRequestFailure, void> sendResetPasswordEmail(String email);
  FutureEither<HttpRequestFailure, String> signInWithCLI({
    required String apiKey,
    required String oobCode,
    required String email,
  });
  Future<void> signOut();
}

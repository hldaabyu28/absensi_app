// features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
}

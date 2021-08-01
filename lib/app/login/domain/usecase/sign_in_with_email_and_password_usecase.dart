import 'package:desafio_mobile/app/login/domain/repository/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithEmailAndPasswordUsecase {
  final LoginRepository _repository;

  SignInWithEmailAndPasswordUsecase(this._repository);

  Future<User?> call({
    required String email,
    required String password,
  }) async =>
      _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
}

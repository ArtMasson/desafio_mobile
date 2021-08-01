import 'package:desafio_mobile/app/login/data/datasource/login_datasource.dart';
import 'package:desafio_mobile/app/login/data/model/sign_in_with_email_and_password_model.dart';
import 'package:desafio_mobile/app/login/domain/repository/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepositoryImp implements LoginRepository {
  final LoginDatasource _datasource;

  LoginRepositoryImp(this._datasource);

  @override
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _datasource.signInWithEmailAndPassword(
      userInfo: SignInWithEmailAndPasswordModel(
        email: email,
        password: password,
      ),
    );
  }
}

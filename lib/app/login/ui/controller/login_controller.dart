import 'package:desafio_mobile/app/login/domain/usecase/sign_in_with_email_and_password_usecase.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginController with _$LoginController;

abstract class _LoginController with Store {
  late SignInWithEmailAndPasswordUsecase _signInWithEmailAndPasswordUseCase;
  final FirebaseAnalytics _analytics;

  @observable
  bool isLoading = false;

  _LoginController(this._signInWithEmailAndPasswordUseCase, this._analytics);

  @action
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    isLoading = true;
    final user = await _signInWithEmailAndPasswordUseCase(
      email: email,
      password: password,
    );
    if (user != null) {
      _analytics.logLogin(loginMethod: 'signInWithEmailAndPassword');
      return true;
    }
    _analytics.logEvent(
      name: 'Login_Invalid',
    );
    return false;
  }
}

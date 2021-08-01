import 'package:desafio_mobile/app/login/domain/usecase/sign_in_with_email_and_password_usecase.dart';
import 'package:desafio_mobile/app/login/ui/controller/login_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common/firebase_mock.dart';

class MockSignInWithEmailAndPasswordUsecase extends Mock
    implements SignInWithEmailAndPasswordUsecase {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late SignInWithEmailAndPasswordUsecase _usecase;
  late FirebaseAnalytics _analytics;
  late LoginController _controller;
  late User _mockUser;

  _createMockUser() async {
    var user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'user@user.com',
      displayName: 'User',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    final result =
        await auth.signInWithEmailAndPassword(email: '', password: '');
    _mockUser = result.user!;
  }

  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();
    _usecase = MockSignInWithEmailAndPasswordUsecase();
    _analytics = MockFirebaseAnalytics();
    _controller = LoginController(_usecase, _analytics);
    _createMockUser();
  });

  group("Login Controller - signInWithEmailAndPassword test", () {
    test(
      "Success - Should return true",
      () async {
        // arrange
        when(
          () => _analytics.logLogin(loginMethod: any(named: 'loginMethod')),
        ).thenAnswer(
          (invocation) => Future.value(),
        );
        when(
          () => _usecase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(_mockUser));
        // act
        final result =
            await _controller.signInWithEmailAndPassword('teste', 'teste');
        // assert
        expect(result, true);
        verify(
          () => _usecase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
        verifyNoMoreInteractions(_usecase);
      },
    );

    test(
      "Login Failed - Should return false",
      () async {
        when(
          () => _analytics.logEvent(
            name: any(named: 'name'),
          ),
        ).thenAnswer(
          (invocation) => Future.value(),
        );
        when(
          () => _usecase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(null));
        // act
        final result =
            await _controller.signInWithEmailAndPassword('teste', 'teste');
        // assert
        expect(result, false);
        verify(
          () => _usecase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
        verifyNoMoreInteractions(_usecase);
      },
    );
  });
}

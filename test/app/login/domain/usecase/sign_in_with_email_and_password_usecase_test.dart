import 'package:desafio_mobile/app/login/domain/repository/login_repository.dart';
import 'package:desafio_mobile/app/login/domain/usecase/sign_in_with_email_and_password_usecase.dart';
import 'package:desafio_mobile/core/common/injected/module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/firebase_mock.dart';

class MockLoginRepositoryImp extends Mock implements LoginRepository {}

void main() {
  late SignInWithEmailAndPasswordUsecase _usecase;
  late MockLoginRepositoryImp _repository;
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
    await configureInjection();
    await Firebase.initializeApp();
    _repository = MockLoginRepositoryImp();
    _usecase = SignInWithEmailAndPasswordUsecase(_repository);
    _createMockUser();
  });

  group("SignIn with email and password usecase test - ", () {
    test(
      'Success - Should return an User',
      () async {
        // arrange
        when(
          () => _repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(_mockUser));
        // act
        final result = await _usecase(
          email: '',
          password: '',
        );
        // assert
        expect(result, _mockUser);
        verify(
          () => _repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'Failed - Sould return null',
      () async {
        // arrange
        when(
          () => _repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(null));
        // act
        final result = await _usecase(
          email: '',
          password: '',
        );
        // assert
        expect(result, null);
        verify(
          () => _repository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}

import 'package:desafio_mobile/app/login/data/datasource/login_datasource.dart';
import 'package:desafio_mobile/app/login/data/model/sign_in_with_email_and_password_model.dart';
import 'package:desafio_mobile/app/login/data/repository/login_repository_imp.dart';
import 'package:desafio_mobile/app/login/domain/repository/login_repository.dart';
import 'package:desafio_mobile/core/common/injected/module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/firebase_mock.dart';

class MockLoginDataSource extends Mock implements LoginDatasource {}

void main() {
  late MockLoginDataSource _datasource;
  late LoginRepository _repository;
  late User _mockUser;

  final _mockUserInfoModel = SignInWithEmailAndPasswordModel(
    email: '',
    password: '',
  );

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
  setUpAll(() async {
    await configureInjection();
    await Firebase.initializeApp();
    registerFallbackValue(_mockUserInfoModel);
    _datasource = MockLoginDataSource();
    _repository = LoginRepositoryImp(_datasource);
    _createMockUser();
  });

  group('LoginRepository signInWithEmailAndPassword test - ', () {
    test('Success - Should return an User', () async {
      // arrange
      when(
        () => _datasource.signInWithEmailAndPassword(
          userInfo: any(
            named: 'userInfo',
          ),
        ),
      ).thenAnswer(
        (_) => Future.value(_mockUser),
      );
      // act
      final result = await _repository.signInWithEmailAndPassword(
        email: '',
        password: '',
      );
      // assert
      expect(result, _mockUser);
      verify(
        () => _datasource.signInWithEmailAndPassword(
          userInfo: any(named: 'userInfo'),
        ),
      ).called(1);
      verifyNoMoreInteractions(_datasource);
    });

    test('Failed - Sould return null', () async {
      // arrange
      when(
        () => _datasource.signInWithEmailAndPassword(
          userInfo: any(
            named: 'userInfo',
          ),
        ),
      ).thenAnswer(
        (_) => Future.value(null),
      );
      // act
      final result = await _repository.signInWithEmailAndPassword(
        email: '',
        password: '',
      );
      // assert
      expect(result, null);
      verify(
        () => _datasource.signInWithEmailAndPassword(
          userInfo: any(
            named: 'userInfo',
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(_datasource);
    });
  });
}

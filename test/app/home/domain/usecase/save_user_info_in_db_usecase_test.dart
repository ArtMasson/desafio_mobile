import 'package:desafio_mobile/app/home/domain/repository/home_repository.dart';
import 'package:desafio_mobile/app/home/domain/usecase/save_user_info_in_db_usecase.dart';
import 'package:desafio_mobile/app/login/domain/repository/login_repository.dart';
import 'package:desafio_mobile/app/login/domain/usecase/sign_in_with_email_and_password_usecase.dart';
import 'package:desafio_mobile/core/common/injected/module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/firebase_mock.dart';

class MockHomeRepositoryImp extends Mock implements HomeRepository {}

void main() {
  late SaveUserInfoInDbUsecase _usecase;
  late MockHomeRepositoryImp _repository;
  late User _mockUser;

  final _mockUserPosition = LatLng(-1111, -1111);

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
    registerFallbackValue(_mockUser);
  }

  setupFirebaseAuthMocks();
  setUp(() async {
    await configureInjection();
    await Firebase.initializeApp();
    _repository = MockHomeRepositoryImp();
    _usecase = SaveUserInfoInDbUsecase(_repository);
    _createMockUser();
    registerFallbackValue(_mockUserPosition);
  });

  group("Save user in db usecase test -", () {
    test(
      'Success',
      () async {
        // arrange
        when(() => _repository.saveUserInDb(any(), any()))
            .thenAnswer((_) => Future.value());
        // act
        await _usecase(
          userInfo: _mockUser,
          position: _mockUserPosition,
        );
        // assert
        verify(() => _repository.saveUserInDb(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}

import 'package:desafio_mobile/app/home/data/datasource/home_datasource.dart';
import 'package:desafio_mobile/app/home/data/repository/home_repository_imp.dart';
import 'package:desafio_mobile/app/home/domain/repository/home_repository.dart';
import 'package:desafio_mobile/core/common/injected/module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/firebase_mock.dart';

class MockHomeDataSource extends Mock implements HomeDatasource {}

void main() {
  late MockHomeDataSource _datasource;
  late HomeRepository _repository;
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
  setUpAll(() async {
    await configureInjection();
    await Firebase.initializeApp();
    _datasource = MockHomeDataSource();
    _repository = HomeRepositoryImp(_datasource);
    _createMockUser();
    registerFallbackValue(_mockUserPosition);
  });

  group('LoginRepository signInWithEmailAndPassword test - ', () {
    test('Success', () async {
      // arrange
      when(
        () => _datasource.saveUserInDb(
          any(),
          any(),
        ),
      ).thenAnswer((invocation) async => Future.value());
      // act
      await _repository.saveUserInDb(_mockUser, _mockUserPosition);
      // assert
      verify(() => _datasource.saveUserInDb(_mockUser, _mockUserPosition))
          .called(1);
      verifyNoMoreInteractions(_datasource);
    });
  });
}

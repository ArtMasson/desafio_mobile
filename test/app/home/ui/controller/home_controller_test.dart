import 'package:desafio_mobile/app/common/store/global_store.dart';
import 'package:desafio_mobile/app/home/domain/usecase/save_user_info_in_db_usecase.dart';
import 'package:desafio_mobile/app/home/ui/controller/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/firebase_mock.dart';

class MockGlobalStore extends Mock implements GlobalStore {}

class MockSaveUserInfoInDbUsecase extends Mock
    implements SaveUserInfoInDbUsecase {}

class MockLocation extends Mock implements Location {}

class MockLocationData extends Mock implements LocationData {
  @override
  double? get latitude => -1111;

  @override
  double? get longitude => -1111;
}

void main() {
  late GlobalStore _globalStore;
  late MockLocation _location;
  late MockSaveUserInfoInDbUsecase _usecase;
  late HomeController _controller;
  late User _mockUser;

  final _mockUserPosition = LatLng(-1111, -1111);
  final _mockLocationData = MockLocationData();

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
    await Firebase.initializeApp();
    _globalStore = MockGlobalStore();
    _usecase = MockSaveUserInfoInDbUsecase();
    _location = MockLocation();
    _controller = HomeController(
      _globalStore,
      _usecase,
      _location,
    );
    _createMockUser();
    registerFallbackValue(_mockUserPosition);
  });

  group("Home Controller - saveUserInfoInDb test -", () {
    test(
      "Success",
      () async {
        // arrange
        when(() => _globalStore.hasCurrentUser).thenReturn(true);
        when(() => _globalStore.getCurrentUser).thenReturn(_mockUser);
        when(
          () => _usecase(
            userInfo: any(named: 'userInfo'),
            position: any(named: 'position'),
          ),
        ).thenAnswer((_) => Future.value());
        // act
        await _controller.saveUserInfoInDb(_mockUserPosition);
        // assert
        verify(
          () => _usecase(
            userInfo: any(named: 'userInfo'),
            position: any(named: 'position'),
          ),
        ).called(1);
        verifyNoMoreInteractions(_usecase);
      },
    );
  });

  group("Home Controller - getCurrentLocation test -", () {
    test(
      "Should return a LatLng object",
      () async {
        // arrange
        when(() => _location.getLocation())
            .thenAnswer((invocation) async => _mockLocationData);
        // act
        final result = await _controller.getCurrentLocation();
        // assert
        expect(result, _mockUserPosition);
      },
    );
  });
}

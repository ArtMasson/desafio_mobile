import 'package:desafio_mobile/app/login/domain/usecase/sign_in_with_email_and_password_usecase.dart';
import 'package:desafio_mobile/app/login/ui/controller/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../common/firebase_mock.dart';

class MockSignInWithEmailAndPasswordUsecase extends Mock
    implements SignInWithEmailAndPasswordUsecase {}

void main() {
  late SignInWithEmailAndPasswordUsecase _usecase;
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
    _controller = LoginController(_usecase);
    _createMockUser();
  });

  group("Login Controller - signInWithEmailAndPassword test", () {
    test(
      "Success - Should return true",
      () async {
        // arrange
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

  // group("Checkin Home Controller - HasGuest", () {
  //   test(
  //     "Failure - Should return error to has guest",
  //     () async {
  //       when(_findAllGuestsUseCase.call(tReservationID)).thenAnswer(
  //         (_) => Future.value(const Left("")),
  //       );

  //       _controller.hotelSelected(tReservation);

  //       final _result = await _controller.hasGuestFromReservation();

  //       expect(_result, false);
  //       verify(_findAllGuestsUseCase.call(tReservationID));
  //       verifyNoMoreInteractions(_findAllGuestsUseCase);
  //     },
  //   );
  //   test(
  //     "Success - Should return success has guest",
  //     () async {
  //       when(_findAllGuestsUseCase.call(tReservationID)).thenAnswer(
  //         (_) => Future.value(Right(tGuestlList)),
  //       );

  //       _controller.hotelSelected(tReservation);

  //       final _result = await _controller.hasGuestFromReservation();

  //       expect(_result, true);
  //       verify(_findAllGuestsUseCase.call(tReservationID));
  //       verifyNoMoreInteractions(_findAllGuestsUseCase);
  //     },
  //   );
  // });

  // group("Checkin Home Controller - Checkin Onboarding", () {
  //   test(
  //     "hasCheckinOnboardingDone - should be get a bool",
  //     () {
  //       when(_hasCheckinOnboardingDoneUseCase.call()).thenAnswer(
  //         (_) async => true,
  //       );

  //       final _result = _controller.hasCheckinOnboardingDone();

  //       expect(_result, true);
  //       verify(_hasCheckinOnboardingDoneUseCase.call()).called(1);
  //       verifyNoMoreInteractions(_hasCheckinOnboardingDoneUseCase);
  //     },
  //   );
  //   test(
  //     "setCheckinOnboardingDone - should set OnboardingDone",
  //     () {
  //       _controller.setCheckinOnboardingDone();

  //       verify(_setCheckinOnboardingDoneUseCase.call()).called(1);
  //       verifyNoMoreInteractions(_setCheckinOnboardingDoneUseCase);
  //     },
  //   );
  // });
}

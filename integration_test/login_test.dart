import 'package:desafio_mobile/app/home/ui/pages/home_page.dart';
import 'package:desafio_mobile/config/fluterfire/flutterfire_init.dart';
import 'package:desafio_mobile/core/common/injected/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final emailField = find.byKey(Key('email-field'));
  final passwordField = find.byKey(Key('password-field'));
  final signInButton = find.text("Entrar");
  final homePage = find.byType(HomePage);
  final snackbar = find.byType(SnackBar);

  testWidgets(
      'login fails with incorrect email and password, provides snackbar feedback',
      (WidgetTester tester) async {
    await configureInjection();
    await tester.pumpWidget(FlutterFireInit());
    await tester.pumpAndSettle();
    await tester.tap(emailField.first);
    await tester.enterText(emailField, "test_user@user.com");
    await tester.tap(passwordField.first);
    await tester.enterText(passwordField, "123456");
    await tester.tap(signInButton);
    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(snackbar, findsOneWidget);
    expect(homePage, findsNothing);
  });

  testWidgets("log-in with correct email and password",
      (WidgetTester tester) async {
    await configureInjection();
    await tester.pumpWidget(FlutterFireInit());
    await tester.pumpAndSettle();
    await tester.tap(emailField.first);
    await tester.enterText(emailField, "user@user.com");
    await tester.tap(passwordField.first);
    await tester.enterText(passwordField, "123456");
    await tester.tap(signInButton);
    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(snackbar, findsNothing);
  });
}

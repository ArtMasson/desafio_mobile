import 'package:desafio_mobile/app/home/ui/pages/home_page.dart';
import 'package:desafio_mobile/config/fluterfire/flutterfire_init.dart';
import 'package:desafio_mobile/core/common/injected/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Rendering google maps widget via LoginPage",
      (WidgetTester tester) async {
    final emailField = find.byKey(Key('email-field'));
    final passwordField = find.byKey(Key('password-field'));
    final signInButton = find.text("Entrar");

    await configureInjection();
    await tester.pumpWidget(FlutterFireInit());
    await tester.pumpAndSettle();
    await tester.tap(emailField.first);
    await tester.enterText(emailField, "user@user.com");
    await tester.tap(passwordField.first);
    await tester.enterText(passwordField, "123456");
    await tester.tap(signInButton);
    await tester.pumpAndSettle(Duration(seconds: 10));

    final gooleMaps = find.byType(GoogleMap);
    final homePage = find.byType(HomePage);

    expect(homePage, findsOneWidget);
    expect(gooleMaps, findsOneWidget);
  });
}

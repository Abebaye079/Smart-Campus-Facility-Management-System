import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/features/auth/presentation/screens/signup_screen.dart';

void main() {
  group('SignUp Screen Widget Tree Tests', () {
    testWidgets(
      'should render four user registration fields and signup button elements correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: SignUpScreen())),
        );
        await tester.pumpAndSettle();

        expect(find.text('SIGN UP'), findsOneWidget);
        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Confirm Password'), findsOneWidget);
        expect(find.byType(InputField), findsNWidgets(4));
        expect(find.byType(PrimaryButton), findsOneWidget);
        expect(find.text('Sign Up'), findsOneWidget);
      },
    );

    testWidgets(
      'should show alert layout banner if validation fails on registration trigger',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: SignUpScreen())),
        );
        await tester.pumpAndSettle();

        final signUpButtonFinder = find.byType(PrimaryButton);
        await tester.ensureVisible(signUpButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(signUpButtonFinder);

        await tester.pumpAndSettle();

        expect(find.text('Please fill in all fields'), findsOneWidget);
      },
    );
  });
}

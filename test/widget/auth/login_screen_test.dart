import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/features/auth/presentation/screens/login_screen.dart';

void main() {
  group('Login Screen Widget Tree Tests', () {
    testWidgets(
      'should render all input fields, headers, and login buttons cleanly',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LoginScreen())),
        );
        await tester.pumpAndSettle();

        expect(find.text('LOG IN'), findsOneWidget);
        expect(find.text('TO CONTINUE'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.byType(InputField), findsNWidgets(2));
        expect(find.byType(PrimaryButton), findsOneWidget);
        expect(find.text('Login'), findsOneWidget);
      },
    );

    testWidgets(
      'should trigger local validation error state message if login fields are left blank',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LoginScreen())),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(PrimaryButton));

        await tester.pumpAndSettle();

        expect(find.text('Please fill in all fields'), findsOneWidget);
      },
    );
  });
}

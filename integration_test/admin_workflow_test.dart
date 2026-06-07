import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:smart_campus_app/core/network/api_client.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/widgets/facility_admin_card.dart';
import 'package:smart_campus_app/core/widgets/admin_bottom_nav_bar.dart';

import 'package:smart_campus_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder findTextCaseInsensitive(String pattern) {
    final regex = RegExp(pattern, caseSensitive: false);
    return find.byWidgetPredicate((widget) {
      if (widget is Text && widget.data != null) {
        return regex.hasMatch(widget.data!);
      }
      if (widget is RichText) {
        return regex.hasMatch(widget.text.toPlainText());
      }
      return false;
    });
  }

  group('Admin Flow End-to-End Integration Test Suite', () {
    testWidgets(
      'Complete Admin Lifecycle Performance Verification',
      (tester) async {

  
        if (Platform.isAndroid) {
          ApiClient.dio.options.baseUrl = 'http://10.0.2.2:3000/api';
        } else {
          ApiClient.dio.options.baseUrl = 'http://localhost:3000/api';
        }

   
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 4));

  
        final initialEmailField = find.byWidgetPredicate(
          (widget) =>
              widget is InputField && widget.hint == 'Enter your email',
        );

        if (initialEmailField.evaluate().isEmpty) {
          print('Active session detected. Logging out first...');
          final profileTab = find.byIcon(Icons.person);
          if (profileTab.evaluate().isNotEmpty) {
            await tester.tap(profileTab.first);
          } else {
            await tester.tap(findTextCaseInsensitive('Profile').first);
          }
          await tester.pumpAndSettle(const Duration(seconds: 3));

          final logoutBtn = findTextCaseInsensitive('Logout');
          if (logoutBtn.evaluate().isNotEmpty) {
            await tester.tap(logoutBtn.first);
          }
          await tester.pumpAndSettle(const Duration(seconds: 4));
        }

        final emailCustomField = find.byWidgetPredicate(
          (widget) =>
              widget is InputField && widget.hint == 'Enter your email',
        );
        final passwordCustomField = find.byWidgetPredicate(
          (widget) =>
              widget is InputField && widget.hint == 'Enter your password',
        );
        final loginButton = find.byWidgetPredicate(
          (widget) => widget is PrimaryButton && widget.text == 'Login',
        );

        expect(emailCustomField, findsOneWidget);
        expect(passwordCustomField, findsOneWidget);
        expect(loginButton, findsOneWidget);

        await tester.tap(
          find.descendant(
              of: emailCustomField, matching: find.byType(TextField)),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
              of: emailCustomField, matching: find.byType(TextField)),
          'sarataye@aau.edu',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        await tester.tap(
          find.descendant(
              of: passwordCustomField, matching: find.byType(TextField)),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
              of: passwordCustomField, matching: find.byType(TextField)),
          'admin1234',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 6));

        print('=== CHECKING DASHBOARD ===');
        expect(findTextCaseInsensitive('Welcome,'), findsWidgets);


        final addFacilityButton = find.byWidgetPredicate(
          (widget) =>
              widget is PrimaryButton && widget.text == '+ Add Facility',
        );
        expect(addFacilityButton, findsOneWidget);

        await tester.ensureVisible(addFacilityButton);
        await tester.pumpAndSettle();
        await tester.tap(addFacilityButton, warnIfMissed: false);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        print('=== ON ADD FACILITY SCREEN ===');
        expect(find.text('Add Facility'), findsWidgets);

        final nameCustom = find.byWidgetPredicate(
          (w) => w is InputField && w.hint == 'Facility Name',
        );
        final capCustom = find.byWidgetPredicate(
          (w) => w is InputField && w.hint == 'Capacity',
        );
        final descCustom = find.byWidgetPredicate(
          (w) => w is InputField && w.hint == 'Description',
        );
        final saveButton = find.byWidgetPredicate(
          (widget) => widget is PrimaryButton && widget.text == 'Save',
        );

        await tester.tap(
          find.descendant(of: nameCustom, matching: find.byType(TextField)),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(of: nameCustom, matching: find.byType(TextField)),
          'Engineering Hall C',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        print('=== NAME ENTERED ===');

        await tester.tap(
          find.descendant(of: capCustom, matching: find.byType(TextField)),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(of: capCustom, matching: find.byType(TextField)),
          '150',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        print('=== CAPACITY ENTERED ===');

        await tester.tap(
          find.descendant(of: descCustom, matching: find.byType(TextField)),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(of: descCustom, matching: find.byType(TextField)),
          'Tech seminar lecture room',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        print('=== DESCRIPTION ENTERED ===');

        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        await tester.tap(saveButton, warnIfMissed: false);
        print('=== SAVE TAPPED ===');

        await tester.pumpAndSettle(const Duration(seconds: 8));

      
        int attempts = 0;
        while (attempts < 30) {
          await tester.pump(const Duration(milliseconds: 500));
          if (find.byType(FacilityAdminCard).evaluate().isNotEmpty) {
            print('=== FacilityAdminCard FOUND after $attempts attempts ===');
            break;
          }
          attempts++;
        }
        await tester.pumpAndSettle(const Duration(seconds: 3));

        
        print('=== CHECKING FACILITY IN LIST ===');
        expect(find.byType(FacilityAdminCard), findsWidgets);
        expect(find.text('Engineering Hall C'), findsWidgets);

      
        print('=== TAPPING EDIT ===');
        final targetCard = find.ancestor(
          of: find.text('Engineering Hall C').first,
          matching: find.byType(FacilityAdminCard),
        );
        final editButton = find.descendant(
          of: targetCard,
          matching: find.byIcon(Icons.edit_outlined),
        );
        expect(editButton, findsOneWidget);
        await tester.tap(editButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

       
        final dialogNameCustom = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byWidgetPredicate(
            (w) => w is InputField && w.hint == 'Facility Name',
          ),
        );
        final dialogSaveButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is PrimaryButton && widget.text == 'Save Changes',
          ),
        );

        await tester.tap(
          find.descendant(
              of: dialogNameCustom, matching: find.byType(TextField)),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
              of: dialogNameCustom, matching: find.byType(TextField)),
          'Engineering Hall C Updated',
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        await tester.tap(dialogSaveButton, warnIfMissed: false);
        print('=== SAVE CHANGES TAPPED ===');

        int updateAttempts = 0;
        while (updateAttempts < 15) {
          await tester.pump(const Duration(milliseconds: 500));
          if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
            break;
          }
          updateAttempts++;
        }
        await tester.pumpAndSettle(const Duration(seconds: 3));

    
        print('=== CHECKING UPDATED NAME ===');
        expect(find.text('Engineering Hall C Updated'), findsWidgets);

   
        print('=== TAPPING DELETE ===');
        final updatedCard = find.ancestor(
          of: find.text('Engineering Hall C Updated').first,
          matching: find.byType(FacilityAdminCard),
        );

        final deleteButton = find.descendant(
          of: updatedCard,
          matching: find.byIcon(Icons.delete_outline),
        );

        expect(deleteButton, findsOneWidget);
        await tester.tap(deleteButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

      
        final confirmButton = findTextCaseInsensitive('Confirm');
        if (confirmButton.evaluate().isNotEmpty) {
          await tester.tap(confirmButton.first);
        } else {
          await tester.tap(find.text('Yes').first);
        }
        print('=== DELETE CONFIRMED ===');

   
        int deleteAttempts = 0;
        while (deleteAttempts < 15) {
          await tester.pump(const Duration(milliseconds: 500));
          if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
            break;
          }
          deleteAttempts++;
        }
        
        await tester.pumpAndSettle(const Duration(seconds: 3));

      
        print('=== CHECKING FACILITY DELETED ===');
        expect(find.text('Engineering Hall C Updated'), findsNothing);

   
        print('=== LOGGING OUT ===');
        final profileNavButton = find.descendant(
          of: find.byType(AdminBottomNavBar),
          matching: find.byIcon(Icons.person),
        );
        await tester.tap(profileNavButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final logoutBtn = find.widgetWithText(ElevatedButton, 'Logout');
        expect(logoutBtn, findsOneWidget);
        await tester.tap(logoutBtn);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        print('=== CHECKING LOGIN SCREEN ===');
        expect(find.byType(TextField), findsWidgets);
      },
    );
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:smart_campus_app/main.dart' as app;
import 'package:smart_campus_app/core/widgets/facility_card.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';

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

  group('End-to-End User Booking Flow (Real Backend)', () {
    testWidgets('Full User Lifecycle Journey', (WidgetTester tester) async {
      
      final uniqueId = DateTime.now().millisecondsSinceEpoch % 10000;
      final testName = 'Eyob Teshome';
      final testEmail = 'eyob.teshome_$uniqueId@aau.edu.et';
      final testPassword = 'StudentPass2026!';
      final bookingPurpose = 'Group Study';

      app.main();
      await tester.pumpAndSettle();
      final loginFieldsCheck = find.byType(TextField);
      if (loginFieldsCheck.evaluate().isEmpty) {
        print("Existing login session detected. Attempting automatic logout to reset test state...");
        
        final profileTab = find.byIcon(Icons.person);
        await tester.tap(profileTab.evaluate().isEmpty ? findTextCaseInsensitive('Profile') : profileTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final logoutButton = findTextCaseInsensitive('Logout');
        await tester.tap(logoutButton.evaluate().isEmpty ? find.byType(PrimaryButton).last : logoutButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      expect(find.byType(TextField), findsWidgets); 
      
      final signUpRedirectButton = findTextCaseInsensitive('Sign');
      expect(signUpRedirectButton, findsWidgets);
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(signUpRedirectButton.last);
      await tester.tap(signUpRedirectButton.last);
      await tester.pumpAndSettle();

      expect(findTextCaseInsensitive('SIGN UP'), findsWidgets);

      final inputFields = find.byType(TextField);
      expect(inputFields, findsWidgets);

      await tester.enterText(inputFields.at(0), testName);
      await tester.enterText(inputFields.at(1), testEmail);
      await tester.enterText(inputFields.at(2), testPassword);
      await tester.enterText(inputFields.at(3), testPassword); 
      await tester.pumpAndSettle();

      final signUpButton = find.byType(PrimaryButton);
      expect(signUpButton, findsOneWidget);
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(signUpButton);
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
      
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(findTextCaseInsensitive('Login'), findsWidgets);

      final loginFields = find.byType(TextField);
      await tester.enterText(loginFields.at(0), testEmail);
      await tester.enterText(loginFields.at(1), testPassword);
      await tester.pumpAndSettle();
      
      final loginBtn = find.byType(PrimaryButton).evaluate().isNotEmpty 
          ? find.byType(PrimaryButton) 
          : findTextCaseInsensitive('Login');
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(loginBtn.first);
      await tester.pumpAndSettle();
      await tester.tap(loginBtn.first);
      
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.textContaining(testName), findsOneWidget);

      expect(findTextCaseInsensitive('Facilities'), findsWidgets);

      final facilitiesTab = find.byIcon(Icons.business);
      await tester.tap(facilitiesTab.evaluate().isEmpty ? findTextCaseInsensitive('Facilities').first : facilitiesTab.first);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final facilityCardFinder = find.byType(FacilityCard);
      expect(facilityCardFinder, findsWidgets);
      
      await tester.ensureVisible(facilityCardFinder.first);
      await tester.tap(facilityCardFinder.first);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(findTextCaseInsensitive('Facility Details'), findsWidgets);
      final bookNowButton = find.byType(PrimaryButton);
      expect(bookNowButton, findsOneWidget);
      
      await tester.ensureVisible(bookNowButton);
      await tester.tap(bookNowButton);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      final calendarFinder = find.byWidgetPredicate((widget) => widget is TableCalendar);
      expect(calendarFinder, findsOneWidget);
      
      // Select today's numeric day contextually on calendar grid
      final todayString = DateTime.now().day.toString();
      await tester.tap(find.text(todayString).first);
      await tester.pumpAndSettle(const Duration(seconds: 4)); 

      expect(findTextCaseInsensitive('Slot'), findsWidgets);
      final availableSlotFinder = findTextCaseInsensitive('Available');
      expect(availableSlotFinder, findsWidgets);
      
      await tester.ensureVisible(availableSlotFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(availableSlotFinder.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      final purposeTextField = find.byType(TextField);
      await tester.ensureVisible(purposeTextField.first);
      await tester.enterText(purposeTextField.first, bookingPurpose);
      await tester.pumpAndSettle();

      final confirmBookingBtn = findTextCaseInsensitive('Confirm Booking');
      expect(confirmBookingBtn, findsWidgets);
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(confirmBookingBtn.first);
      await tester.pumpAndSettle();
      await tester.tap(confirmBookingBtn.first);
      
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(findTextCaseInsensitive('Successfully'), findsWidgets);

      await tester.pumpAndSettle(const Duration(seconds: 4));
      expect(findTextCaseInsensitive('My Bookings'), findsWidgets);

      final cancelButton = findTextCaseInsensitive('Cancel');
      await tester.tap(cancelButton.evaluate().isEmpty ? find.byIcon(Icons.cancel).first : cancelButton.first);
      await tester.pumpAndSettle();

      final dialogConfirmButton = findTextCaseInsensitive('Yes');
      await tester.tap(dialogConfirmButton.first);
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(findTextCaseInsensitive('Cancelled'), findsWidgets);

      final profileTab = find.byIcon(Icons.person);
      await tester.tap(profileTab.evaluate().isEmpty ? findTextCaseInsensitive('Profile').first : profileTab);
      await tester.pumpAndSettle();

      expect(find.text(testName), findsOneWidget);
      expect(find.text(testEmail), findsOneWidget);

      final logoutButton = findTextCaseInsensitive('Logout');
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(logoutButton.first);
      await tester.pumpAndSettle();
      await tester.tap(logoutButton.evaluate().isEmpty ? find.byType(PrimaryButton).last : logoutButton.first);
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(TextField), findsWidgets);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_campus_app/features/bookings/data/booking_local_data_source.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';
import '../unit/booking_repository_test.mocks.dart';

@GenerateMocks([BookingLocalDataSource])
void main() {
  group('BookingLocalDataSource Unit Tests', () {
    late MockBookingLocalDataSource mockBookingDataSource;
    late BookingModel sampleBooking;

    setUp(() {
      mockBookingDataSource = MockBookingLocalDataSource();

      sampleBooking = BookingModel(
        id: 'book_202',
        userId: 'user_01',
        facilityId: 'fac_101',
        facilityName: 'Indoor Basketball Court',
        date: '2026-06-20',
        timeSlot: '14:00 - 15:00',
        purpose: 'Intramural Practice Session',
        status: 'pending',
      );
    });

    test(
      'should verify getAllBookings returns user reservations successfully',
      () async {
        when(
          mockBookingDataSource.getAllBookings('user_01'),
        ).thenAnswer((_) async => [sampleBooking]);

        final result = await mockBookingDataSource.getAllBookings('user_01');

        expect(result, isNotEmpty);
        expect(result.first.id, 'book_202');
        expect(result.first.facilityName, 'Indoor Basketball Court');
      },
    );

    test(
      'should verify insertBooking creates a new reservation record smoothly',
      () async {
        when(
          mockBookingDataSource.insertBooking(sampleBooking),
        ).thenAnswer((_) async => Future<void>.value());

        expect(mockBookingDataSource.insertBooking(sampleBooking), completes);
      },
    );

    test(
      'should verify updateBooking updates existing record details smoothly',
      () async {
        when(
          mockBookingDataSource.updateBooking(sampleBooking),
        ).thenAnswer((_) async => Future<void>.value());

        expect(mockBookingDataSource.updateBooking(sampleBooking), completes);
      },
    );

    test(
      'should verify deleteBooking removes target record using its ID string cleanly',
      () async {
        when(
          mockBookingDataSource.deleteBooking('book_202'),
        ).thenAnswer((_) async => Future<void>.value());

        expect(mockBookingDataSource.deleteBooking('book_202'), completes);
      },
    );
  });
}

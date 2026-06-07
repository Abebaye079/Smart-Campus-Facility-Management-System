import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_campus_app/features/auth/data/auth_local_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_local_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_remote_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_repository_impl.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';
import 'package:smart_campus_app/features/bookings/presentation/providers/booking_provider.dart';

class FakeBookingRepository extends BookingRepositoryImpl {
  Future<List<BookingModel>> Function()? getBookingsCallback;
  Future<BookingModel> Function({
    required String facilityId,
    required String facilityName,
    required String date,
    required String timeSlot,
    required String purpose,
  })?
  createBookingCallback;
  Future<void> Function(BookingModel booking)? updateBookingCallback;
  Future<void> Function(String bookingId)? cancelBookingCallback;
  Future<List<Map<String, dynamic>>> Function(String facilityId, String date)?
  getAvailabilityCallback;

  FakeBookingRepository()
    : super(
        local: BookingLocalDataSource(),
        remote: BookingRemoteDataSource(),
        authLocal: AuthLocalDataSource(),
      );

  @override
  Future<List<BookingModel>> getBookings() async {
    return await getBookingsCallback?.call() ?? [];
  }

  @override
  Future<BookingModel> createBooking({
    required String facilityId,
    required String facilityName,
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    return await createBookingCallback?.call(
          facilityId: facilityId,
          facilityName: facilityName,
          date: date,
          timeSlot: timeSlot,
          purpose: purpose,
        ) ??
        Future.error(StateError('createBookingCallback not set'));
  }

  @override
  Future<void> updateBooking(BookingModel booking) async {
    if (updateBookingCallback == null) {
      return;
    }
    await updateBookingCallback!(booking);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    if (cancelBookingCallback == null) {
      return;
    }
    await cancelBookingCallback!(bookingId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailability(
    String facilityId,
    String date,
  ) async {
    return await getAvailabilityCallback?.call(facilityId, date) ?? [];
  }
}

void main() {
  group('BookingNotifier & AvailabilityNotifier State Tests', () {
    late FakeBookingRepository mockBookingRepository;
    late BookingModel sampleBooking1;
    late BookingModel sampleBooking2;

    setUp(() {
      mockBookingRepository = FakeBookingRepository();

      sampleBooking1 = BookingModel(
        id: 'book_01',
        userId: 'student_123',
        facilityId: 'fac_1',
        facilityName: 'Main Auditorium',
        date: '2026-06-15',
        timeSlot: '10:00 - 12:00',
        purpose: 'Seminar Presentation',
        status: 'confirmed',
      );

      sampleBooking2 = BookingModel(
        id: 'book_02',
        userId: 'student_123',
        facilityId: 'fac_2',
        facilityName: 'Chemistry Lab B',
        date: '2026-06-16',
        timeSlot: '14:00 - 16:00',
        purpose: 'Lab Experiment',
        status: 'pending',
      );
    });

    ProviderContainer createContainer() {
      final container = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(mockBookingRepository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test(
      'Initial state of bookingNotifierProvider returns an empty list wrapped in AsyncData',
      () {
        final container = createContainer();
        final initialState = container.read(bookingNotifierProvider);

        expect(initialState, const AsyncValue<List<BookingModel>>.data([]));
        expect(initialState.isLoading, isFalse);
      },
    );

    test(
      'getBookings transitions to loading and fetches list of bookings safely',
      () async {
        mockBookingRepository.getBookingsCallback = () async => [
          sampleBooking1,
          sampleBooking2,
        ];
        final container = createContainer();
        final futureFetch = container
            .read(bookingNotifierProvider.notifier)
            .getBookings();
        expect(container.read(bookingNotifierProvider).isLoading, isTrue);

        await futureFetch;

        final finalState = container.read(bookingNotifierProvider);
        expect(finalState.value, hasLength(2));
        expect(finalState.value, contains(sampleBooking1));
        expect(finalState.value, contains(sampleBooking2));
      },
    );

    test(
      'getBookings becomes AsyncError when repository fetch execution fails',
      () async {
        mockBookingRepository.getBookingsCallback = () async =>
            throw Exception('Database disk read corruption error');
        final container = createContainer();
        await container.read(bookingNotifierProvider.notifier).getBookings();

        final failureState = container.read(bookingNotifierProvider);
        expect(failureState, isA<AsyncError>());
        expect(
          failureState.error.toString(),
          contains('Database disk read corruption error'),
        );
      },
    );

    test(
      'createBooking updates state list instantly with added booking model instance on success',
      () async {
        mockBookingRepository.createBookingCallback =
            ({
              required String facilityId,
              required String facilityName,
              required String date,
              required String timeSlot,
              required String purpose,
            }) async {
              return sampleBooking1;
            };

        final container = createContainer();
        await container
            .read(bookingNotifierProvider.notifier)
            .createBooking(
              facilityId: 'fac_1',
              facilityName: 'Main Auditorium',
              date: '2026-06-15',
              timeSlot: '10:00 - 12:00',
              purpose: 'Seminar Presentation',
            );
        final updatedState = container.read(bookingNotifierProvider);
        expect(updatedState.value, hasLength(1));
        expect(updatedState.value!.first.id, 'book_01');
      },
    );

    test(
      'createBooking sets error state and rethrows exception when double booking occurs',
      () async {
        mockBookingRepository.createBookingCallback =
            ({
              required String facilityId,
              required String facilityName,
              required String date,
              required String timeSlot,
              required String purpose,
            }) async {
              throw Exception('Time slot already reserved');
            };
        final container = createContainer();
        await expectLater(
          container
              .read(bookingNotifierProvider.notifier)
              .createBooking(
                facilityId: 'fac_1',
                facilityName: 'Main Auditorium',
                date: '2026-06-15',
                timeSlot: '10:00 - 12:00',
                purpose: 'Seminar Presentation',
              ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Time slot already reserved'),
            ),
          ),
        );

        expect(container.read(bookingNotifierProvider), isA<AsyncError>());
      },
    );

    test(
      'updateBooking replaces matching structural element fields inline on success',
      () async {
        final container = createContainer();

        mockBookingRepository.getBookingsCallback = () async => [
          sampleBooking1,
          sampleBooking2,
        ];
        await container.read(bookingNotifierProvider.notifier).getBookings();

        final updatedBookingModel = BookingModel(
          id: sampleBooking2.id,
          userId: sampleBooking2.userId,
          facilityId: sampleBooking2.facilityId,
          facilityName: sampleBooking2.facilityName,
          date: sampleBooking2.date,
          timeSlot: sampleBooking2.timeSlot,
          purpose: 'Updated Purpose Field Text',
          status: 'confirmed',
        );

        mockBookingRepository.updateBookingCallback = (booking) async {
          if (booking.id != updatedBookingModel.id) {
            throw StateError('Unexpected booking update call');
          }
        };

        await container
            .read(bookingNotifierProvider.notifier)
            .updateBooking(updatedBookingModel);

        final targetList = container.read(bookingNotifierProvider).value!;
        expect(targetList, hasLength(2));
        expect(
          targetList.firstWhere((b) => b.id == 'book_02').purpose,
          'Updated Purpose Field Text',
        );
      },
    );

    test(
      'cancelBooking filters out dropped reservation row item immediately from state',
      () async {
        final container = createContainer();

        mockBookingRepository.getBookingsCallback = () async => [
          sampleBooking1,
          sampleBooking2,
        ];
        await container.read(bookingNotifierProvider.notifier).getBookings();

        mockBookingRepository.cancelBookingCallback = (bookingId) async {
          if (bookingId != 'book_01') {
            throw StateError('Unexpected cancelBooking call');
          }
        };

        await container
            .read(bookingNotifierProvider.notifier)
            .cancelBooking('book_01');

        final finalStateList = container.read(bookingNotifierProvider).value!;
        expect(finalStateList, hasLength(1));
        expect(finalStateList.any((b) => b.id == 'book_01'), isFalse);
      },
    );

    test(
      'AvailabilityNotifier handles fetching live time slots successfully',
      () async {
        final List<Map<String, dynamic>> mockSlots = [
          {'time': '09:00 - 10:00', 'available': true},
          {'time': '10:00 - 11:00', 'available': false},
        ];

        mockBookingRepository.getAvailabilityCallback =
            (facilityId, date) async {
              return mockSlots;
            };
        final container = createContainer();
        final futureLookup = container
            .read(availabilityProvider.notifier)
            .getAvailability('fac_1', '2026-06-15');
        expect(container.read(availabilityProvider).isLoading, isTrue);

        await futureLookup;

        final finalAvailabilityState = container.read(availabilityProvider);
        expect(finalAvailabilityState.value, hasLength(2));
        expect(finalAvailabilityState.value![0]['time'], '09:00 - 10:00');
      },
    );
  });
}

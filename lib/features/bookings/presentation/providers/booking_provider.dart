import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/features/bookings/data/booking_local_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_remote_data_source.dart';
import 'package:smart_campus_app/features/bookings/data/booking_repository_impl.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';
import 'package:smart_campus_app/features/auth/data/auth_local_data_source.dart'; 


final bookingRepositoryProvider = Provider<BookingRepositoryImpl>((ref) {
  return BookingRepositoryImpl(
    local: BookingLocalDataSource(),
    remote: BookingRemoteDataSource(),
    authLocal: AuthLocalDataSource(), 
  );
});


final bookingNotifierProvider =
    NotifierProvider<BookingNotifier, AsyncValue<List<BookingModel>>>(
      BookingNotifier.new,
    );

class BookingNotifier extends Notifier<AsyncValue<List<BookingModel>>> {
  @override
  AsyncValue<List<BookingModel>> build() {
    return const AsyncValue.data([]);
  }

  BookingRepositoryImpl get _repository => ref.read(bookingRepositoryProvider);

  // Get all bookings — cache first then API
  Future<void> getBookings() async {
    try {
      state = const AsyncValue.loading();
      final bookings = await _repository.getBookings();
      state = AsyncValue.data(bookings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBooking({
    required String facilityId,
    required String facilityName,
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    final currentBookings = state.value ?? [];
    state = AsyncValue<List<BookingModel>>.loading().copyWithPrevious(state);
    
    try {
      final booking = await _repository.createBooking(
        facilityId: facilityId,
        facilityName: facilityName,
        date: date,
        timeSlot: timeSlot,
        purpose: purpose,
      );
      
      state = AsyncValue.data([...currentBookings, booking]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow; // Pass up to the UI to intercept the context route redirection flow
    }
  }


  Future<void> updateBooking(BookingModel booking) async {
    final currentBookings = state.value ?? [];
    
    try {
      await _repository.updateBooking(booking);
      final updatedList = currentBookings.map((element) {
        return element.id == booking.id ? booking : element;
      }).toList();
      state = AsyncValue.data(updatedList);
    } catch (e, stack) {
      state = AsyncValue.data(currentBookings);
      rethrow; 
    }
  }


  Future<void> cancelBooking(String id) async {
    final currentBookings = state.value ?? [];
    final updatedList = currentBookings.where((b) => b.id != id).toList();
    state = AsyncValue.data(updatedList);
    
    try {
      // Execute network command silently in background thread container
      await _repository.cancelBooking(id);
    } catch (e, stack) {
      state = AsyncValue.data(currentBookings);
    }
  }
}

final availabilityProvider =
    NotifierProvider<
      AvailabilityNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >(AvailabilityNotifier.new);

class AvailabilityNotifier
    extends Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    return const AsyncValue.data([]);
  }

  BookingRepositoryImpl get _repository => ref.read(bookingRepositoryProvider);

  Future<void> getAvailability(String facilityId, String date) async {
    try {
      state = const AsyncValue.loading();
      final slots = await _repository.getAvailability(facilityId, date);
      state = AsyncValue.data(slots);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
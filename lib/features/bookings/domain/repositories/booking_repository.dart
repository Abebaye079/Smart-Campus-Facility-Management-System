import '../models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getBookings();

  Future<BookingModel> createBooking({
    required String facilityId,
    required String facilityName,
    required String date,
    required String timeSlot,
    required String purpose,
  });

  Future<void> updateBooking(BookingModel booking);

  Future<void> cancelBooking(String bookingId);

  Future<List<Map<String, dynamic>>> getAvailability(
    String facilityId,
    String date,
  );
}

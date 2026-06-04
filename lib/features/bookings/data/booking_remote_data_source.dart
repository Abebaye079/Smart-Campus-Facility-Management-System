import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/booking_model.dart';

class BookingRemoteDataSource {
  final Dio dio = ApiClient.dio;

  Future<List<BookingModel>> getBookings() async {
    try {
      final response = await dio.get('/bookings');
      return (response.data as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get bookings');
    }
  }

  // Create a new booking
  Future<BookingModel> createBooking({
    required String facilityId,
    required String facilityName, 
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    try {
      final response = await dio.post(
        '/bookings',
        data: {
          'facilityId': facilityId,
          'facilityName': facilityName, 
          'date': date,
          'timeSlot': timeSlot,
          'purpose': purpose,
        },
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create booking',
      );
    }
  }

  Future<BookingModel> updateBooking(BookingModel booking) async {
    try {
      final response = await dio.put(
        '/bookings/${booking.id}',
        data: {
          'date': booking.date,
          'timeSlot': booking.timeSlot,
          'purpose': booking.purpose,
        },
      );
      return BookingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update booking',
      );
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      await dio.delete('/bookings/$id');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to cancel booking',
      );
    }
  }

  // Get availability for a facility on a date
  Future<List<Map<String, dynamic>>> getAvailability(
    String facilityId,
    String date,
  ) async {
    try {
      final response = await dio.get(
        '/facilities/$facilityId/availability',
        queryParameters: {'date': date},
      );
      return (response.data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get availability',
      );
    }
  }
}
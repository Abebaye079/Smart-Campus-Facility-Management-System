import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/booking_model.dart';

class BookingRemoteDataSource {
  final Dio dio = ApiClient.dio;

  Future<List<BookingModel>> getBookings() async {
    final response = await dio.get('/bookings');

    final List<dynamic> data = response.data is List ? response.data : [];

    return data
        .map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<BookingModel> createBooking({
    required String facilityId,
    required String date,
    required String timeSlot,
    required String purpose,
  }) async {
    final response = await dio.post(
      '/bookings',
      data: {
        'facilityId': facilityId,
        'date': date,
        'timeSlot': timeSlot,
        'purpose': purpose,
      },
    );

    return BookingModel.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<BookingModel> updateBooking(String id, BookingModel booking) async {
    final response = await dio.put(
      '/bookings/$id',
      data: {
        'date': booking.date,
        'timeSlot': booking.timeSlot,
        'purpose': booking.purpose,
      },
    );

    return BookingModel.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<void> cancelBooking(String id) async {
    await dio.delete('/bookings/$id');
  }

  Future<List<Map<String, dynamic>>> getAvailability({
    required String facilityId,
    required String date,
  }) async {
    final response = await dio.get(
      '/bookings/availability',
      queryParameters: {'facilityId': facilityId, 'date': date},
    );

    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }

    return [];
  }
}

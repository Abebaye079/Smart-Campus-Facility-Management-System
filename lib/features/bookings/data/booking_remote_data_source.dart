import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/models/booking_model.dart';

class BookingRemoteDataSource {
  final Dio dio = ApiClient.dio;

  Future<List<BookingModel>> getBookings() async {
    final response = await dio.get('/bookings');

    return (response.data as List)
        .map((e) => BookingModel.fromJson(e))
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

    return BookingModel.fromJson(response.data);
  }

  Future<void> cancelBooking(String id) async {
    await dio.delete('/bookings/$id');
  }
}

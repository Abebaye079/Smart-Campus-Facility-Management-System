import 'package:sqflite/sqflite.dart';
import '../domain/models/booking_model.dart';
import '../../../core/database/db_helper.dart';

class BookingLocalDataSource {
  Future<List<BookingModel>> getAllBookings() async {
    final db = await DBHelper.database;

    final maps = await db.query('bookings');

    return maps.map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> insertBooking(BookingModel booking) async {
    final db = await DBHelper.database;

    await db.insert(
      'bookings',
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBooking(String id) async {
    final db = await DBHelper.database;

    await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateBooking(BookingModel booking) async {
    final db = await DBHelper.database;

    await db.update(
      'bookings',
      booking.toMap(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }
}

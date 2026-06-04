import 'package:sqflite/sqflite.dart';
import '../domain/models/booking_model.dart';
import '../../../core/database/db_helper.dart';

class BookingLocalDataSource {
  Future<List<BookingModel>> getAllBookings(String userId) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    // Use fromMap not fromJson — reading from SQLite not API
    return maps.map((e) => BookingModel.fromMap(e)).toList();
  }

  // Insert new booking into SQLite
  Future<void> insertBooking(BookingModel booking) async {
    final db = await DBHelper.database;
    await db.insert(
      'bookings',
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update existing booking in SQLite
  Future<void> updateBooking(BookingModel booking) async {
    final db = await DBHelper.database;
    await db.update(
      'bookings',
      booking.toMap(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  // Delete booking from SQLite
  Future<void> deleteBooking(String id) async {
    final db = await DBHelper.database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    await DBHelper.clearTable('bookings');
  }
}
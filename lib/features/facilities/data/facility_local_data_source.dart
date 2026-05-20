import 'package:sqflite/sqflite.dart';
import 'package:smart_campus_app/core/database/db_helper.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';

class FacilityLocalDataSource {
  // Read all from SQLite facilities table
  Future<List<FacilityModel>> getAllFacilities() async {
    final db = await DBHelper.database; // Called directly via static getter
    final List<Map<String, dynamic>> maps = await db.query('facilities');
    return List.generate(maps.length, (i) {
      return FacilityModel.fromJson(maps[i]);
    });
  }

  // Read one by id from SQLite
  Future<FacilityModel?> getFacilityById(String id) async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'facilities',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FacilityModel.fromJson(maps.first); // Fixed typo to maps.first
    }
    return null;
  }

  // Add new row to SQLite
  Future<void> insertFacility(FacilityModel facility) async {
    final db = await DBHelper.database;
    await db.insert(
      'facilities',
      facility.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update existing row in SQLite
  Future<void> updateFacility(FacilityModel facility) async {
    final db = await DBHelper.database;
    await db.update(
      'facilities',
      facility.toMap(),
      where: 'id = ?',
      whereArgs: [facility.id],
    );
  }

  // Remove row from SQLite
  Future<void> deleteFacility(String id) async {
    final db = await DBHelper.database;
    await db.delete(
      'facilities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all rows (used when refreshing from API)
  Future<void> clearAll() async {
    final db = await DBHelper.database;
    await db.delete('facilities');
  }
}

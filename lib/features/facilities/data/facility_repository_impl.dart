import 'package:smart_campus_app/features/facilities/data/facility_local_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_remote_data_source.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/domain/repositories/facility_repository.dart';

class FacilityRepositoryImpl implements FacilityRepository {
  final FacilityLocalDataSource localDataSource;
  final FacilityRemoteDataSource remoteDataSource;

  FacilityRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // Cache first → if empty call API → save to SQLite
  @override
  Future<List<FacilityModel>> getFacilities() async {
    try {
      final cached = await localDataSource.getAllFacilities();
      if (cached.isNotEmpty) return cached;

      final remote = await remoteDataSource.getAllFacilities();
      for (final facility in remote) {
        await localDataSource.insertFacility(facility);
      }
      return remote;
    } catch (e) {
      final cached = await localDataSource.getAllFacilities();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<FacilityModel> getFacilityById(String id) async {
    return await remoteDataSource.getFacilityById(id);
  }

  @override
  Future<void> addFacility(FacilityModel facility) async {
    await remoteDataSource.addFacility(facility);
    await localDataSource.insertFacility(facility);
  }

  @override
  Future<void> updateFacility(FacilityModel facility) async {
    await remoteDataSource.updateFacility(facility);
    await localDataSource.updateFacility(facility);
  }

  @override
  Future<void> deleteFacility(String id) async {
    await remoteDataSource.deleteFacility(id);
    await localDataSource.deleteFacility(id);
  }
}
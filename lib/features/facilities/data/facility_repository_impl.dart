import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/domain/repositories/facility_repository.dart';
import 'package:smart_campus_app/features/facilities/data/facility_local_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_remote_data_source.dart';

class FacilityRepositoryImpl implements FacilityRepository {
  final FacilityLocalDataSource _localDataSource;
  final FacilityRemoteDataSource _remoteDataSource;

  FacilityRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<FacilityModel>> getFacilities() async {
    // 1. Check SQLite first
    final localFacilities = await _localDataSource.getAllFacilities();
    if (localFacilities.isNotEmpty) {
      return localFacilities;
    }

    // 2. If empty, call API
    final remoteFacilities = await _remoteDataSource.getAllFacilities();

    // 3. Save results to SQLite cache
    for (var facility in remoteFacilities) {
      await _localDataSource.insertFacility(facility);
    }

    return remoteFacilities;
  }

  @override
  Future<FacilityModel> getFacilityById(String id) async {
    // 1. Check SQLite first
    final localFacility = await _localDataSource.getFacilityById(id);
    if (localFacility != null) {
      return localFacility;
    }

    // 2. If not found, call API
    final remoteFacility = await _remoteDataSource.getFacilityById(id);
    return remoteFacility;
  }

  @override
  Future<void> addFacility(FacilityModel facility) async {
    // 1. Call API
    final newFacility = await _remoteDataSource.addFacility(facility);
    // 2. Insert result into SQLite
    await _localDataSource.insertFacility(newFacility);
  }

  @override
  Future<void> updateFacility(FacilityModel facility) async {
    // 1. Call API
    final updatedFacility = await _remoteDataSource.updateFacility(facility);
    // 2. Update SQLite row
    await _localDataSource.insertFacility(updatedFacility);
  }

  @override
  Future<void> deleteFacility(String id) async {
    // 1. Call API
    await _remoteDataSource.deleteFacility(id);
    // 2. Delete from SQLite
    await _localDataSource.deleteFacility(id);
  }
}

import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
// Ensure this path matches the folder structure you just sent
import 'package:smart_campus_app/features/facilities/data/facility_remote_data_source.dart';
import 'package:smart_campus_app/features/facilities/domain/repositories/facility_repository.dart';

class FacilityRepositoryImpl implements FacilityRepository {
  final FacilityRemoteDataSource remoteDataSource;

  FacilityRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FacilityModel>> getFacilities() async {
    return await remoteDataSource.getAllFacilities();
  }

  @override
  Future<FacilityModel> getFacilityById(String id) async {
    // Note: Ensure your remoteDataSource has this method,
    // or call a generic get method if needed.
    return await remoteDataSource.getFacilityById(id);
  }

  @override
  Future<void> addFacility(FacilityModel facility) async {
    await remoteDataSource.addFacility(facility);
  }

  @override
  Future<void> updateFacility(FacilityModel facility) async {
    await remoteDataSource.updateFacility(facility);
  }

  @override
  Future<void> deleteFacility(String id) async {
    await remoteDataSource.deleteFacility(id);
  }
}

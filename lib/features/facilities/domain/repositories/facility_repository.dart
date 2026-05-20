import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';

abstract class FacilityRepository {
  Future<List<FacilityModel>> getFacilities();
  Future<FacilityModel> getFacilityById(String id);
  Future<void> addFacility(FacilityModel facility);
  Future<void> updateFacility(FacilityModel facility);
  Future<void> deleteFacility(String id);
}

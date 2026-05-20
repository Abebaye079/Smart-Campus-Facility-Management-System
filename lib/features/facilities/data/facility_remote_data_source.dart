import 'package:smart_campus_app/core/network/api_client.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';

class FacilityRemoteDataSource {
  // GET /facilities
  Future<List<FacilityModel>> getAllFacilities() async {
    final response = await ApiClient.dio.get(
      '/facilities',
    ); 
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => FacilityModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // GET /facilities/:id
  Future<FacilityModel> getFacilityById(String id) async {
    final response = await ApiClient.dio.get('/facilities/$id');
    return FacilityModel.fromJson(response.data as Map<String, dynamic>);
  }

  // POST /facilities
  Future<FacilityModel> addFacility(FacilityModel facility) async {
    final response = await ApiClient.dio.post(
      '/facilities',
      data: facility.toMap(),
    );
    return FacilityModel.fromJson(response.data as Map<String, dynamic>);
  }

  // PUT /facilities/:id
  Future<FacilityModel> updateFacility(FacilityModel facility) async {
    final response = await ApiClient.dio.put(
      '/facilities/${facility.id}',
      data: facility.toMap(),
    );
    return FacilityModel.fromJson(response.data as Map<String, dynamic>);
  }

  // DELETE /facilities/:id
  Future<void> deleteFacility(String id) async {
    await ApiClient.dio.delete('/facilities/$id');
  }
}

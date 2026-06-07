import 'package:dio/dio.dart';
import 'package:smart_campus_app/core/network/api_client.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';

class FacilityRemoteDataSource {
  Future<List<FacilityModel>> getAllFacilities() async {
    final response = await ApiClient.dio.get('/facilities');
    final List<dynamic> list = (response.data is List)
        ? response.data
        : (response.data['data'] ?? []);
    return list.map((json) => FacilityModel.fromJson(json)).toList();
  }

  Future<FacilityModel> getFacilityById(String id) async {
    final response = await ApiClient.dio.get('/facilities/$id');
    return FacilityModel.fromJson(response.data);
  }

  Future<void> addFacility(FacilityModel facility) async {
  await ApiClient.dio.post('/facilities', data: {
    'name': facility.name,
    'capacity': facility.capacity,
    'description': facility.description,
    'type': facility.type,
  });
}

Future<void> updateFacility(FacilityModel facility) async {
  print('=== UPDATING FACILITY ID: ${facility.id} ===');
  await ApiClient.dio.put(
    '/facilities/${facility.id}',
    data: {
      'name': facility.name,
      'capacity': facility.capacity,
      'description': facility.description,
      'type': facility.type,
    },
  );
}

  Future<void> deleteFacility(String id) async {
    await ApiClient.dio.delete('/facilities/$id');
  }
}

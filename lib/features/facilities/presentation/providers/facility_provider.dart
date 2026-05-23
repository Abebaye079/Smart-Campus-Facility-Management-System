import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/data/facility_remote_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_repository_impl.dart';
import 'package:smart_campus_app/features/facilities/domain/repositories/facility_repository.dart';

final facilityRemoteDataSourceProvider = Provider<FacilityRemoteDataSource>(
  (ref) => FacilityRemoteDataSource(),
);

final facilityRepositoryProvider = Provider<FacilityRepository>((ref) {
  final remote = ref.read(facilityRemoteDataSourceProvider);
  return FacilityRepositoryImpl(remote);
});

final facilityProvider =
    AsyncNotifierProvider<FacilityNotifier, List<FacilityModel>>(
      FacilityNotifier.new,
    );

class FacilityNotifier extends AsyncNotifier<List<FacilityModel>> {
  final List<FacilityModel> _allFacilities = [];

  FacilityRepository get _repository => ref.read(facilityRepositoryProvider);

  @override
  Future<List<FacilityModel>> build() async {
    final facilities = await _repository.getFacilities();
    _allFacilities
      ..clear()
      ..addAll(facilities);
    return facilities;
  }

  Future<void> refreshFacilities() async {
    state = const AsyncValue.loading();
    try {
      final facilities = await _repository.getFacilities();
      _allFacilities
        ..clear()
        ..addAll(facilities);
      state = AsyncValue.data(facilities);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> getFacilities() async => refreshFacilities();

  Future<void> addFacility(FacilityModel facility) async {
    await _repository.addFacility(facility);
    await refreshFacilities();
  }

  Future<void> updateFacility(FacilityModel facility) async {
    await _repository.updateFacility(facility);
    await refreshFacilities();
  }

  Future<void> deleteFacility(String id) async {
    await _repository.deleteFacility(id);
    await refreshFacilities();
  }

  void searchFacilities(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = AsyncValue.data(List.from(_allFacilities));
      return;
    }

    final lower = trimmed.toLowerCase();
    final filtered = _allFacilities.where((facility) {
      return facility.name.toLowerCase().contains(lower) ||
          facility.description.toLowerCase().contains(lower) ||
          facility.type.toLowerCase().contains(lower);
    }).toList();

    state = AsyncValue.data(filtered);
  }
}

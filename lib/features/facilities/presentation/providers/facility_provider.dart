import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/data/facility_local_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_remote_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_repository_impl.dart';

final facilityLocalDataSourceProvider = Provider((ref) {
  return FacilityLocalDataSource();
});

final facilityRemoteDataSourceProvider = Provider((ref) {
  return FacilityRemoteDataSource();
});

final facilityRepositoryProvider = Provider((ref) {
  final local = ref.read(facilityLocalDataSourceProvider);
  final remote = ref.read(facilityRemoteDataSourceProvider);
  return FacilityRepositoryImpl(local, remote);
});

class FacilityNotifier extends AsyncNotifier<List<FacilityModel>> {
  late final FacilityRepositoryImpl _repository;
  List<FacilityModel> _allFacilities = [];

  @override
  Future<List<FacilityModel>> build() async {
    _repository = ref.read(facilityRepositoryProvider);

    _allFacilities = await _repository.getFacilities();
    return _allFacilities;
  }

  Future<void> getFacilities() async {
    state = const AsyncLoading();
    try {
      _allFacilities = await _repository.getFacilities();
      state = AsyncData(_allFacilities);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> addFacility(FacilityModel facility) async {
    state = const AsyncLoading();
    try {
      await _repository.addFacility(facility);

      _allFacilities = await _repository.getFacilities();
      state = AsyncData(_allFacilities);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> updateFacility(FacilityModel facility) async {
    state = const AsyncLoading();
    try {
      await _repository.updateFacility(facility);

      _allFacilities = await _repository.getFacilities();
      state = AsyncData(_allFacilities);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteFacility(String id) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteFacility(id);
      // Remove it from our local master copy and update UI state
      _allFacilities.removeWhere((item) => item.id == id);
      state = AsyncData(_allFacilities);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  void searchFacilities(String query) {
    if (query.isEmpty) {
      state = AsyncData(_allFacilities);
    } else {
      final filteredList = _allFacilities.where((facility) {
        return facility.name.toLowerCase().contains(query.toLowerCase()) ||
            facility.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = AsyncData(filteredList);
    }
  }
}

final facilityProvider =
    AsyncNotifierProvider<FacilityNotifier, List<FacilityModel>>(() {
      return FacilityNotifier();
    });

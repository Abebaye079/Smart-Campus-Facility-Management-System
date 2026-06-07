import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'package:smart_campus_app/features/facilities/domain/repositories/facility_repository.dart';
import 'package:smart_campus_app/features/facilities/presentation/providers/facility_provider.dart';

class FakeFacilityRepository implements FacilityRepository {
  Future<List<FacilityModel>> Function()? onGetFacilities;
  Future<FacilityModel> Function(String)? onGetFacilityById;
  Future<void> Function(FacilityModel)? onAddFacility;
  Future<void> Function(FacilityModel)? onUpdateFacility;
  Future<void> Function(String)? onDeleteFacility;

  int getFacilitiesCallCount = 0;

  @override
  Future<List<FacilityModel>> getFacilities() async {
    getFacilitiesCallCount++;
    return onGetFacilities?.call() ?? [];
  }

  @override
  Future<FacilityModel> getFacilityById(String id) async {
    return onGetFacilityById?.call(id) ??
        Future.error(StateError('No getFacilityById callback configured'));
  }

  @override
  Future<void> addFacility(FacilityModel facility) async {
    return onAddFacility?.call(facility) ?? Future.value();
  }

  @override
  Future<void> updateFacility(FacilityModel facility) async {
    return onUpdateFacility?.call(facility) ?? Future.value();
  }

  @override
  Future<void> deleteFacility(String id) async {
    return onDeleteFacility?.call(id) ?? Future.value();
  }
}

void main() {
  group('FacilityNotifier Riverpod State Provider Tests', () {
    late FakeFacilityRepository fakeFacilityRepository;
    late FacilityModel sampleFacility1;
    late FacilityModel sampleFacility2;

    setUp(() {
      fakeFacilityRepository = FakeFacilityRepository();

      sampleFacility1 = FacilityModel(
        id: 'fac_1',
        name: 'Main Auditorium',
        description: 'Grand hall room inside administrative block',
        capacity: 500,
        type: 'Hall',
      );

      sampleFacility2 = FacilityModel(
        id: 'fac_2',
        name: 'Chemistry Lab B',
        description: 'Science building floor 2 laboratory',
        capacity: 40,
        type: 'Lab',
      );
    });

    ProviderContainer createContainer() {
      final container = ProviderContainer(
        overrides: [
          facilityRepositoryProvider.overrideWithValue(fakeFacilityRepository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test(
      'Initial state executes build and loads repository items successfully',
      () async {
        fakeFacilityRepository.onGetFacilities = () async => [
          sampleFacility1,
          sampleFacility2,
        ];

        final container = createContainer();
        expect(container.read(facilityProvider).isLoading, isTrue);

        final stateData = await container.read(facilityProvider.future);
        expect(stateData, hasLength(2));
        expect(stateData.first.name, 'Main Auditorium');
      },
    );

    test(
      'Initial state evaluates to an empty list when repository contains no items',
      () async {
        fakeFacilityRepository.onGetFacilities = () async => [];

        final container = createContainer();
        final stateData = await container.read(facilityProvider.future);

        expect(stateData, isEmpty);
      },
    );

    test(
      'State becomes explicitly loading when getFacilities is triggered',
      () async {
        fakeFacilityRepository.onGetFacilities = () async => [sampleFacility1];

        final container = createContainer();
        final futureFetch = container
            .read(facilityProvider.notifier)
            .getFacilities();

        expect(container.read(facilityProvider).isLoading, isTrue);

        await futureFetch;
      },
    );

    test('State becomes error when API call fails', () async {
      fakeFacilityRepository.onGetFacilities = () async => [sampleFacility1];

      final container = createContainer();
      await container.read(facilityProvider.future);

      fakeFacilityRepository.onGetFacilities = () async {
        throw Exception('Server connectivity crash');
      };

      await container.read(facilityProvider.notifier).getFacilities();

      final providerState = container.read(facilityProvider);
      expect(providerState, isA<AsyncError>());
      expect(
        providerState.error.toString(),
        contains('Server connectivity crash'),
      );
    });

    test(
      'State populates cleanly with list of facilities after a successful fetch operation',
      () async {
        fakeFacilityRepository.onGetFacilities = () async => [
          sampleFacility1,
          sampleFacility2,
        ];

        final container = createContainer();
        await container.read(facilityProvider.future);

        await container.read(facilityProvider.notifier).getFacilities();

        final providerState = container.read(facilityProvider);
        expect(providerState.value, contains(sampleFacility1));
        expect(providerState.value, contains(sampleFacility2));
      },
    );

    test('State updates correctly after adding a new facility', () async {
      fakeFacilityRepository.onGetFacilities = () async => [sampleFacility1];
      fakeFacilityRepository.onAddFacility = (_) async => Future.value();

      final container = createContainer();
      await container.read(facilityProvider.future);

      fakeFacilityRepository.onGetFacilities = () async => [
        sampleFacility1,
        sampleFacility2,
      ];

      await container
          .read(facilityProvider.notifier)
          .addFacility(sampleFacility2);

      expect(container.read(facilityProvider).value, hasLength(2));
      expect(container.read(facilityProvider).value, contains(sampleFacility2));
    });

    test('State updates correctly after deleting a facility', () async {
      fakeFacilityRepository.onGetFacilities = () async => [
        sampleFacility1,
        sampleFacility2,
      ];
      fakeFacilityRepository.onDeleteFacility = (_) async => Future.value();

      final container = createContainer();
      await container.read(facilityProvider.future);

      fakeFacilityRepository.onGetFacilities = () async => [sampleFacility1];

      await container.read(facilityProvider.notifier).deleteFacility('fac_2');

      expect(container.read(facilityProvider).value, hasLength(1));
      expect(
        container.read(facilityProvider).value,
        isNot(contains(sampleFacility2)),
      );
    });

    test(
      'Search filters the facility list locally without calling API',
      () async {
        fakeFacilityRepository.onGetFacilities = () async => [
          sampleFacility1,
          sampleFacility2,
        ];

        final container = createContainer();
        await container.read(facilityProvider.future);

        fakeFacilityRepository.getFacilitiesCallCount = 0;

        container.read(facilityProvider.notifier).searchFacilities('Chemistry');

        final filteredState = container.read(facilityProvider).value;
        expect(filteredState, hasLength(1));
        expect(filteredState!.first.name, 'Chemistry Lab B');
        expect(fakeFacilityRepository.getFacilitiesCallCount, 0);
      },
    );
  });
}

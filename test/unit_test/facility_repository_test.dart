import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_campus_app/features/facilities/data/facility_local_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_remote_data_source.dart';
import 'package:smart_campus_app/features/facilities/data/facility_repository_impl.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import 'facility_repository_test.mocks.dart';

@GenerateMocks([
  FacilityLocalDataSource,
  FacilityRemoteDataSource,
])
void main() {
  late FacilityRepositoryImpl repository;
  late MockFacilityLocalDataSource mockLocal;
  late MockFacilityRemoteDataSource mockRemote;

  // Sample facility used across all tests
  final sampleFacility = FacilityModel(
    id: 'fac_101',
    name: 'Amphitheater A',
    description: 'Main Academic Campus Hall',
    capacity: 250,
    type: 'Room',
  );

  final anotherFacility = FacilityModel(
    id: 'fac_102',
    name: 'Lab B',
    description: 'Computer Laboratory',
    capacity: 50,
    type: 'Lab',
  );

  setUp(() {
    mockLocal = MockFacilityLocalDataSource();
    mockRemote = MockFacilityRemoteDataSource();
    repository = FacilityRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
    );
  });

  group('FacilityRepository Unit Tests', () {

    // ── getFacilities ─────────────────────────────────────

    test(
      'getFacilities returns from SQLite cache when data exists',
      () async {
        // Arrange
        when(mockLocal.getAllFacilities())
            .thenAnswer((_) async => [sampleFacility]);

        // Act
        final result = await repository.getFacilities();

        // Assert
        expect(result, isNotEmpty);
        expect(result.length, 1);
        expect(result.first.name, 'Amphitheater A');
        expect(result.first.capacity, 250);
        // API should NOT be called when cache has data
        verifyNever(mockRemote.getAllFacilities());
      },
    );

    test(
      'getFacilities calls API when SQLite cache is empty',
      () async {
        // Arrange
        when(mockLocal.getAllFacilities())
            .thenAnswer((_) async => []);
        when(mockRemote.getAllFacilities())
            .thenAnswer((_) async => [sampleFacility]);
        when(mockLocal.insertFacility(sampleFacility))
            .thenAnswer((_) async {});

        final result = await repository.getFacilities();

        expect(result, isNotEmpty);
        expect(result.first.name, 'Amphitheater A');
        // API must be called when cache is empty
        verify(mockRemote.getAllFacilities()).called(1);
      },
    );

    test(
      'getFacilities saves API results to SQLite after fetching',
      () async {
        when(mockLocal.getAllFacilities())
            .thenAnswer((_) async => []);
        when(mockRemote.getAllFacilities())
            .thenAnswer((_) async => [sampleFacility]);
        when(mockLocal.insertFacility(sampleFacility))
            .thenAnswer((_) async {});

        await repository.getFacilities();

        // Assert — SQLite insert must be called to cache the data
        verify(mockLocal.insertFacility(sampleFacility)).called(1);
      },
    );

    test(
      'getFacilities returns multiple facilities from cache',
      () async {
        when(mockLocal.getAllFacilities())
            .thenAnswer((_) async => [sampleFacility, anotherFacility]);

        final result = await repository.getFacilities();

        expect(result.length, 2);
        expect(result[0].name, 'Amphitheater A');
        expect(result[1].name, 'Lab B');
      },
    );

    test(
      'getFacilities returns empty list when both cache and API have no data',
      () async {
        when(mockLocal.getAllFacilities())
            .thenAnswer((_) async => []);
        when(mockRemote.getAllFacilities())
            .thenAnswer((_) async => []);

        final result = await repository.getFacilities();

        expect(result, isEmpty);
      },
    );


    test(
      'addFacility calls API first then saves to SQLite',
      () async {
        when(mockRemote.addFacility(sampleFacility))
            .thenAnswer((_) async {});
        when(mockLocal.insertFacility(sampleFacility))
            .thenAnswer((_) async {});

        await repository.addFacility(sampleFacility);

        verify(mockRemote.addFacility(sampleFacility)).called(1);
        verify(mockLocal.insertFacility(sampleFacility)).called(1);
      },
    );

    test(
      'addFacility does not save to SQLite if API call fails',
      () async {
        when(mockRemote.addFacility(sampleFacility))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.addFacility(sampleFacility),
          throwsException,
        );
        verifyNever(mockLocal.insertFacility(sampleFacility));
      },
    );


    test(
      'updateFacility calls API first then updates SQLite',
      () async {
        when(mockRemote.updateFacility(sampleFacility))
            .thenAnswer((_) async {});
        when(mockLocal.updateFacility(sampleFacility))
            .thenAnswer((_) async {});

        await repository.updateFacility(sampleFacility);

        verify(mockRemote.updateFacility(sampleFacility)).called(1);
        verify(mockLocal.updateFacility(sampleFacility)).called(1);
      },
    );

    test(
      'updateFacility does not update SQLite if API call fails',
      () async {
        when(mockRemote.updateFacility(sampleFacility))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.updateFacility(sampleFacility),
          throwsException,
        );
        verifyNever(mockLocal.updateFacility(sampleFacility));
      },
    );


    test(
      'deleteFacility calls API first then removes from SQLite',
      () async {
        when(mockRemote.deleteFacility('fac_101'))
            .thenAnswer((_) async {});
        when(mockLocal.deleteFacility('fac_101'))
            .thenAnswer((_) async {});

        await repository.deleteFacility('fac_101');

        verify(mockRemote.deleteFacility('fac_101')).called(1);
        verify(mockLocal.deleteFacility('fac_101')).called(1);
      },
    );

    test(
      'deleteFacility does not delete from SQLite if API call fails',
      () async {
        when(mockRemote.deleteFacility('fac_101'))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.deleteFacility('fac_101'),
          throwsException,
        );
        verifyNever(mockLocal.deleteFacility('fac_101'));
      },
    );
  });
}
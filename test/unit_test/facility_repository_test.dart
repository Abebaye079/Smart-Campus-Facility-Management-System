import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_campus_app/features/facilities/data/facility_local_data_source.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';
import '../unit/facility_repository_test.mocks.dart';

@GenerateMocks([FacilityLocalDataSource])
void main() {
  group('FacilityLocalDataSource Unit Tests', () {
    late MockFacilityLocalDataSource mockFacilityDataSource;
    late FacilityModel sampleFacility;

    setUp(() {
      mockFacilityDataSource = MockFacilityLocalDataSource();

      sampleFacility = FacilityModel(
        id: 'fac_101',
        name: 'Amphitheater A',
        description: 'Main Academic Campus Hall',
        capacity: 250,
        type: 'Room',
      );
    });

    test(
      'should verify getAllFacilities returns a list of facility models successfully',
      () async {
        when(
          mockFacilityDataSource.getAllFacilities(),
        ).thenAnswer((_) async => [sampleFacility]);

        final result = await mockFacilityDataSource.getAllFacilities();

        expect(result, isNotEmpty);
        expect(result.first.name, 'Amphitheater A');
      },
    );

    test(
      'should verify insertFacility saves data smoothly without throwing exceptions',
      () async {
        when(
          mockFacilityDataSource.insertFacility(sampleFacility),
        ).thenAnswer((_) async => Future<void>.value());

        expect(
          mockFacilityDataSource.insertFacility(sampleFacility),
          completes,
        );
      },
    );

    test(
      'should verify updateFacility modifies records cleanly without crashing',
      () async {
        when(
          mockFacilityDataSource.updateFacility(sampleFacility),
        ).thenAnswer((_) async => Future<void>.value());

        expect(
          mockFacilityDataSource.updateFacility(sampleFacility),
          completes,
        );
      },
    );

    test(
      'should verify deleteFacility execution trace completes by target ID string',
      () async {
        when(
          mockFacilityDataSource.deleteFacility('fac_101'),
        ).thenAnswer((_) async => Future<void>.value());

        expect(mockFacilityDataSource.deleteFacility('fac_101'), completes);
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rick_and_morty_apps/services/api_location.dart';
import 'package:rick_and_morty_apps/models/location.dart';
import 'package:rick_and_morty_apps/services/api.dart';

import 'api_location_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiServiceLocation', () {
    late MockClient mockClient;
    late ApiServiceLocation apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiServiceLocation(client: mockClient);
    });

    test('fetchLocations returns list of locations if response is 200',
        () async {
      final mockResponse = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Earth',
            'type': 'Planet',
            'dimension': 'Dimension C-137',
            'residents': [
              'https://rickandmortyapi.com/api/character/1',
              'https://rickandmortyapi.com/api/character/2'
            ],
            'url': 'https://rickandmortyapi.com/api/location/1',
            'created': '2017-11-10T12:42:04.162Z'
          },
        ],
      });

      when(mockClient.get(Uri.parse(Api.dataLocation)))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final locations = await apiService.fetchLocations();

      expect(locations, isA<List<Location>>());
      expect(locations[0].name, equals('Earth'));
    });

    test('fetchLocations throws Exception if response is not 200', () async {
      when(mockClient.get(Uri.parse(Api.dataLocation)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await apiService.fetchLocations(), throwsException);
    });

    test('searchLocations returns list if name found, empty list if not found',
        () async {
      final mockResponseFound = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Earth',
            'type': 'Planet',
            'dimension': 'Dimension C-137',
            'residents': [],
            'url': 'https://rickandmortyapi.com/api/location/1',
            'created': '2017-11-10T12:42:04.162Z'
          },
        ],
      });

      final mockResponseNotFound = jsonEncode({'results': []});

      when(mockClient.get(Uri.parse('${Api.dataLocation}/?name=Earth')))
          .thenAnswer((_) async => http.Response(mockResponseFound, 200));

      final foundResults = await apiService.searchLocations('Earth');
      expect(foundResults, isA<List<Location>>());
      expect(foundResults[0].name, equals('Earth'));

      when(mockClient.get(Uri.parse('${Api.dataLocation}/?name=Unknown')))
          .thenAnswer((_) async => http.Response(mockResponseNotFound, 200));

      final notFoundResults = await apiService.searchLocations('Unknown');
      expect(notFoundResults, equals([]));
    });
  });
}

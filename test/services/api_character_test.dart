import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rick_and_morty_apps/services/api_character.dart';
import 'package:rick_and_morty_apps/models/character.dart';
import 'package:rick_and_morty_apps/services/api.dart';

import 'api_character_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiServiceCharacter', () {
    late MockClient mockClient;
    late ApiServiceCharacter apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiServiceCharacter(client: mockClient);
    });

    test('fetchCharacters returns list of characters if response is 200',
        () async {
      final mockResponse = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': 'Unknown',
            'gender': 'Male',
            'origin': {'name': 'Earth', 'url': ''},
            'location': {'name': 'Earth', 'url': ''},
            'image': '',
            'episode': ['https://...'],
            'url': '',
            'created': '2017-11-04T18:48:46.250Z'
          },
        ],
      });

      when(mockClient.get(Uri.parse(Api.dataCharacter)))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final characters = await apiService.fetchCharacters();

      expect(characters, isA<List<Character>>());
      expect(characters[0].name, equals('Rick Sanchez'));
    });

    test('fetchCharacters throws Exception if response is not 200', () async {
      when(mockClient.get(Uri.parse(Api.dataCharacter)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await apiService.fetchCharacters(), throwsException);
    });

    test('searchCharacters returns list if name found, empty list if not found',
        () async {
      final mockResponseFound = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': 'Unknown',
            'gender': 'Male',
            'origin': {'name': 'Earth', 'url': ''},
            'location': {'name': 'Earth', 'url': ''},
            'image': '',
            'episode': ['https://...'],
            'url': '',
            'created': '2017-11-04T18:48:46.250Z'
          },
        ],
      });

      final mockResponseNotFound = jsonEncode({'results': []});

      when(mockClient.get(Uri.parse('${Api.dataCharacter}/?name=Rick')))
          .thenAnswer((_) async => http.Response(mockResponseFound, 200));

      final foundResults = await apiService.searchCharacters('Rick');
      expect(foundResults, isA<List<Character>>());
      expect(foundResults[0].name, equals('Rick Sanchez'));

      when(mockClient.get(Uri.parse('${Api.dataCharacter}/?name=Unknown')))
          .thenAnswer((_) async => http.Response(mockResponseNotFound, 200));

      final notFoundResults = await apiService.searchCharacters('Unknown');
      expect(notFoundResults, equals([]));
    });
  });
}

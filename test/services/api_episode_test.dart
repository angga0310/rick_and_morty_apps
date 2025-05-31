import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rick_and_morty_apps/services/api_episode.dart';
import 'package:rick_and_morty_apps/models/episode.dart';
import 'package:rick_and_morty_apps/services/api.dart';

import 'api_episode_test.mocks.dart'; // file hasil build_runner

@GenerateMocks([http.Client])
void main() {
  group('ApiServiceEpisode', () {
    late MockClient mockClient;
    late ApiServiceEpisode apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiServiceEpisode(client: mockClient);
    });

    test('fetchEpisodes returns list of episodes if response is 200', () async {
      final mockResponse = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Pilot',
            'air_date': 'December 2, 2013',
            'episode': 'S01E01',
            'characters': [
              'https://rickandmortyapi.com/api/character/1',
              'https://rickandmortyapi.com/api/character/2'
            ],
            'url': 'https://rickandmortyapi.com/api/episode/1',
            'created': '2017-11-10T12:56:33.798Z'
          },
        ],
      });

      when(mockClient.get(Uri.parse(Api.dataEpisode)))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final episodes = await apiService.fetchEpisodes();

      expect(episodes, isA<List<Episode>>());
      expect(episodes[0].name, equals('Pilot'));
    });

    test('fetchEpisodes throws Exception if response is not 200', () async {
      when(mockClient.get(Uri.parse(Api.dataEpisode)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await apiService.fetchEpisodes(), throwsException);
    });

    test('searchEpisodes returns list if name found, empty list if not found',
        () async {
      final mockResponseFound = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Pilot',
            'air_date': 'December 2, 2013',
            'episode': 'S01E01',
            'characters': [],
            'url': 'https://rickandmortyapi.com/api/episode/1',
            'created': '2017-11-10T12:56:33.798Z'
          },
        ],
      });

      final mockResponseNotFound = jsonEncode({'results': []});

      when(mockClient.get(Uri.parse('${Api.dataEpisode}/?name=Pilot')))
          .thenAnswer((_) async => http.Response(mockResponseFound, 200));

      final foundResults = await apiService.searchEpisodes('Pilot');
      expect(foundResults, isA<List<Episode>>());
      expect(foundResults[0].name, equals('Pilot'));

      when(mockClient.get(Uri.parse('${Api.dataEpisode}/?name=Unknown')))
          .thenAnswer((_) async => http.Response(mockResponseNotFound, 200));

      final notFoundResults = await apiService.searchEpisodes('Unknown');
      expect(notFoundResults, equals([]));
    });
  });
}

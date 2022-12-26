import 'package:faker/faker.dart';
import 'package:flutter_clean_code/data/models/models.dart';
import 'package:flutter_clean_code/domain/entities/survey_entity.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await fetchCacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }

      return data
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

void main() {
  LocalLoadSurveys sut;
  FetchCacheStorageSpy fetchCacheStorage;
  List<Map> data;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2020-07-20T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2018-02-02T00:00:00Z',
          'didAnswer': 'true',
        }
      ];

  PostExpectation mockRequest() => when(fetchCacheStorage.fetch(any));

  void mockFetch(List<Map> list) {
    data = list;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockRequest().thenThrow(Exception());

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });
  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return a list of surveys on success', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: data[0]['id'],
        question: data[0]['question'],
        dateTime: DateTime.utc(2020, 7, 20),
        didAnswer: false,
      ),
      SurveyEntity(
        id: data[1]['id'],
        question: data[1]['question'],
        dateTime: DateTime.utc(2018, 2, 02),
        didAnswer: true,
      )
    ]);
  });

  test('Should throw UnexpectedErrorif cache is empty', () async {
    mockFetch([]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedErrorif cache is null', () async {
    mockFetch(null);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedErrorif cache is invalid', () async {
    mockFetch([
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': 'invalid date',
        'didAnswer': 'false',
      },
    ]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedErrorif cache is incomplete', () async {
    mockFetch([
      {
        'date': '2020-02-02T00:00:00Z',
        'didAnswer': 'false',
      },
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedErrorif cache is incomplete', () async {
    mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

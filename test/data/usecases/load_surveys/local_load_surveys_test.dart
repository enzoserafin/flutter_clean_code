import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/data/cache/cache.dart';
import 'package:flutter_clean_code/data/usecases/usecases.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
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

    PostExpectation mockRequest() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockRequest().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockRequest().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });
    test('Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
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
  });

  group('validate', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
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

    PostExpectation mockRequest() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockRequest().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockRequest().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid date',
          'didAnswer': 'false',
        },
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch([
        {
          'date': 'invalid date',
          'didAnswer': '2018-02-02T00:00:00Z',
        },
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetchError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<SurveyEntity> surveys;

    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 2, 2),
            didAnswer: true,
          ),
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2018, 12, 20),
            didAnswer: false,
          ),
        ];

    PostExpectation mockSaveCall() =>
        when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockFetchError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = mockSurveys();
    });

    test('Should call cacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2020-02-02T00:00:00.000Z',
          'didAnswer': 'true',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2018-12-20T00:00:00.000Z',
          'didAnswer': 'false',
        },
      ];

      await sut.save(surveys);

      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockFetchError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
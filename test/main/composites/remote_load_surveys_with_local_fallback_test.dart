import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  setUp(() {
    localSurveys = EntityFactory.makeSurveyList();
    local = LocalLoadSurveysSpy();
    local.mockLoad(localSurveys);
    remoteSurveys = EntityFactory.makeSurveyList();
    remote = RemoteLoadSurveysSpy();
    remote.mockLoad(remoteSurveys);
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote surveys', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load thorws AccessDeniedError', () async {
    remote.mockLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    remote.mockLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('Should return local surveys', () async {
    remote.mockLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {
    remote.mockLoadError(DomainError.unexpected);
    local.mockLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}

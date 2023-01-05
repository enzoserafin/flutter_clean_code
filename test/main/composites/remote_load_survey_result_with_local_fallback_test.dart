import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;

  setUp(() {
    surveyId = faker.guid.guid();
    localSurveyResult = EntityFactory.makeSurveyResult();
    local = LocalLoadSurveyResultSpy();
    local.mockLoadBySurvey(localSurveyResult);
    remoteSurveyResult = EntityFactory.makeSurveyResult();
    remote = RemoteLoadSurveyResultSpy();
    remote.mockLoadBySurvey(remoteSurveyResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteSurveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteSurveyResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError',
      () async {
    remote.mockLoadBySurveyError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localSurveyResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    local.mockLoadBySurveyError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}

import 'package:flutter_clean_code/data/models/models.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({@required this.cacheStorage});
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      if (data?.isEmpty != false) {
        throw Exception();
      }

      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(data).toEntity();
    } on Exception {
      cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save(
    SurveyResultEntity surveyResult,
  ) async {
    try {
      final json = LocalSurveyResultModel.fromEntity(surveyResult).toJson();
      await cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}', value: json);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

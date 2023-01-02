import 'package:flutter_clean_code/data/models/models.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
// import '../../models/models.dart';

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

  // Future<void> validate() async {
  //   try {
  //     final data = await cacheStorage.fetch('surveys');
  //     _mapToEntity(data);
  //   } on Exception {
  //     cacheStorage.delete('surveys');
  //   }
  // }

  // Future<void> save(List<SurveyEntity> surveys) async {
  //   try {
  //     await cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
  //   } catch (e) {
  //     throw DomainError.unexpected;
  //   }
  // }

  // List<SurveyEntity> _mapToEntity(dynamic list) => list
  //     .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
  //     .toList();

  // List<Map> _mapToJson(List<SurveyEntity> list) => list
  //     .map((entity) => LocalSurveyModel.fromEntity(entity).toJson())
  //     .toList();
}

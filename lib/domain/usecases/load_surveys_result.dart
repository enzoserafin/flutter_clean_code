import '../entities/entities.dart';

abstract class LoadSurveysResult {
  Future<SurveysResultEntity> loadBySurvey({String surveyId});
}

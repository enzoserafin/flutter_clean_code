import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/domain/usecases/usecases.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity serveyResult) =>
      this.mockLoadBySurveyCall().thenAnswer((_) async => serveyResult);
  void mockLoadBySurveyError(DomainError error) =>
      this.mockLoadBySurveyCall().thenThrow(error);
}

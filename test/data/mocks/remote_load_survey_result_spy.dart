import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/data/usecases/usecases.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity serveyResult) =>
      this.mockLoadBySurveyCall().thenAnswer((_) async => serveyResult);
  void mockLoadBySurveyError(DomainError error) =>
      this.mockLoadBySurveyCall().thenThrow(error);
}

import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/data/usecases/usecases.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    this.mockValidate();
    this.mockSave();
  }
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity serveyResult) =>
      this.mockLoadBySurveyCall().thenAnswer((_) async => serveyResult);
  void mockLoadBySurveyError() =>
      this.mockLoadBySurveyCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate(any()));
  void mockValidate() => this.mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => this.mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
}

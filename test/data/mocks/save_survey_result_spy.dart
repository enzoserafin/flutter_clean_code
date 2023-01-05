import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/usecases/usecases.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveServeyResultCall() =>
      when(() => this.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) =>
      this.mockSaveServeyResultCall().thenAnswer((_) async => data);

  void mockSaveSurveyResultError(DomainError error) =>
      this.mockSaveServeyResultCall().thenThrow(error);
}

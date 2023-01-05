import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/data/usecases/usecases.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {
  LocalLoadSurveysSpy() {
    this.mockValidate();
    this.mockSave();
  }
  When mockLoadCall() => when(() => this.load());
  void mockLoad(List<SurveyEntity> serveys) =>
      this.mockLoadCall().thenAnswer((_) async => serveys);
  void mockLoadError() => this.mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate());
  void mockValidate() => this.mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => this.mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.save(any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
}

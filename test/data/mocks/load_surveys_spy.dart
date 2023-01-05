import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/usecases/usecases.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {
  When mockLoadCall() => when(() => this.load());
  void mockLoad(List<SurveyEntity> surveys) =>
      this.mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError(DomainError error) => this.mockLoadCall().thenThrow(error);
}

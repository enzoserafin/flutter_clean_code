import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final surveryResultController = StreamController<SurveyResultViewModel?>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.save(answer: any(named: 'answer')))
        .thenAnswer((_) async => _);
    when(() => this.surveyResultStream)
        .thenAnswer((_) => surveryResultController.stream);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void emitSurveyResult(SurveyResultViewModel? data) =>
      surveryResultController.add(data);
  void emitSurveyResultError(String error) =>
      surveryResultController.addError(error);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSessionExpired([bool expired = true]) =>
      isSessionExpiredController.add(expired);

  void dispose() {
    surveryResultController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
  }
}

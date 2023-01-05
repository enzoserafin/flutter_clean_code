import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final surverysController = StreamController<List<SurveyViewModel>>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final navigateToController = StreamController<String?>();

  SurveysPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.surveysStream).thenAnswer((_) => surverysController.stream);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void emitSurveys(List<SurveyViewModel> data) => surverysController.add(data);
  void emitSurveysError(String error) => surverysController.addError(error);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSessionExpired([bool expired = true]) =>
      isSessionExpiredController.add(expired);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    surverysController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
    navigateToController.close();
  }
}

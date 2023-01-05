import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  final navigateToController = StreamController<String?>();

  SplashPresenterSpy() {
    when(() => this
            .checkAccount(durationInSeconds: any(named: 'durationInSeconds')))
        .thenAnswer((_) async => _);

    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    navigateToController.close();
  }
}

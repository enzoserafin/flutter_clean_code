import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:flutter_clean_code/domain/usecases/usecases.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    await loadSurveys.load();
  }
}

void main() {
  test('Should call LoadSureveys on lodaData', () async {
    final loadSurveys = LoadSurveysSpy();
    final sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    sut.loadData();

    verify(loadSurveys.load()).called(1);
  });
}

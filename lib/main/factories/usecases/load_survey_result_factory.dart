import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
// import '../../composites/composites.dart';
import '../factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) =>
    RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys_result/$surveyId/results'),
    );

// LoadSurveys makeLocalLoadSurveys() =>
//     LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

// LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
//     RemoteLoadSurveysWithLocalFallback(
//       remote: makeRemoteLoadSurveys(),
//       local: makeLocalLoadSurveys(),
//     );

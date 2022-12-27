import 'package:meta/meta.dart';

import './entities.dart';

class SurveysResultEntity {
  final String surveyId;
  final String question;
  final List<SurveysAnswerEntity> answers;

  SurveysResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });
}

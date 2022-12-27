import 'package:meta/meta.dart';

class SurveysAnswerEntity {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  SurveysAnswerEntity({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });
}

import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({@required String field, @required String value}) {
    String error;
    //Filter dentro da condição do for apenas para rodar o validator de um único campo.
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      print(error);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}

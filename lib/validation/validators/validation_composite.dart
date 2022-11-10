import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  ValidationError validate({@required String field, @required String value}) {
    ValidationError error;
    //Filter dentro da condição do for apenas para rodar o validator de um único campo.
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}

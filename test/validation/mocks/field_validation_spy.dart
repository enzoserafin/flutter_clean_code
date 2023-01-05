import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/presentation/protocols/protocols.dart';
import 'package:flutter_clean_code/validation/protocols/protocols.dart';

class FieldValidationSpy extends Mock implements FieldValidation {
  FieldValidationSpy() {
    this.mockValidation();
    this.mockFieldName('any_field');
  }
  When mockValidationCall() => when(() => this.validate(any()));
  void mockValidation() => this.mockValidationCall().thenReturn(null);
  void mockValidationError(ValidationError error) =>
      this.mockValidationCall().thenReturn(error);

  void mockFieldName(String fieldName) =>
      when(() => this.field).thenReturn(fieldName);
}

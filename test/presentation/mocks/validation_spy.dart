import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_code/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    this.mockValidation();
  }

  When mockValidationCall(String? field) => when(() => this.validate(
      field: field ?? any(named: 'field'), input: any(named: 'input')));
  void mockValidation({String? field}) =>
      this.mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) =>
      this.mockValidationCall(field).thenReturn(value);
}

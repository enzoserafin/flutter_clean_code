import 'package:test/test.dart';

import 'package:flutter_clean_code/presentation/protocols/validation.dart';

import 'package:flutter_clean_code/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return error if values are not euqal', () {
    final formDate = {'any_field': 'any_value', 'other_field': 'other_value'};

    expect(sut.validate(formDate), ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formDate = {'any_field': 'any_value', 'other_field': 'any_value'};

    expect(sut.validate(formDate), null);
  });
}

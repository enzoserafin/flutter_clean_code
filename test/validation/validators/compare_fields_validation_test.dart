// import 'package:faker/faker.dart';
// import 'package:flutter_clean_code/validation/protocols/field_validation.dart';

import 'package:test/test.dart';

import 'package:flutter_clean_code/presentation/protocols/validation.dart';

import 'package:flutter_clean_code/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is not euqal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}

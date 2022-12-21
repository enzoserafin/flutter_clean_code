import 'package:test/test.dart';

import 'package:flutter_clean_code/validation/validators/validators.dart';
import 'package:flutter_clean_code/main/factories/factories.dart';

void main() {
  test('Should return the corret validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
    ]);
  });
}

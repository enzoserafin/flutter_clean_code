import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:flutter_clean_code/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_value');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate(faker.internet.email()), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate(faker.person.name()), 'Campo inválido');
  });
}

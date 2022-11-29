import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_code/ui/helpers/helpers.dart';

import 'package:flutter_clean_code/presentation/presenters/presenters.dart';
import 'package:flutter_clean_code/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  String email;
  String name;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    //Verificar se a stream recebe o valor de erro 1 vez e após a emissão de um novo erro igual ao anteriro
    // a stream não publica nada. Para isso usamos o .distinct() no getter da stream.
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Verificar se a stream recebe o valor de erro 1 vez e após a emissão de um novo erro igual ao anteriro
    // a stream não publica nada. Para isso usamos o .distinct() no getter da stream.
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    sut.validateName(name);

    verify(validation.validate(field: 'name', value: name)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    //Verificar se a stream recebe o valor de erro 1 vez e após a emissão de um novo erro igual ao anteriro
    // a stream não publica nada. Para isso usamos o .distinct() no getter da stream.
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Verificar se a stream recebe o valor de erro 1 vez e após a emissão de um novo erro igual ao anteriro
    // a stream não publica nada. Para isso usamos o .distinct() no getter da stream.
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    //Verificar se a stream recebe o valor de erro 1 vez e após a emissão de um novo erro igual ao anteriro
    // a stream não publica nada. Para isso usamos o .distinct() no getter da stream.
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Verificar se a stream recebe o valor de erro 1 vez e após a emissão de um novo erro igual ao anteriro
    // a stream não publica nada. Para isso usamos o .distinct() no getter da stream.
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
}

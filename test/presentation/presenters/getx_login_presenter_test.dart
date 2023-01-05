import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_code/ui/helpers/helpers.dart';

import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/usecases/usecases.dart';

import 'package:flutter_clean_code/presentation/presenters/presenters.dart';
import 'package:flutter_clean_code/presentation/protocols/protocols.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late ValidationSpy validation;
  late String email;
  late String password;
  late AccountEntity account;

  setUp(() {
    account = EntityFactory.makeAccount();
    email = faker.internet.email();
    password = faker.internet.password();
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    authentication.mockAuthentication(account);
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    final formData = {'email': email, 'password': null};

    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', input: formData))
        .called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

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
    validation.mockValidationError(value: ValidationError.requiredField);

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

  test('Should call Validation with correct password', () {
    final formData = {'email': null, 'password': password};

    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', input: formData))
        .called(1);
  });

  test('Should emit requiredFieldError if password is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

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

  test('Should disable form button if any field is invalid', () {
    validation.mockValidationError(
        field: 'email', value: ValidationError.invalidField);

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should enable form button if all field are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    // Aula 23
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should call saveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on Athentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));
    expectLater(sut.mainErrorStream, emits(null));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

    await sut.auth();
  });

  test('Should emit correct events on Unexpected', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should call go to SignUpPage on link click', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/signup')));
    sut.goToSignUp();
  });
}

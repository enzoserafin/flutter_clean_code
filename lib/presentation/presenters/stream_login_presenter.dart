import 'dart:async';
import 'package:meta/meta.dart';

import '../../domain/usecases/authentication.dart';

import '../protocols/protocols.dart';

class LoginState {
  String email;
  String password;
  String emailError;
  String passwordError;
  bool isLoading = false;

  // Deixando o isFormValid apenas como getter (sem variável) nos economizamos memória
  // há apenas uma computação.
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamingLoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  // Caso a stream receba o mesmo valor que o anterior ela não publica nova emissão de erro.
  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  StreamingLoginPresenter(
      {@required this.validation, @required this.authentication});

  void update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    update();
    await authentication.auth(
        AuthenticationParams(email: _state.email, secret: _state.password));
    _state.isLoading = false;
    update();
  }
}

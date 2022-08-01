import 'dart:async';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class LoginState {
  String emailError;
  String passwordError;

  // Deixando o isFormValid apenas como getter (sem variável) nos economizamos memória
  // há apenas uma computação.
  bool get isFormValid => false;
}

class StreamingLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  // Caso a stream receba o mesmo valor que o anterior ela não publica nova emissão de erro.
  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamingLoginPresenter({@required this.validation});

  void update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    update();
  }

  void validatePassword(String password) {
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    update();
  }
}

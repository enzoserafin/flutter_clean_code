import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/errors/ui_errors.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, UIErrorManager, NavigationManager, FormManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;
  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);

  // Caso a stream receba o mesmo valor que o anterior ela não publica nova emissão de erro.
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  void _validateForm() {
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  UIError? _validateField(String field) {
    final formData = {'email': _email, 'password': _password};

    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  void goToSignUp() {
    navigateTo = '/signup';
  }
}

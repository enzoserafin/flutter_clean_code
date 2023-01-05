import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => this.auth(any()));
  void mockAuthentication(AccountEntity data) =>
      this.mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) =>
      this.mockAuthenticationCall().thenThrow(error);
}

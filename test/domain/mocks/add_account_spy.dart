import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_code/domain/entities/entities.dart';
import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/usecases/usecases.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => this.add(any()));
  void mockAddAccount(AccountEntity data) =>
      this.mockAddAccountCall().thenAnswer((_) async => data);
  void mockAddAccountError(DomainError error) =>
      this.mockAddAccountCall().thenThrow(error);
}

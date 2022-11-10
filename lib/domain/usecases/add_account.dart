import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart'; // Para poder utilizar @required.

import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParamas params);
}

class AddAccountParamas extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AddAccountParamas({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [name, email, password, passwordConfirmation];
}

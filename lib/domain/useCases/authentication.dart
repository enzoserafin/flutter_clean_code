import 'package:meta/meta.dart'; // Para poder utilizar @required.

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    @required String email,
    @required String password,
  });
}

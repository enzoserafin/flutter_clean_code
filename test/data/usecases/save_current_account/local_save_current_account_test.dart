import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_code/domain/helpers/helpers.dart';
import 'package:flutter_clean_code/domain/entities/entities.dart';

import 'package:flutter_clean_code/data/usecases/usecases.dart';

import '../../mocks/mocks.dart';

void main() {
  late LocalSaveCurrentAccount sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late AccountEntity account;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: secureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with corret values', () async {
    sut.save(account);

    verify(() => secureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockSaveError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}

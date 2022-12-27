import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../../factories/factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    decoratee: makeHttpAdapter());
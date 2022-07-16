import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart'; // Para poder utilizar @required.

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({@required String url}) {}
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call HttpClient with correct URL', () async {
    // Arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    //sut - system under test
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // Act
    await sut.auth();

    // Assert
    verify(httpClient.request(url: url));
  });
}

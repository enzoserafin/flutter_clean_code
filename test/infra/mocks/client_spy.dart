import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    this.mockPost(200);
    this.mockPut(200);
    this.mockGet(200);
  }

  When mockPostCall() => when(() => this
      .post(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPost(int statusCode, {String body = '{"any_key":"any:_value"}'}) =>
      this.mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPostError() => this.mockPostCall().thenThrow(Exception());

  When mockPutCall() => when(() => this
      .put(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPut(int statusCode, {String body = '{"any_key":"any:_value"}'}) =>
      this.mockPutCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPutError() => this.mockPutCall().thenThrow(Exception());

  When mockGetCall() =>
      when(() => this.get(any(), headers: any(named: 'headers')));
  void mockGet(int statusCode, {String body = '{"any_key":"any:_value"}'}) =>
      this.mockGetCall().thenAnswer((_) async => Response(body, statusCode));
  void mockGetError() => this.mockGetCall().thenThrow(Exception());
}

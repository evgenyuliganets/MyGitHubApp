import 'dart:async';
import 'package:github/github.dart';
import 'package:meta/meta.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated,error }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    @required String username,
    @required String password,
    @required bool isUser,
  })
  async {
      assert(username != null);
      assert(password != null);
      assert(isUser != false);
      await Future.delayed(
        const Duration(milliseconds: 300),
            () => _controller.add(AuthenticationStatus.authenticated),
      );
    }


  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

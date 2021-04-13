import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/authentication/authentication.dart';
import 'package:my_github_app/home/home.dart';
import 'package:my_github_app/login/login.dart';
import 'package:my_github_app/splash/splash.dart';
import 'package:user_repository/user_repository.dart';
import 'database/users_repository.dart';
import 'home/data_repository/data_repository.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final AuthenticationRepository _authenticationRepository= AuthenticationRepository();
  final _userRepository = UsersRepository();
  LoginEvent loginEvent;
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return  BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            try {
              await _authenticationRepository.logIn(isUser: true,
                  password: await _userRepository.getAllUser().then((value) =>
                      value.first.password.toString()).timeout(Duration(seconds: 2),onTimeout: ()=>throw UserNotFoundException()),
                  username: await _userRepository.getAllUser().then((value) =>
                      value.first.username.toString()).timeout(Duration(seconds: 2),onTimeout: ()=>throw UserNotFoundException())).timeout(Duration(seconds: 2),onTimeout: ()=>throw UserNotFoundException());
              User user=User('1');
                state=AuthenticationState.authenticated(user);
            }
            catch(Exception){
              print(UserNotFoundException());}
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                      (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                      (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
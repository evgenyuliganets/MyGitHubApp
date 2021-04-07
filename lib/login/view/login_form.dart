import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
        child: Container(
         decoration: BoxDecoration(
          color: Color(0xfff6f8fa),
           borderRadius: BorderRadius.circular(15.0),
          boxShadow: <BoxShadow>[
          BoxShadow(
          color: Colors.black54,
          offset: Offset(1.0, 1.0),
          spreadRadius: 0.2,
           blurRadius: 5.0,
          )
          ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LogoInput(),
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(5)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(10)),
            _LoginButton(),
          ],
        ),
      ),
    ),
    ),
    );
  }
}
class _LogoInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(20.0),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        Image(image:
        AssetImage('assets/logo.png'),
        width: 60,
          height: 60,),
        ]
        )
        );
      }
  }
class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
              focusColor: Color(0xffe8f0fe),
              fillColor: Color(0xffe1e4e8),
              icon: Icon(Icons.login),
              hintText: 'Enter your GitHub username',
              labelText: 'Username',
            errorText: state.username.invalid ? 'Invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText:true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_rounded),
              hintText: 'Enter your password',
              labelText: 'Password',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
          key: const Key('loginForm_continue_raisedButton'),
          child: const Text('Login'),
          onPressed: state.status.isValidated
              ? () {
            context.read<LoginBloc>().add(const LoginSubmitted());
          }
              : null,
        );
      },
    );
  }
}
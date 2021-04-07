import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';

class HomeTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                onSubmitted: (value) =>
                    submitUserName(context, _controller.text),
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search User Here',
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void submitUserName(BuildContext context, String userName) {
    final profileBloc = context.bloc<ProfileBloc>();
    profileBloc.add(GetUser(userName));
  }

}

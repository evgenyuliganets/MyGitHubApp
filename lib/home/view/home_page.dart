import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/view/profiles_short.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';


class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }
}

class _HomePageState extends State<HomePage> {
  bool toggle = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ProfileBloc(DataRepository()),
        child: GitProfiles(),
      ),

    );
  }
}
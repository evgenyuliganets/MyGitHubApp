import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'dart:async';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'GitHubApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController popupController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var sing="Signing In...";
  @override
  void initState() {
    super.initState();
  }
  Future<void> main() async {
    try{sing="Signing In...";
    var github = GitHub(auth: Authentication.basic(usernameController.text, passwordController.text));

    bool isSigned = await github.auth.isBasic;
    if (isSigned==true){
      Repository repo = await github.repositories.getRepository(RepositorySlug(github.auth.username, 'blog'));
      showMessage(repo.language);
    }
    }on Exception catch(_){
      return throw Error;
    }

  }
  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
      new FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Flutter Login UI'),
        centerTitle: true,
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                          spreadRadius: 0.2,
                          blurRadius: 5.0,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlutterLogo(
                          size: 60.0,
                        ),
                        SizedBox(height: 30.0),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person_pin),
                              hintText: 'Enter your name',
                              labelText: 'Username'),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'Enter your password',
                              labelText: 'Password'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () { _scaffoldKey.currentState.showSnackBar(
                                      new SnackBar(duration: new Duration(seconds: 3), content:
                                      new Row(
                                        children: <Widget>[
                                      new CircularProgressIndicator(),
                                          new Text(sing)
                                        ],
                                      ),
                                      ));
                                      main()
                                      .catchError((Error)=> showMessage("Wrong username or password"));
                                      main()
                                      .whenComplete(() => null);
                                  },
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Text(
                                    'Login',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: RaisedButton(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  onPressed: () {},
                                  child: Text('Clear'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}

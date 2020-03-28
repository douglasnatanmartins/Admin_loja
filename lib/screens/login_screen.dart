import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/login_bloc.dart';
import 'package:gerenciadorloja/widgets/input_field.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text("Erro"),
                  content: Card(
                    child: Text("Voce não possui os privilégios necessários"),
                  )));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: StreamBuilder<LoginState>(
            stream: _loginBloc.outState,
            initialData: LoginState.LOADING,
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case LoginState.LOADING:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.cyanAccent),
                    ),
                  );
                case LoginState.FAIL:
                case LoginState.SUCCESS:
                case LoginState.IDLE:
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(),
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 150,
                                height: 250,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "images/online-store2.jpg"),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              /* Icon(
                        Icons.local_grocery_store,
                        color: Colors.purple[600],
                        size: 160,
                      ),*/
                              InputField(
                                icon: Icons.person_outline,
                                hint: "Usuario",
                                obscure: false,
                                stream: _loginBloc.outEmail,
                                onChengad: _loginBloc.changeEmail,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InputField(
                                icon: Icons.lock_outline,
                                hint: "Senha",
                                obscure: true,
                                stream: _loginBloc.outPassword,
                                onChengad: _loginBloc.changePassword,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              StreamBuilder<bool>(
                                  stream: _loginBloc.outSubmitValid,
                                  builder: (context, snapshot) {
                                    return SizedBox(
                                      child: RaisedButton(
                                        padding: EdgeInsets.only(top: 5, bottom: 5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        color: Colors.cyanAccent.withAlpha(130),
                                        disabledColor:
                                            Colors.cyanAccent.withAlpha(80),
                                        child: Text(
                                          "Entrar",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        onPressed: snapshot.hasData
                                            ? _loginBloc.submit
                                            : null,
                                        textColor: Colors.white,
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
              }
            }));
  }
}

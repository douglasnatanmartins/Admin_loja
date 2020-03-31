import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/login_bloc.dart';
import 'package:gerenciadorloja/screens/login_screen.dart';

class SettingsTab extends StatelessWidget {

  final _loginBloc = LoginBloc();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Column(
          children: <Widget>[
            SafeArea(
              child: Text(
                  "Configurações",
              ),
            ),
          ],
        )
      ),
      body: Card(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[

                  Icon(Icons.exit_to_app, size: 25, color: Colors.purple,),
                  FlatButton(
                    child: Text("Sair", style: TextStyle(
                        fontSize: 25,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500
                    ),),
                    onPressed: (){
                        _loginBloc.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()
                        ));
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[

                  Icon(Icons.library_books, size: 25, color: Colors.purple,),
                  FlatButton(
                    child: Text("", style: TextStyle(
                        fontSize: 25,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500
                    ),),
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                  Divider(),
                ],
              )

            ],
          ),
        ),
      )
    );
  }
}

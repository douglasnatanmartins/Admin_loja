import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/login_bloc.dart';
import 'package:gerenciadorloja/screens/login_screen.dart';
import 'package:gerenciadorloja/tabs/novidades.dart';

class SettingsTab extends StatelessWidget {

  final _loginBloc = LoginBloc();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(
          "Configurações",
        ),
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
              Divider(color: Colors.grey[500],),
              Row(
                children: <Widget>[

                  Icon(Icons.playlist_add, size: 25, color: Colors.purple,),
                  FlatButton(
                    child: Text("Novidades", style: TextStyle(
                        fontSize: 23,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500
                    ),),
                    onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NovidadesTab()
                        ));
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

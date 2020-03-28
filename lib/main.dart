import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Flutte",
        theme: ThemeData(primaryColor: Colors.cyan[700]),
        debugShowCheckedModeBanner: false,
        home: LoginScreen()
    );
  }
}

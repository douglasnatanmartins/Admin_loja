import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gerenciadorloja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState{IDLE, LOADING, SUCCESS, FAIL}

class LoginBloc extends BlocBase with LoginValidators {


  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String>get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String>get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<LoginState>get outState => _stateController.stream;

  Stream<bool> get outSubmitValid =>Observable.combineLatest2(
      outEmail, outPassword, (a,b) => true
  );



  Function(String)get changeEmail => _emailController.sink.add;
  Function(String)get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;

  LoginBloc(){
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if(user == null){
        FirebaseAuth.instance.currentUser();
      }
      if(user != null){
        if(await verifiPrivileges(user)){
          _stateController.add(LoginState.SUCCESS);
          print("logou!");
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      }else {
        _stateController.add(LoginState.IDLE);
      }
    }
    );
  }

  void signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  void submit(){
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((erro){
       print(erro);
      _stateController.add(LoginState.FAIL);
    });
  }

  Future<bool> verifiPrivileges(FirebaseUser user) async {
    return await Firestore.instance.collection("admins").document(user.uid).get().then((doc){
      if(doc.data != null){
        return true;
      } else {
        return false;
      }
    }).catchError((erro){
      print(erro);
      return false;
    });
  }

  @override
  void dispose() {
   _emailController.close();
   _passwordController.close();
   _stateController.close();


   _streamSubscription.cancel();
  }
}
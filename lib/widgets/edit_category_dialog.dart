import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/category_bloc.dart';
import 'package:gerenciadorloja/widgets/image_source_sheet.dart';
import 'package:gerenciadorloja/widgets/input_field.dart';

class EditCategoryDialog extends StatefulWidget {

  final DocumentSnapshot category;


  EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState(
    category: category,
  );
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryBloc _categoryBloc;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController  _controller;


  _EditCategoryDialogState({DocumentSnapshot category}) :
        _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(text: category != null ?
        category.data["title"] : ""
        );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body:Dialog(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ImageSourceSheet(
                          onImageSelected: (image){
                            Navigator.of(context).pop();
                            _categoryBloc.setImage(image);
                          },
                        )
                    );
                  },
                  child: StreamBuilder(
                      stream: _categoryBloc.outImage,
                      builder: (context, snapshot) {
                        if(snapshot.data != null)
                          return CircleAvatar(
                            child: snapshot.data is File ?
                            Image.file(snapshot.data, fit: BoxFit.cover,) :
                            Image.network(snapshot.data, fit: BoxFit.cover,),
                            backgroundColor: Colors.transparent,
                          );
                        else return Icon(Icons.image);
                      }
                  ),
                ),
                title: StreamBuilder<String>(
                    stream: _categoryBloc.outTitle,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: _categoryBloc.setTitle,
                        controller: _controller,
                        decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                        ),
                      );
                    }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder<bool>(
                      stream: _categoryBloc.outDelete,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) return Container();
                        return FlatButton(
                          child: Text(
                            "Excluir",
                          ),
                          textColor: Colors.red,
                          onPressed: snapshot.data ? (){
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    content: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "Deseja Excluir a Categoria con todos os Produtos",
                                            style: TextStyle(
                                                color: Colors.red[800],
                                                fontWeight:   FontWeight.bold,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 12,),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              RaisedButton(
                                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4)),
                                                color: Colors.red,
                                                onPressed: () {
                                                  _categoryBloc.delete();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Sim, EXCLUIR",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 12
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 35,),
                                              RaisedButton(
                                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4)),
                                                color: Colors.green,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Não",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 16
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ])));
                          }:null,
                        );
                      }
                  ),
                  StreamBuilder<bool>(
                      stream: _categoryBloc.submitValid,
                      builder: (context, snapshot) {
                        return FlatButton(
                          child: Text(
                            "Salvar",
                          ),
                          textColor: Colors.green[700],
                          onPressed: snapshot.hasData ? () async {
                            saveProduct();
                            await _categoryBloc.saveData();
                            Navigator.of(context).pop();
                          } : null,
                        );
                      }
                  ),
                ],
              )
            ],
          ),
        ),
      ) ,
    );
  }
    void saveProduct(){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "SalvandoProduto...", style: TextStyle(
          color: Colors.white
        ),
        ),
        duration: Duration(minutes: 1),
      ));
    }
}


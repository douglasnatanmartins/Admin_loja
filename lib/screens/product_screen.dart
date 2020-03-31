import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/products_bloc.dart';
import 'package:gerenciadorloja/validators/product_validator.dart';
import 'package:gerenciadorloja/widgets/image_widget.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final ProductBloc _productBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[300]));
    }

    final _fildStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: StreamBuilder<bool>(
          stream: _productBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
          }
        ),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context , snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: snapshot.data ? null : (){
                          _productBloc.deleteProduct();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data ? null : saveProduct,
              );
            }
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text(
                        "Imagens",
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                          initialValue: snapshot.data["title"],
                          style: _fildStyle,
                          decoration: _buildDecoration("Titulo"),
                          onSaved: _productBloc.saveTitle,
                          validator: validateTitle),
                      TextFormField(
                          initialValue: snapshot.data["desc"],
                          style: _fildStyle,
                          maxLines: 6,
                          decoration: _buildDecoration("Descrição"),
                          onSaved: _productBloc.saveDescription,
                          validator: validateDescription),
                      TextFormField(
                          initialValue: snapshot.data["price"]?.toStringAsFixed(2),
                          style: _fildStyle,
                          decoration: _buildDecoration("Preço"),
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                          onSaved: _productBloc.savePrice,
                          validator: validatePrice),
                      TextFormField(
                          initialValue: snapshot.data["stock"],
                          style: _fildStyle,
                          decoration: _buildDecoration("Stock"),
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                          onSaved: _productBloc.saveStock,
                          validator: validateStock),
                      TextFormField(
                          initialValue: snapshot.data["priceAnterior"],
                          style: _fildStyle,
                          decoration: _buildDecoration("Preço Anterior"),
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                          onSaved: _productBloc.savePriceAnterior,
                          validator: (t) {}),
                      TextFormField(
                          initialValue: snapshot.data["unidadMedida"],
                          style: _fildStyle,
                          decoration: _buildDecoration("Unidade Medida Kg"),
                          onSaved: _productBloc.saveUnidadeMedida,
                          validator: validateUnidadeMedida),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }
          ),
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando Producto...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.purple,
      ));
      bool success = await _productBloc.saveProduct();
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(success ? "Producto Salvo" : "Erro ao Salvar Produto!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.redAccent,
      ));

    }
  }
}

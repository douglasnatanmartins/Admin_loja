import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/products_bloc.dart';
import 'package:gerenciadorloja/widgets/image_widget.dart';

class ProductScreen extends StatefulWidget {

  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductBloc _productBloc;
  final _formKey = GlobalKey<FormState>();

  _ProductScreenState(String categoryId, DocumentSnapshot product) :
        _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.purple
          )
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[300]
        )
      );
    }


    final _fildStyle = TextStyle(
      color: Colors.white,
      fontSize: 16
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Criar Produto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){

            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
          stream: _productBloc.outData,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();
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
                  onSaved: (l){

                  },
                  validator: (l){},
                ),
                TextFormField(
                  initialValue: snapshot.data["title"],
                  style: _fildStyle,
                  decoration: _buildDecoration("Titulo"),
                  onSaved: (t){},
                  validator: (t){}
                ),
                TextFormField(
                    initialValue: snapshot.data["desc"],
                    style: _fildStyle,
                    maxLines: 6,
                    decoration: _buildDecoration("Descrição"),
                    onSaved: (t){},
                    validator: (t){}
                ),
                TextFormField(
                    initialValue: snapshot.data["price"]?.toStringAsFixed(2),
                    style: _fildStyle,
                    decoration: _buildDecoration("Preço"),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onSaved: (t){},
                    validator: (t){}
                ),
                TextFormField(
                    initialValue: snapshot.data["stock"],
                    style: _fildStyle,
                    decoration: _buildDecoration("Stock"),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onSaved: (t){},
                    validator: (t){}
                ),
                TextFormField(
                    initialValue: snapshot.data["priceAnterior"],
                    style: _fildStyle,
                    decoration: _buildDecoration("Preço Anterior"),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onSaved: (t){},
                    validator: (t){}
                ),
                TextFormField(
                    initialValue: snapshot.data["unidadMedida"],
                    style: _fildStyle,
                    decoration: _buildDecoration("Unidade Medida Kg"),
                    onSaved: (t){},
                    validator: (t){}
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

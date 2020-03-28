import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase{

  final _dataController = BehaviorSubject<Map>();

  Stream<Map> get outData => _dataController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}){
    if(product != null){
      unsavedData = Map.of(product.data);  //clona os dados do produto
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["sizes"] = List.of(product.data["sizes"]);

    } else {
      unsavedData = {
        "title": null, "desc": null, "price": null, "images": [], "sizes": [],
        "stock": null, "unidadMedida": null, "marca": null
      };
    }
    _dataController.add(unsavedData);
  }

  @override
  void dispose() {

    _dataController.close();

  }
}
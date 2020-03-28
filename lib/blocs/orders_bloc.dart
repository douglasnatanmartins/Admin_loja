 import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc extends BlocBase {

  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  List<DocumentSnapshot> _orders = [];

  Firestore _firestore = Firestore.instance;

  OrdersBloc(){
    _addOrdersListener();
  }
  void _addOrdersListener(){
    _firestore.collection("orders").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){
          String oid = change.document.documentID;
          _orders.sort((a,b) => a.documentID.compareTo(b.documentID));

          switch(change.type){
            case DocumentChangeType.added:
              _orders.add(change.document);
              break;
            case DocumentChangeType.modified:
             // int i = 0;
             // int index = 0;
              _orders.removeWhere((order) => order.documentID == oid);
              _orders.add(change.document);
              //_orders.removeWhere((order){
               // if(order.documentID == oid){
                 // index = 1;
                  //return true;
                //} else {
                 // ++i;
                  //return false;
               // }
             // });
             // _orders.insert(index, change.document);

              break;
            case DocumentChangeType.removed:
              _orders.retainWhere((order) => order.documentID == oid);
              break;
          }
      });

      _ordersController.add(_orders);
    });

  }

  @override
  void dispose() {

    _ordersController.close();

  }


}
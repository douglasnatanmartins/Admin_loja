import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria {READY_FIRST, READY_LAST, NONE}

class OrdersBloc extends BlocBase {

  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _orders = [];

  SortCriteria _criteria;

  OrdersBloc(){
    _addOrdersListener();
  }

  void _addOrdersListener(){
    _orders.sort((a, b) => a.documentID.compareTo(b.documentID));
    _firestore.collection("orders").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){
        String oid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            int i = 0;
            int index = 0;
           // _orders.removeWhere((order) => order.documentID == oid);
           // _orders.add(change.document);
            _orders.removeWhere((order){
              if (order.documentID == oid){
                index = i;
                return true;
              } else {
                ++i;
                return false;
              }
            });
            _orders.insert(index, change.document);
            _criteria = SortCriteria.NONE;
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == oid);
            break;
        }
      });

      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria){
    _criteria = criteria;

    _sort();
  }

  void _sort(){
    switch(_criteria){
      case SortCriteria.READY_FIRST:
        _orders.sort((a,b){
          int sa = a.data["status"];
          int sb = b.data["status"];

          if(sa < sb) return 1;
          else if(sa > sb) return -1;
          else return 0;
        });
        break;
      case SortCriteria.READY_LAST:
        _orders.sort((a,b){
          int sa = a.data["status"];
          int sb = b.data["status"];

          if(sa > sb) return 1;
          else if(sa < sb) return -1;
          else return 0;
        });
        break;
      case SortCriteria.NONE:
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
  }

}
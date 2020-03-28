import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order);

  final states = [
    "",
    "Em Preparação",
    "Em Transporte",
    "Aguardando Entrega",
    "Entregue",
    "Cancelado"
  ];

  @override
  Widget build(BuildContext context) {
    var _text2 = Text(
      "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)}  -  "
          "${states[order.data["status"]]}",
      style: TextStyle(
        color: order.data["status"]!= 5
            ? Colors.red
            : Colors.red,
        fontWeight: order.data["status"] != 5
            ? FontWeight.bold
            : FontWeight.bold,
        fontSize: order.data["status"] != 5
            ? 14
            : 18,
      ),
    );
    var _text = Text(
      "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)}  -  "
          "${states[order.data["status"]]}",
      style: TextStyle(
        color: order.data["status"]!= 4
            ? Colors.deepPurple[700]
            : Colors.green[600],
        fontWeight: order.data["status"] != 4
            ? FontWeight.bold
            : FontWeight.bold,
        fontSize: order.data["status"] != 4
            ? 14
            : 18,
      ),
    );



    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] != 5,
          title: order.data["status"] != 5 ? _text : _text2,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data["products"].map<Widget>((p) {
                      return ListTile(
                        title: Text(
                          p["products"]["title"],
                        ),
                        subtitle: Text(
                          p["category"] + "/" + p["pid"],
                        ),
                        trailing: Text(
                          p["quantity"].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: order.data["status"] != 5 ? Colors.red : Colors.grey[700],
                        onPressed: order.data["status"] < 4 ? () {
                          order.reference.updateData({"status": 5});
                        } : null,

                          /*Firestore.instance.collection("users").document(order["clientId"])
                              .collection("orders").document(order.documentID).delete();
                          order.reference.delete();*/

                        textColor: Colors.white,
                        child: Text(order.data["status"] >= 4 ? "": "Cancelar"),
                      ),

                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: order.data["status"] >= 5 ? Colors.yellow[800] : Colors.blue[600],
                        onPressed: order.data["status"] > 1 ? () {
                          order.reference.updateData({"status": order.data["status"] - 1});
                        } : null,
                        textColor: Colors.white,
                        child: Text("Regredir"),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: order.data["status"] >= 4 ? Colors.red : Colors.green[500] ,
                        onPressed: order.data["status"] < 5 ? () {
                          order.reference.updateData({"status": order.data["status"] + 1});
                        } : null,
                        textColor: Colors.white,
                        child: Text(
                          order.data["status"] >= 4 ? "Cancelar": "Avançar"
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

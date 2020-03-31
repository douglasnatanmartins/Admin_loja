import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/widgets/novidades_tile.dart';

class NovidadesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("home").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation(Colors.white)
        )
        );
        return ListView.builder(
            itemCount:  snapshot.data.documents.length,
            itemBuilder:(context, index){
              return NovidadesTile(snapshot.data.documents[index]);
            }
        );
      },
    );
  }
}

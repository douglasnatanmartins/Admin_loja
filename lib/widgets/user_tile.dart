import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {
  final _textStyle = TextStyle(color: Colors.white,
  fontSize: 12);
  final Map<String, dynamic> user;

  UserTile(this.user);

  @override
  Widget build(BuildContext context) {

    if(user.containsKey("money"))
    return ListTile(
      contentPadding: EdgeInsets.only(left: 8, right: 8),
      title: Text(
        user["name"],
        style: _textStyle
      ),
      subtitle: Text(
          user["phone"],
          style: _textStyle
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Pedidos: ${user["orders"]}",
            style: _textStyle
          ),
          Text(
            "Gastos: R\$ ${user["money"].toStringAsFixed(2)}",
            style: _textStyle
          ),
        ],
      ),
    );
    else
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),

                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey),
            ),
            SizedBox(
              width: 50,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),

                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey),
            )
          ],
        ),
      );
  }
}

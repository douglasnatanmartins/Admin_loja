import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciadorloja/blocs/orders_bloc.dart';
import 'package:gerenciadorloja/blocs/user_bloc.dart';
import 'package:gerenciadorloja/tabs/orders_tab.dart';
import 'package:gerenciadorloja/tabs/products_tab.dart';
import 'package:gerenciadorloja/tabs/users_tab.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;


  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _userBloc = UserBloc();
    _ordersBloc = OrdersBloc();

  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.purple,
          primaryColor: Colors.grey[800],
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54)
          )
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          selectedItemColor: Colors.white,
          onTap: (p){
            _pageController.animateToPage(
                p,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Clientes")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text("Pedidos")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                title: Text("Produtos")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text("Configurções")
            ),
          ]
        ),
      ),
      body: SafeArea( // desconsidera a barra do telefone
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p){
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[
                UsersTab(),
                OrdersTab(),
               ProductsTab(),
                Container(color: Colors.yellow),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }
  Widget _buildFloating(){
    switch(_page){
      case 0:
        return null;
      case 1:
        return SpeedDial(
          animationSpeed: 1,
          child: Icon(Icons.sort),
          backgroundColor: Colors.purple,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(Icons.arrow_downward, color: Colors.purple),
              backgroundColor: Colors.white,
              label: "Concluidos Abaixo",
              labelStyle: TextStyle(fontSize: 14),
              onTap: (){
                _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
              }
            ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.purple),
                backgroundColor: Colors.white,
                label: "Concluidos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                    _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);

                }
            ),
          ]
          ,
        );
    }
  }

}

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorloja/blocs/orders_bloc.dart';
import 'package:gerenciadorloja/blocs/user_bloc.dart';
import 'package:gerenciadorloja/tabs/orders_tab.dart';
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
                icon: Icon(Icons.format_list_numbered),
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
                Container(color: Colors.green),
                Container(color: Colors.yellow),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

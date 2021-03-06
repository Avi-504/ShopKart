// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<Auth>(context, listen: false).username;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'hello $userName!',
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.add_shopping_cart,
              ),
              title: Text(
                'Shop',
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.payment,
              ),
              title: Text(
                'Orders',
              ),
              onTap: () {
                // Navigator.of(context)
                // .pushReplacementNamed(OrdersScreen.routeName);
                Navigator.of(context).pushReplacement(CustomRoute(
                  builder: (context) => OrdersScreen(),
                ));
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.mode_edit,
              ),
              title: Text(
                'Manage Products',
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
              ),
              title: Text(
                'LogOut',
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isInit = true;
  // var _isLoading = false;
  // @override
  // void didChangeDependencies() {
  //   // if (_isInit) {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   Provider.of<Orders>(context).fetchNSaveOrders().then((_) {
  //   //     setState(() {
  //   //       _isLoading = false;
  //   //     });
  //   //   });
  //   // }
  //   // _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchNSaveOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('An Error Occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) => OrderItems(
                    orderData.orders[index],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

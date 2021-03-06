import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchNSaveProducts(true);
    // print('inuserPrpoductScreen');
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Products',
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.add_box,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (context, index) =>
                              productsData.items.isEmpty
                                  ? Center(
                                      child: Text('No Products'),
                                    )
                                  : UserProductItem(
                                      title: productsData.items[index].title,
                                      imgUrl: productsData.items[index].imgUrl,
                                      price: productsData.items[index].price,
                                      id: productsData.items[index].id,
                                    ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
